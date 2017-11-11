#!/bin/sh

dir=/jffs/scripts
PATH=$dir:$PATH
export PATH

routes=""
domains=""
default=false
while getopts ":r:d:z" opt; do
    case $opt in
        r)
            routes=$OPTARG
            ;;
        d)
            domains=$OPTARG
            ;;
        z)
            default=true
            ;;
    esac
done

idx=$(echo ${dev//[a-zA-Z]/})
tbl=$((10+$idx))

IspGateway=$(ip route list table main | awk '/default/ { print $3}')
LanIp=$(nvram get lan_ipaddr)
LanNetwork="${LanIp%?}0"
LanIface=$(nvram get lan_ifname)

iptables -t nat -D POSTROUTING -o $dev -j SNAT --to-source $ifconfig_local
iptables -t nat -D POSTROUTING -o $dev -j MASQUERADE
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

dns=$(echo $foreign_option_1 | grep "dhcp-option DNS" | cut -d' ' -f3)
rm /var/tmp/dns-$idx

if [[ -r $routes ]]; then
    grep -v '^#' $routes | grep -v '^[[:space:]]*$' | while read -r line ; do
        iptables -t mangle -D PREROUTING -d $line -j MARK --set-mark $tbl
        iptables -t mangle -D OUTPUT -d $line -j MARK --set-mark $tbl
    done
fi

rm -f /var/tmp/dnsmasq.server-$idx.conf

if $default; then
    log.sh "Tearing down default routes"
    ip route delete 0.0.0.0/1 via $ifconfig_remote
    ip route delete 128.0.0.0/1 via $ifconfig_remote
fi

ip route flush cache

pidfile=/var/tmp/openvpn-$idx.pid

rm -f $pidfile

exit 0
