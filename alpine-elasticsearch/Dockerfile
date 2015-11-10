FROM jolokia/alpine-jre-8
MAINTAINER kost, https://github.com/kost/docker-alpine

# Set environment variables
ENV PKG_NAME elasticsearch
ENV ELASTICSEARCH_VERSION 1.7.1
ENV ELASTICSEARCH_URL https://download.elastic.co/$PKG_NAME/$PKG_NAME/$PKG_NAME-$ELASTICSEARCH_VERSION.tar.gz

# Download Elasticsearch
RUN apk update \
    && apk add openssl \
    && mkdir -p /opt \  
    && echo -O /tmp/$PKG_NAME-$ELASTICSEARCH_VERSION.tar.gz $ELASTICSEARCH_URL \
    && wget -O /tmp/$PKG_NAME-$ELASTICSEARCH_VERSION.tar.gz $ELASTICSEARCH_URL \
    && tar -xvzf /tmp/$PKG_NAME-$ELASTICSEARCH_VERSION.tar.gz -C /opt/ \
    && ln -s /opt/$PKG_NAME-$ELASTICSEARCH_VERSION /opt/$PKG_NAME \
    && rm -rf /tmp/*.tar.gz /var/cache/apk/* \
    && mkdir /var/lib/elasticsearch \
    && chown nobody /var/lib/elasticsearch

# Add files
COPY config/elasticsearch.yml /opt/elasticsearch/config/elasticsearch.yml
COPY scripts/run.sh /scripts/run.sh

# Specify Volume
VOLUME ["/var/lib/elasticsearch"]

# Exposes
EXPOSE 9200
EXPOSE 9300

USER nobody

# CMD
ENTRYPOINT ["/scripts/run.sh"]
