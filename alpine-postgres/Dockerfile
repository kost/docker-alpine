FROM gliderlabs/alpine
MAINTAINER kost - https://github.com/kost

RUN apk --update add postgresql openssl && rm -f /var/cache/apk/* && \
 wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.4/gosu-amd64" && \
 chmod +x /usr/local/bin/gosu && \
 echo "Success"

ADD scripts/run.sh /scripts/run.sh
RUN mkdir /scripts/pre-exec.d && \
 mkdir /scripts/pre-init.d && \
 chmod -R 755 /scripts

ENV LANG en_US.utf8
ENV PGDATA /var/lib/postgresql/data
VOLUME ["/var/lib/postgresql/data"]

EXPOSE 5432

ENTRYPOINT ["/scripts/run.sh"]

