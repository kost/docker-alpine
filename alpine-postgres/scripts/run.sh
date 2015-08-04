#!/bin/sh

: ${PGDATA:=/var/lib/postgresql/data}
: ${POSTGRES_USER:="postgres"}
: ${POSTGRES_DB:=$POSTGRES_USER}

setupdb() {
	if [ -z "$(ls -A "$PGDATA")" ]; then
		echo "[i] Creating a new PostgreSQL database cluster"
		if [ -d "$PGDATA" ]; then
			 chown -Rf postgres:postgres "${PGDATA}"
		fi
		gosu postgres initdb $PGDATA
		sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" "$PGDATA"/postgresql.conf
		createdb
		adduser
	else 
		echo "[i] Directory already exists, not creating initial database"
		if [ "$POSTGRES_FIX_OWNERSHIP" = "" ]; then
			echo "[i] Not touching ownerships, if you want it - set POSTGRES_FIX_OWNERSHIP=1"
		else
			echo "[i] Touching ownerships"
			chown -Rf postgres:postgres "${PGDATA}" 
			chmod 0700 "${PGDATA}" 
		fi
	fi
}

adduser() {
	echo "[i] Adding users"
	if [ "$POSTGRES_PASSWORD" ]; then
		pass="PASSWORD '$POSTGRES_PASSWORD'"
		authMethod=md5
	else
		echo "[!] use POSTGRES_PASSWORD to set postgres password"
		pass=
		authMethod=trust
	fi

	# echo not needed, enabled by default
	# { echo; echo "local all all 127.0.0.1/8 trust"; } >> "$PGDATA"/pg_hba.conf

	{ echo; echo "host all all 0.0.0.0/0 $authMethod"; } >> "$PGDATA"/pg_hba.conf

	if [ "$POSTGRES_USER" != 'postgres' ]; then
		op=CREATE
		userSql="$op USER $POSTGRES_USER WITH $pass;"
		echo $userSql | gosu postgres postgres --single -jE
		grantSql="GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;"
		echo $grantSql | gosu postgres postgres --single -jE
	else
		op=ALTER
		userSql="$op USER $POSTGRES_USER WITH $pass;"
		echo $userSql | gosu postgres postgres --single -jE
	fi
}

createdb() {
	if [ "$POSTGRES_DB" != "postgres" ]; then
		echo "[i] Creating initial database: $POSTGRES_DB"
		createSql="CREATE DATABASE $POSTGRES_DB;"
		echo $createSql | gosu postgres postgres --single -jE
	fi
}

# execute any pre-init scripts, useful for images
# based on this image
for i in /scripts/pre-init.d/*sh
do
	if [ -e "${i}" ]; then
		echo "[i] pre-init.d - processing $i"
		. "${i}"
	fi
done

setupdb

# execute any pre-exec scripts, useful for images
# based on this image
for i in /scripts/pre-exec.d/*sh
do
	if [ -e "${i}" ]; then
		echo "[i] pre-exec.d - processing $i"
		. ${i}
	fi
done

echo 
echo "[i] Starting PostgreSQL..."

exec gosu postgres postgres "$@"
