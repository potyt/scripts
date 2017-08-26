#!/bin/sh

PATH=/jffs/scripts:$PATH

idx=$1

pidfile=/var/tmp/openvpn-$idx.pid
if [[ -r $pidfile ]]; then
    pid=$(cat $pidfile)
    rm -f $pidfile
    if [[ -n $dns ]]; then
        log.sh "Killing pid $pid"
        kill $pid
        sleep 10
        kill -9 $pid
    else
        log.sh "Can't find pid to kill"
    fi
else
    log.sh "Can't find pidfile $pidfile"
fi

conf=/jffs/etc/openvpn/client-$idx.conf
host=$(egrep "^# *remote " $conf | cut -d' ' -f3)
Ip=$(ip.sh $host)
if [[ -n $Ip ]]; then
    firewall-hole.sh $Ip D
else
    log.sh "Can't get IP for $host"
    exit 1
fi
