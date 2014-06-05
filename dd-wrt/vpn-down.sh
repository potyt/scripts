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

iptables -D POSTROUTING -t nat -o $dev -j SNAT --to-source $ifconfig_local
iptables -D POSTROUTING -t nat -o $dev -j MASQUERADE
iptables -D INPUT -i $dev -j ACCEPT
iptables -D FORWARD -i $dev -o $LanIface -j ACCEPT
iptables -D FORWARD -i $LanIface -o $dev -j ACCEPT

ip route delete $remote_1/32 via $IspGateway

ip rule delete fwmark $tbl table $tbl
ip rule delete from $fconfig_local table $tbl

ip route delete $route_network_1 via $ifconfig_remote dev $dev src

ip route delete default via $ifconfig_remote table $tbl
ip route delete 127.0.0.0/8 dev lo table $tbl
ip route delete $LanNetwork/24 dev $LanIface table $tbl
ip route delete $route_network_1 dev $dev src $ifconfig_local table $tbl

ip rule add from $ifconfig_local table $tbl
ip rule add fwmark $tbl table $tbl

if [[ -r $routes ]]; then
    grep -v '^#' $routes | grep -v '^[[:space:]]*$' | while read -r line ; do
        iptables -D PREROUTING -t mangle -d $line -j MARK --set-mark $tbl
    done
fi

if $default; then
    #iptables -D PREROUTING -t mangle -s $LanNetwork/24 -j MARK --set-mark $tbl

    echo "Tearing down default routes"
    echo ip route delete 0.0.0.0/1 via $ifconfig_remote
    echo ip route delete 128.0.0.0/1 via $ifconfig_remote
fi

ip route flush cache
