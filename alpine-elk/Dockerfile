FROM jolokia/alpine-jre-8
MAINTAINER kost, https://github.com/kost/docker-alpine

# Set environment variables
ENV ES_NAME elasticsearch
ENV ELASTICSEARCH_VERSION 1.7.1
ENV ELASTICSEARCH_URL https://download.elastic.co/$ES_NAME/$ES_NAME/$ES_NAME-$ELASTICSEARCH_VERSION.tar.gz

ENV LOGSTASH_NAME logstash
ENV LOGSTASH_VERSION 1.5.3
ENV LOGSTASH_URL https://download.elastic.co/$LOGSTASH_NAME/$LOGSTASH_NAME/$LOGSTASH_NAME-$LOGSTASH_VERSION.tar.gz

ENV KIBANA_VERSION 4.1.1
ENV KIBANA_NAME kibana
ENV KIBANA_PKG $KIBANA_NAME-$KIBANA_VERSION-linux-x64
ENV KIBANA_CONFIG /opt/$KIBANA_NAME-$KIBANA_VERSION-linux-x64/config/kibana.yml
ENV KIBANA_URL https://download.elastic.co/$KIBANA_NAME/$KIBANA_NAME/$KIBANA_PKG.tar.gz


# Download Elasticsearch
RUN apk add --update openssl nodejs bash \
    && mkdir -p /opt \  
    && echo "[i] Building elasticsearch" \
    && echo -O /tmp/$ES_NAME-$ELASTICSEARCH_VERSION.tar.gz $ELASTICSEARCH_URL \
    && wget -O /tmp/$ES_NAME-$ELASTICSEARCH_VERSION.tar.gz $ELASTICSEARCH_URL \
    && tar -xzf /tmp/$ES_NAME-$ELASTICSEARCH_VERSION.tar.gz -C /opt/ \
    && ln -s /opt/$ES_NAME-$ELASTICSEARCH_VERSION /opt/$ES_NAME \
    && mkdir /var/lib/elasticsearch \
    && echo "[i] Building logstash" \
    && wget -O /tmp/$LOGSTASH_NAME-$LOGSTASH_VERSION.tar.gz $LOGSTASH_URL \
    && tar xzf /tmp/$LOGSTASH_NAME-$LOGSTASH_VERSION.tar.gz -C /opt/ \
    && ln -s /opt/$LOGSTASH_NAME-$LOGSTASH_VERSION /opt/$LOGSTASH_NAME \
    && mkdir /etc/$LOGSTASH_NAME \
    && echo "[i] Building kibana" \
    && wget -O /tmp/$KIBANA_PKG.tar.gz $KIBANA_URL \
    && tar -xzf /tmp/$KIBANA_PKG.tar.gz -C /opt/ \
    && ln -s /opt/$KIBANA_PKG /opt/$KIBANA_NAME \
    && rm -rf /opt/$KIBANA_PKG/node/ \
    && mkdir -p /opt/$KIBANA_PKG/node/bin/ \
    && ln -s $(which node) /opt/$KIBANA_NAME/node/bin/node \
    && echo "[i] Finishing" \
    && rm -rf /tmp/*.tar.gz /var/cache/apk/* \
    && echo "[i] Done"

# Add files
COPY config/elasticsearch.yml /opt/elasticsearch/config/elasticsearch.yml
ADD config/logstash.json /etc/$LOGSTASH_NAME/$LOGSTASH_NAME.json
ADD scripts /scripts

# Specify Volume
VOLUME ["/var/lib/elasticsearch"]

# Exposes
EXPOSE 9200 9300 5601 514 514/udp 8080

# CMD
ENTRYPOINT ["/scripts/run.sh"]
