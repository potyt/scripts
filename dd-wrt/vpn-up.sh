#!/bin/sh

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

iptables -I FORWARD -i $LanIface -o $dev -j ACCEPT
iptables -I FORWARD -i $dev -o $LanIface -j ACCEPT
iptables -I INPUT -i $dev -j ACCEPT
iptables -t nat -I POSTROUTING -o $dev -j MASQUERADE
iptables -t nat -I POSTROUTING -o $dev -j SNAT --to-source $ifconfig_local

ip route add $remote_1/32 via $IspGateway

ip route add $route_network_1 dev $dev src $ifconfig_local table $tbl
ip route add $LanNetwork/24 dev $LanIface table $tbl
ip route add 127.0.0.0/8 dev lo table $tbl
ip route add default via $ifconfig_remote table $tbl

ip route add $route_network_1 via $ifconfig_remote dev $dev

ip rule add from $ifconfig_local table $tbl
ip rule add fwmark $tbl table $tbl

dns=$(echo $foreign_option_1 | grep "dhcp-option DNS" | cut -d' ' -f3)
echo $dns > /var/tmp/dns-$idx
echo Contacting DNS server $dns
ping -c1 $dns > /dev/null 2>&1

if [[ -r $routes ]]; then
    echo "Marking routes via table $tbl"
    grep -v '^#' $routes | grep -v '^[[:space:]]*$' | while read -r line ; do
        iptables -t mangle -I OUTPUT -d $line -j MARK --set-mark $tbl
        iptables -t mangle -I PREROUTING -d $line -j MARK --set-mark $tbl
    done
fi

if [[ -r $domains ]]; then
    if $default; then
        echo "Setting default DNS"
        echo "server=$dns" >> /var/tmp/dnsmasq.server-$idx.conf
    fi
    echo "Setting up domain-specific DNS"
    grep -v '^#' $domains | grep -v '^[[:space:]]*$' | while read -r line ; do
        hostname=$line
        if [[ -n $hostname ]]; then
            echo "server=/$line/$dns" >> /var/tmp/dnsmasq.server-$idx.conf
        fi
    done
fi

if $default; then
    echo "Setting up default routes"
    ip route add 0.0.0.0/1 via $ifconfig_remote
    ip route add 128.0.0.0/1 via $ifconfig_remote
fi

ip route flush cache
