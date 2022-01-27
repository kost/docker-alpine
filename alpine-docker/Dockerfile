FROM docker.registry/alpine:3.8

COPY repositories /etc/apk/repositories

RUN apk --no-cache --upgrade add docker coreutils openrc

COPY daemon.json /etc/docker/daemon.json

RUN echo "192.168.58.121  docker.registry docker-local.registry docker-remote.registry">>/etc/hosts \
	&& rc-update add docker && /etc/init.d/docker restart

