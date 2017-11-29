#!/bin/sh

host=$(hostname)

if [ ! -d /etc/openldap/slapd.d ]; then
  FIRST_START=1
  echo "Configuring OpenLDAP via slapd.d"
  mkdir /etc/openldap/slapd.d
  chmod 750 /etc/openldap/slapd.d
  echo "SLAPD_CONFIG_ROOTDN = $SLAPD_CONFIG_ROOTDN"
  if [ -z "$SLAPD_CONFIG_ROOTDN" ]; then
    echo -n >&2 "Error: SLAPD_CONFIG_ROOTDN not set. "
    echo >&2 "Did you forget to add -e SLAPD_CONFIG_ROOTDN=... ?"
    exit 1
  fi
  if [ -z "$SLAPD_CONFIG_ROOTPW" ]; then
    echo -n >&2 "Error: SLAPD_CONFIG_ROOTPW not set. "
    echo >&2 "Did you forget to add -e SLAPD_CONFIG_ROOTPW=... ?"
    exit 1
  fi

  config_rootpw_hash=`slappasswd -s "${SLAPD_CONFIG_ROOTPW}"`
  printf "$SLAPD_CONFIG_ROOTPW" > /slapd_config_rootpw
  chmod 400 /slapd_config_rootpw

  # builtin schema
  cat <<-EOF >> /tmp/slapd.conf
  include /etc/openldap/schema/core.schema
  include /etc/openldap/schema/dyngroup.schema
  include /etc/openldap/schema/cosine.schema
  include /etc/openldap/schema/inetorgperson.schema
  include /etc/openldap/schema/openldap.schema
  include /etc/openldap/schema/corba.schema
  include /etc/openldap/schema/pmi.schema
  include /etc/openldap/schema/ppolicy.schema
  include /etc/openldap/schema/misc.schema
  include /etc/openldap/schema/nis.schema
  EOF

  # user-provided schemas
  if [ -d "/ldap/schemas" ]; then
    for f in /ldap/schema/*.schema ; do
      echo "Including custom schema $f"
      echo "include $f" >> /tmp/slapd.conf
    done
  fi

  CA_KEY=/ldap/pki/ca_key.pem
  CA_EXPIRE=365
  CA_CERT=/ldap/pki/ca_cert.pem
  CA_SUBJECT="openldap-alpine-${host}-CA"

  SSL_SUBJECT="openldap-alpine-${host}"
  SSL_EXPIRE=365
  SSL_KEY=/ldap/pki/key.pem
  SSL_SIZE=2048
  SSL_CERT=/ldap/pki/cert.pem
  SSL_CSR=/ldap/pki/cert.csr
  SSL_CONFIG=/ldap/pki/openssl.cnf

  # user-provided tls certs
  echo "Configuring PKI"
  if [ ! -d "/ldap/pki" ] ; then
    echo "No /ldap/pki directory, generating self-signed certs"
    mkdir -p /ldap/pki
    # CA
    openssl genrsa -out ${CA_KEY} 2048
    openssl req -x509 -new -nodes -key ${CA_KEY} -days ${CA_EXPIRE} -out ${CA_CERT} -subj "/CN=${CA_SUBJECT}"
    
    # server
    cat > ${SSL_CONFIG} <<-EOF
    [req]
    req_extensions = v3_req
    distinguished_name = req_distinguished_name
    [req_distinguished_name]
    [ v3_req ]
    basicConstraints = CA:FALSE
    keyUsage = nonRepudiation, digitalSignature, keyEncipherment
    extendedKeyUsage = clientAuth, serverAuth
    EOF

    openssl genrsa -out ${SSL_KEY} ${SSL_SIZE}
    openssl req -new -key ${SSL_KEY} -out ${SSL_CSR} -subj "/CN=${SSL_SUBJECT}" -config ${SSL_CONFIG} 
    openssl x509 -req -in ${SSL_CSR} -CA ${CA_CERT} -CAkey ${CA_KEY} -CAcreateserial -out ${SSL_CERT} \
          -days ${SSL_EXPIRE} -extensions v3_req -extfile ${SSL_CONFIG}
  fi

  echo "TLSCACertificateFile ${CA_CERT}" >> /tmp/slapd.conf
  echo "TLSCertificateFile ${SSL_CERT}" >> /tmp/slapd.conf
  echo "TLSCertificateKeyFile ${SSL_KEY}" >> /tmp/slapd.conf
  echo "TLSCipherSuite HIGH:-SSLv2:-SSLv3" >> /tmp/slapd.conf

  cat <<-EOF >> /tmp/slapd.conf
  database config
  rootDN "$SLAPD_CONFIG_ROOTDN"
  rootpw $config_rootpw_hash
  EOF

  echo "Generating configuration"
  slaptest -f /tmp/slapd.conf -F /etc/openldap/slapd.d
fi

chown -R ldap:ldap /etc/openldap/slapd.d/

echo "Starting slapd with $@"
exec "$@" &

if [ $FIRST_START -eq 1 ] ; then
  # handle race condition
  echo "Waiting for server to start"
  let i=0
  while [ $i -lt 60 ]; do
    printf "."
    ldapsearch -x -h localhost -s base -b '' >/dev/null 2>&1
    test $? -eq 0 && break
    sleep 1
  done
  echo
  echo "Adding additional config from /ldap/ldif/*.ldif"
  for f in /ldap/ldif/*.ldif ; do
    echo "> $f"
    ldapmodify -x -H ldap://localhost -y /slapd_config_rootpw -D ${SLAPD_CONFIG_ROOTDN} -f $f
  done

  if [ -d /ldap/userldif ] ; then
    echo "Adding user config from /ldap/userldif/*.ldif"
    for f in /ldap/userldif/*.ldif ; do
      echo "> $f"
      ldapmodify -x -H ldap://localhost -y /slapd_config_rootpw -D ${SLAPD_CONFIG_ROOTDN} -f $f
    done
  fi
fi

echo READY

while true ; do sleep 60 ; done ;
