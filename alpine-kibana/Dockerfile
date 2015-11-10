FROM alpine:3.2
MAINTAINER kost, https://github.com/kost/docker-alpine

# Set environment variables
ENV KIBANA_VERSION 4.1.1
ENV PKG_NAME kibana
ENV PKG_PLATFORM linux-x64
ENV KIBANA_PKG $PKG_NAME-$KIBANA_VERSION-$PKG_PLATFORM
ENV KIBANA_CONFIG /opt/$PKG_NAME-$KIBANA_VERSION-$PKG_PLATFORM/config/kibana.yml
ENV KIBANA_URL https://download.elastic.co/$PKG_NAME/$PKG_NAME/$KIBANA_PKG.tar.gz
ENV ELASTICSEARCH_HOST elasticsearch

# Download Kibana
RUN apk add --update ca-certificates wget nodejs \
    && mkdir -p /opt \
    && wget -O /tmp/$KIBANA_PKG.tar.gz $KIBANA_URL \
    && tar -xvzf /tmp/$KIBANA_PKG.tar.gz -C /opt/ \
    && ln -s /opt/$KIBANA_PKG /opt/$PKG_NAME \
    && sed -i "s/localhost/$ELASTICSEARCH_HOST/" $KIBANA_CONFIG \
    && rm -rf /tmp/*.tar.gz /var/cache/apk/* /opt/$KIBANA_PKG/node/ \
    && mkdir -p /opt/$KIBANA_PKG/node/bin/ \
    && ln -s $(which node) /opt/$PKG_NAME/node/bin/node

# Expose
EXPOSE 5601

USER nobody

# Working directory
WORKDIR ["/opt/kibana"]
CMD ["/opt/kibana/bin/kibana"]
