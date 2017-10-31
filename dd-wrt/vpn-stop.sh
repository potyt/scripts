#!/bin/sh

PATH=/jffs/scripts:$PATH

idx=$1

pid=""
pidfile=/var/tmp/openvpn-$idx.pid
if [[ -r $pidfile ]]; then
    log.sh "Found pidfile $pidfile"
    pid=$(cat $pidfile)
    rm -f $pidfile
    pid=$(ps | grep openvpn | grep client-$idx | grep $pid | sed "s/^[ \t]*//" | cut -d" " -f1)
fi

if [[ ! "$pid" ]]; then
    log.sh "No valid pid found, searching process table"
    pid=$(ps | grep openvpn | grep client-$idx | sed "s/^[ \t]*//" | cut -d" " -f1)
fi

if [[ $pid ]]; then
    log.sh "Killing pid $pid"
    kill $pid 2>/dev/null
    if [[ $? = 0 ]]; then
        sleep 10
        kill -9 $pid 2>/dev/null
    else
        log.sh "Can't find process $pid to kill"
    fi
else
    log.sh "Can't find pid to kill"
fi

conf=/jffs/etc/openvpn/client-$idx.conf
host=$(egrep "^# *remote " $conf | cut -d' ' -f3)
Ip=$(ip.sh $host)
if [[ $Ip ]]; then
    firewall-hole.sh $Ip D
else
    log.sh "Can't get IP for $host"
    exit 1
fi
