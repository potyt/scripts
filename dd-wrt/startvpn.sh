#!/bin/sh

dir="/jffs/scripts/"

def="-d"
for conf in /jffs/etc/openvpn/client-*.conf; do
    remote=`grep "^remote " $conf | cut -d' ' -f2`
    $dir/firewall-hole.sh $remote I

    routes=${conf/conf-/route-}
    openvpn --config $conf --route-noexec --up "$dir/vpn-up.sh -r $routes $def" --down "$dir/vpn-down.sh -r $routes $def" --down-pre --log /var/log/openvpn --daemon
    sleep 10
    def=""
done
