#!/bin/sh

PATH=/jffs/scripts:$PATH

idx=$1

pidfile=/var/tmp/openvpn-$idx.pid
if [[ -r $pidfile ]]; then
    pid=$(cat $pidfile)
    rm -f $pidfile
    if [[ -n $dns ]]; then
        kill $pid
    fi
fi

conf=/jffs/etc/openvpn/client-$idx.conf
remote=$(grep "^remote " $conf | cut -d' ' -f
firewall-hole.sh $remote D
