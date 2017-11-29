#!/bin/sh

FIFO=/tmp/blockme
source /etc/default/gitlab

# name resolution for gitlab-shell (docker overwrites /etc/hosts)
HOST_LINE="127.0.0.1 $DOMAIN"
[ -z `grep "$HOST_LINE" /etc/hosts` ] && echo "$HOST_LINE" >>/etc/hosts

terminate () {
    echo 'Received SIGTERM. Terminating Gitlab processes...'
    pkill sshd
    nginx -s stop
    sudo -u $USER /etc/init.d/gitlab stop
    sudo -u redis redis-cli -s $SOCKET shutdown
    sudo -u postgres pg_ctl stop --mode smart --pgdata $DIR/data
    echo 'stop' >$FIFO
    wait
    exit 0
}

trap terminate SIGTERM

# run all stuff
nginx
/usr/sbin/sshd
sudo -u redis redis-server $DIR/config/redis.conf
sudo -u postgres pg_ctl start --pgdata $DIR/data
sudo -u $USER /etc/init.d/gitlab start

# spawn blocked child
[ -p $FIFO ] || mkfifo $FIFO
/bin/sh -c "read <$FIFO" &

# collect zombies
wait
