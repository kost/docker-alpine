#!/bin/sh

# execute any pre-init scripts, useful for images
# based on this image
for i in /scripts/pre-init.d/*sh
do
	if [ -e "${i}" ]; then
		echo "[i] pre-init.d - processing $i"
		. "${i}"
	fi
done

if [ -f $LOGSTASH_CONFIG ]; then
	echo "[i] Config file exists." 
else
	if [ "$ELASTICSEARCH_NAME" == "" ]; then
		echo "[i] New container without linked elasticsearch. Output is to stdout"
		ln -sf $LOGSTASH_CONFIG.basic $LOGSTASH_CONFIG
	else
		echo "[i] New container with elasticsearch. Output is to stdout and elasticsearch."
		ln -sf $LOGSTASH_CONFIG.es $LOGSTASH_CONFIG
	fi	
fi

# execute any pre-exec scripts, useful for images
# based on this image
for i in /scripts/pre-exec.d/*sh
do
	if [ -e "${i}" ]; then
		echo "[i] pre-exec.d - processing $i"
		. ${i}
	fi
done

echo "[i] Starting logstash"
/opt/$LOGSTASH_NAME/bin/logstash -f $LOGSTASH_CONFIG
echo "[i] Logstash finished"
