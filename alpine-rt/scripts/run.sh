#!/bin/sh

RTCONF="/opt/rt4/etc/RT_SiteConfig.pm"
MAXTRIES=20


# execute any pre-init scripts, useful for images
# based on this image
for i in /scripts/pre-init.d/*sh
do
	if [ -e "${i}" ]; then
		echo "[i] pre-init.d - processing $i"
		. "${i}"
	fi
done

wait4mysql () {
echo "[i] Waiting for database to setup..."

for i in $(seq 1 1 $MAXTRIES)
do
	echo "[i] Trying to connect to database: try $i..."
	if [ "$DB_ENV_MYSQL_PASSWORD" = "" ]; then
		mysql -B --connect-timeout=1 -h db -u $DB_ENV_MYSQL_USER -e "SELECT VERSION();" $DB_ENV_MYSQL_DATABASE 
	else
		mysql -B --connect-timeout=1 -h db -u $DB_ENV_MYSQL_USER -p$DB_ENV_MYSQL_PASSWORD -e "SELECT VERSION();" $DB_ENV_MYSQL_DATABASE 
	fi

	if [ "$?" = "0" ]; then
		echo "[i] Successfully connected to database!"
		break
	else
		if [ "$i" = "$MAXTRIES" ]; then
			echo "[!] You need to have container for database. Take a look at docker-compose.yml file!"
			exit 0
		else
			sleep 5
		fi
	fi
done
}

wait4psql () {
echo "[i] Waiting for database to setup..."

export PGPASSWORD=$DB_ENV_POSTGRES_PASSWORD
for i in $(seq 1 1 $MAXTRIES)
do
	echo "[i] Trying to connect to database: try $i..."
	psql -h db -U $DB_ENV_POSTGRES_USER -d $DB_ENV_POSTGRES_DB -w -c 'SELECT version();'
	if [ "$?" = "0" ]; then
		echo "[i] Successfully connected to database!"
		break
	else
		if [ "$i" = "$MAXTRIES" ]; then
			echo "[!] You need to have container for database. Take a look at docker-compose.yml file!"
			exit 0
		else
			sleep 5
		fi
	fi
done
}

# set apache as owner/group
# chown -R apache:apache /app


if [ -f /opt/rt4/db.initialized ]; then
	echo "[i] Database already initialized. Not touching database!"
else
	echo "[i] Database not initialized"
	echo "Set(\$rtname, 'example.com');" > $RTCONF
	echo "Set(\$DatabaseHost,   'db');" >> $RTCONF
	echo "Set(\$DatabaseRTHost, 'localhost');" >> $RTCONF

	FOUND_DB=0
	if [ "$DB_ENV_MYSQL_USER" != "" ]; then
		echo "[i] Found MySQL setup"
		echo "Set(\$DatabaseType, 'mysql');" >> $RTCONF
		echo "Set(\$DatabaseUser, '$DB_ENV_MYSQL_USER');" >> $RTCONF
		echo "Set(\$DatabasePassword, '$DB_ENV_MYSQL_PASSWORDr');" >> $RTCONF
		echo "Set(\$DatabaseName, '$DB_ENV_MYSQL_DATABASE');" >> $RTCONF
		FOUND_DB=1
		wait4mysql
	fi

	if [ "$DB_ENV_POSTGRES_USER" != "" ]; then
		echo "[i] Found PostgreSQL setup"
		echo "Set(\$DatabaseType, 'Pg');" >> $RTCONF
		echo "Set(\$DatabaseUser, '$DB_ENV_POSTGRES_USER');" >> $RTCONF
		echo "Set(\$DatabasePassword, '$DB_ENV_POSTGRESS_PASSWORD');" >> $RTCONF
		echo "Set(\$DatabaseName, '$DB_ENV_POSTGRES_DB');" >> $RTCONF
		FOUND_DB=1
		wait4psql
	fi

	if [ "$FOUND_DB" = "0" ]; then
		echo "[i] Container not linked with DB. Using SQLite."
		echo "Set(\$DatabaseType, 'SQLite');" >> $RTCONF
	fi

	for i in /scripts/pre-initdb.d/*sh
	do
		if [ -e "${i}" ]; then
			echo "[i] pre-initdb.d - processing $i"
			. "${i}"
		fi
	done

	echo "1;" >> $RTCONF

	echo "[i] Initializing database"
	/opt/rt4/sbin/rt-setup-database --action init --skip-create
	touch /opt/rt4/db.initialized

	for i in /scripts/post-initdb.d/*sh
	do
		if [ -e "${i}" ]; then
			echo "[i] post-initdb.d - processing $i"
			. "${i}"
		fi
	done
fi


# display logs
tail -F /var/log/lighttpd/*log &

# execute any pre-exec scripts, useful for images
# based on this image
for i in /scripts/pre-exec.d/*sh
do
	if [ -e "${i}" ]; then
		echo "[i] pre-exec.d - processing $i"
		. "${i}"
	fi
done

echo "[i] Starting daemon..."
# run daemon
lighttpd -f /etc/lighttpd/lighttpd.conf -D

killall tail
