FROM jolokia/alpine-jre-8
MAINTAINER kost, https://github.com/kost/docker-alpine

# Set environment variables
ENV LOGSTASH_NAME logstash
ENV LOGSTASH_VERSION 1.5.3
ENV LOGSTASH_URL https://download.elastic.co/$LOGSTASH_NAME/$LOGSTASH_NAME/$LOGSTASH_NAME-$LOGSTASH_VERSION.tar.gz
ENV LOGSTASH_CONFIG /opt/$LOGSTASH_NAME-$LOGSTASH_VERSION/etc/logstash.json

RUN apk update \
    && apk add bash openssl \
    && mkdir -p /opt \
    && wget -O /tmp/$LOGSTASH_NAME-$LOGSTASH_VERSION.tar.gz $LOGSTASH_URL \
    && tar xzf /tmp/$LOGSTASH_NAME-$LOGSTASH_VERSION.tar.gz -C /opt/ \
    && ln -s /opt/$LOGSTASH_NAME-$LOGSTASH_VERSION /opt/$LOGSTASH_NAME \
    && rm -rf /tmp/*.tar.gz /var/cache/apk/* \
    && mkdir -p /scripts/pre-exec.d && \
    mkdir /scripts/pre-init.d && \
    chmod -R 755 /scripts

# Add logstash config file
ADD etc /opt/$LOGSTASH_NAME-$LOGSTASH_VERSION/etc
ADD scripts /scripts

# Expose Syslog TCP and UDP ports
EXPOSE 514 514/udp 8080
WORKDIR /opt/$LOGSTASH_NAME

ENTRYPOINT ["/scripts/run.sh"]
