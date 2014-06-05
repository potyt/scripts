#!/bin/sh

dir="/jffs/scripts/"

killall openvpn

for conf in /jffs/etc/openvpn/client-*.conf; do
    remote=`grep "^remote " $conf | cut -d' ' -f2`
    $dir/firewall-hole.sh $remote D
done
