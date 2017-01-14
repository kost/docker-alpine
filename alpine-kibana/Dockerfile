FROM alpine:3.4
MAINTAINER kost, https://github.com/kost/docker-alpine

# Set environment variables
ENV KIBANA_VERSION 5.1.1
ENV PKG_NAME kibana
ENV PKG_PLATFORM linux-x86_64
ENV KIBANA_PKG $PKG_NAME-$KIBANA_VERSION-$PKG_PLATFORM
ENV KIBANA_CONFIG /opt/$PKG_NAME-$KIBANA_VERSION-$PKG_PLATFORM/config/kibana.yml
ENV KIBANA_URL https://artifacts.elastic.co/downloads/$PKG_NAME/$KIBANA_PKG.tar.gz
ENV ELASTICSEARCH_HOST elasticsearch

# add our user and group first to make sure their IDs get assigned consistently
RUN addgroup -S kibana && adduser -S -h /home/kibana -G kibana kibana

# Download Kibana
RUN apk add --update ca-certificates wget nodejs \
    && mkdir -p /opt \
    && wget -O /tmp/$KIBANA_PKG.tar.gz $KIBANA_URL \
    && tar -xvzf /tmp/$KIBANA_PKG.tar.gz -C /opt/ \
    && ln -s /opt/$KIBANA_PKG /opt/$PKG_NAME \
    && sed -ri "s!^(\#\s*)?(elasticsearch\.url:).*!\2 'http://$ELASTICSEARCH_HOST:9200'!" $KIBANA_CONFIG \
    && sed -ri "s!^(\#\s*)?(server\.host:).*!\2 '0.0.0.0'!" $KIBANA_CONFIG \
    && rm -rf /tmp/*.tar.gz /var/cache/apk/* /opt/$KIBANA_PKG/node/ \
    && mkdir -p /opt/$KIBANA_PKG/node/bin/ \
    && ln -s $(which node) /opt/$PKG_NAME/node/bin/node \
    && chown -R kibana:kibana /opt/$PKG_NAME

EXPOSE 5601

WORKDIR /opt/kibana

CMD ["/opt/kibana/bin/kibana"]
