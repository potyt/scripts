#!/bin/sh

PATH=/jffs/scripts:$PATH

idx=$1
def=$2

dir="/jffs/scripts/"

conf=/jffs/etc/openvpn/client-$idx.conf

remote=$(grep "^remote " $conf | cut -d' ' -f2)
firewall-hole.sh $remote I

client=$(basename $conf)
client=$(echo ${client/.conf/})
routes=${conf/client-/route-}
domains=${conf/client-/domain-}

def_flag=$([[ $def = 1 ]] && echo "-z" || echo "")

pidfile=/var/tmp/openvpn-$idx.pid
logfile=/var/log/openvpn-$idx.log

openvpn --config $conf --route-noexec --up "$dir/vpn-up.sh -r $routes -d $domains $def_flag" --down "$dir/vpn-down.sh -r $routes -d $domains $def_flag" --down-pre --writepid $pidfile --log $logfile --daemon
