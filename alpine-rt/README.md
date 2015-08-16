# k0st/alpine-rt

Multiple purpose Request Tracker (RT) from Best Practical based on Alpine

Image is based on the [gliderlabs/alpine](https://registry.hub.docker.com/u/gliderlabs/alpine/) base image

## Docker image size

[![Latest](https://badge.imagelayers.io/k0st/alpine-rt.svg)](https://imagelayers.io/?images=k0st/alpine-rt:latest 'latest')

## Docker image usage

```
docker run [docker-options] k0st/alpine-rt
```

## Examples

Typical basic usage (using SQLite if databate is not linked): 

```
docker run -it k0st/alpine-rt
```

Typical usage in Dockerfile:

```
FROM k0st/alpine-rt
RUN echo "echo "Set($WebPath, '/rt');"" /scripts/pre-initdb.d/50-rt-config.sh 
```

And shell script (50-rt-config.sh) to configure:

```
#!/bin/sh
echo "Set(\$WebPath, '/rt');" >> $RTCONF
```

Typical usage with PostgreSQL:

```
docker run -it -e POSTGRES_USER=rt -e POSTGRES_PASSWORD=rtpass -e POSTGRES_DB=rt --name=rtdb k0st/alpine-postgres
docker run -it --name rt --link rtdb:db k0st/alpine-rt
```

Typical usage with MySQL/MariaDB:

```
docker run -it -e MYSQL_USER=rt -e MYSQL_PASSWORD=rtpass -e MYSQL_DATABASE=rt --name=rtdb k0st/alpine-mariadb
docker run -it --name rt --link rtdb:db k0st/alpine-rt
```

### Todo
- [ ] Perform more testing

