# k0st/alpine-apache-app

Multiple purpose Apache and PHP image based on Alpine

Image is based on the [gliderlabs/alpine](https://registry.hub.docker.com/u/gliderlabs/alpine/) base image

## Docker image size

[![Latest](https://badge.imagelayers.io/k0st/alpine-apache-php.svg)](https://imagelayers.io/?images=k0st/alpine-apache-php:latest 'latest')

## Docker image usage

```
docker run [docker-options] k0st/alpine-apache-php
```

## Examples

Typical basic usage:

```
docker run -it k0st/alpine-apache-php
```

Typical usage in Dockerfile:

```
FROM k0st/alpine-apache-php
RUN echo "<?php phpinfo() ?>" > /app/index.php
```

Typical usage:

```
docker run -it --link=somedb:db k0st/alpine-apache-php
```

### Todo
- [ ] Check volume and data

