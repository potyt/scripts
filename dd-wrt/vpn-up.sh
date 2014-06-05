#!/bin/sh

routes=""
default=false
while getopts ":r:d" opt; do
    case $opt in
        r)
            routes=$OPTARG
            ;;
        d)
            default=true
            ;;
    esac
done

idx=`echo ${dev//[a-zA-Z]/}`
tbl=$((10+$idx))

IspGateway=$(ip route list table main | awk '/default/ { print $3}')
LanIp=`nvram get lan_ipaddr`
LanNetwork="${LanIp%?}0"
LanIface=`nvram get lan_ifname`

iptables -I FORWARD -i $LanIface -o $dev -j ACCEPT
iptables -I FORWARD -i $dev -o $LanIface -j ACCEPT
iptables -I INPUT -i $dev -j ACCEPT
iptables -I POSTROUTING -t nat -o $dev -j MASQUERADE
iptables -I POSTROUTING -t nat -o $dev -j SNAT --to-source $ifconfig_local

ip route add $remote_1/32 via $IspGateway

ip route add $route_network_1 dev $dev src $ifconfig_local table $tbl
ip route add $LanNetwork/24 dev $LanIface table $tbl
ip route add 127.0.0.0/8 dev lo table $tbl
ip route add default via $ifconfig_remote table $tbl

ip route add $route_network_1 via $ifconfig_remote dev $dev

ip rule add from $ifconfig_local table $tbl
ip rule add fwmark $tbl table $tbl

if [[ -r $routes ]]; then
    echo "Marking routes via table $tbl"
    grep -v '^#' $routes | grep -v '^[[:space:]]*$' | while read -r line ; do
        echo iptables -I PREROUTING -t mangle -d $line -j MARK --set-mark $tbl
        iptables -I PREROUTING -t mangle -d $line -j MARK --set-mark $tbl
    done
fi

if $default; then
    #echo "Marking route for $LanNetwork/24 via table $tbl"
    #iptables -I PREROUTING -t mangle -s $LanNetwork/24 -j MARK --set-mark $tbl
    echo "Setting up default routes"
    echo ip route add 0.0.0.0/1 via $ifconfig_remote
    echo ip route add 128.0.0.0/1 via $ifconfig_remote
fi

ip route flush cache
