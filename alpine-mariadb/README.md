# k0st/alpine-mariadb

Multiple purpose MariaDB/MySQL based on Alpine

Image is based on the [gliderlabs/alpine](https://registry.hub.docker.com/u/gliderlabs/alpine/) base image

## Docker image size

[![Latest](https://badge.imagelayers.io/k0st/alpine-mariadb.svg)](https://imagelayers.io/?images=k0st/alpine-mariadb:latest 'latest')

## Docker image usage

```
docker run [docker-options] k0st/alpine-mariadb 
```

Note that MySQL root will be randomly generated (using pwgen). 
Root password will be displayed, during first run using output similar to this:
```
[i] MySQL root Password: XXXXXXXXXXXXXXX
```

But you don't need root password really. If you connect locally, it should not 
ask you for password, so you can use following procedure:
```
docker exec -it mariadb_containerid /bin/sh
# mysql -u root mysql
```

## Examples

Typical usage:

```
docker run -it -v /host/dir/for/db:/var/lib/mysql -e MYSQL_DATABASE=db -e MYSQL_USER=user -e MYSQL_PASSWORD=blah k0st/alpine-mariadb
```

### Todo
- [ ] Check volume and data
- [ ] Provide more examples

