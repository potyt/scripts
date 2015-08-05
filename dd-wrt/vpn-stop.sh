#!/bin/sh

PATH=/jffs/scripts:$PATH

idx=$1

pidfile=/var/tmp/openvpn-$idx.pid
if [[ -r $pidfile ]]; then
    pid=$(cat $pidfile)
    rm -f $pidfile
    if [[ -n $dns ]]; then
        echo "Killing pid $pid"
        kill $pid
    else
        echo "Can't find pid to kill"
    fi
else
    echo "Can't find pifile $pidfile"
fi

conf=/jffs/etc/openvpn/client-$idx.conf
host=$(egrep "^# *remote " $conf | cut -d' ' -f3)
Ip=$(ip.sh $host)
if [[ -n $Ip ]]; then
    firewall-hole.sh $Ip D
else
    echo "Can't get IP for $host"
    exit 1
fi
