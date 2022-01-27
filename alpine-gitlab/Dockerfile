FROM alpine:3.6

ARG VERSION=10.0.0
ARG DOMAIN=example.com

COPY build.sh /docker/
RUN chmod +x /docker/build.sh
RUN /docker/build.sh
COPY entrypoint.sh /docker/
RUN chmod +x /docker/entrypoint.sh
VOLUME /var/opt/gitlab /var/log
ENTRYPOINT ["/docker/entrypoint.sh"]
