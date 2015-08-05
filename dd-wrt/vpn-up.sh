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
CIDR=$(cidr.sh $ifconfig_netmask)

echo "# Setting iptables rules"
iptables -I FORWARD -i $LanIface -o $dev -j ACCEPT
iptables -I FORWARD -i $dev -o $LanIface -j ACCEPT
iptables -I INPUT -i $dev -j ACCEPT
iptables -t nat -I POSTROUTING -o $dev -j MASQUERADE
iptables -t nat -I POSTROUTING -o $dev -j SNAT --to-source $ifconfig_local

echo "# Adding remote gateway route"
ip route add $remote_1/32 via $IspGateway

echo "# Adding custom table route"
ip route add $route_vpn_gateway/$CIDR dev $dev src $ifconfig_local table $tbl
ip route add $LanNetwork/24 dev $LanIface table $tbl
ip route add 127.0.0.0/8 dev lo table $tbl
ip route add default via $route_vpn_gateway table $tbl

echo "# Adding remote network route"
ip route add $route_vpn_gateway/$CIDR via $route_vpn_gateway dev $dev

echo "# Add marking rules"
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
    grep -v '^#' $domains | grep -v '^[[:space:]]*$' | while read -r hostname ; do
        if [[ $hostname ]]; then
            echo "- $hostname: $dns"
            echo "server=/$hostname/$dns" >> /var/tmp/dnsmasq.server-$idx.conf
        fi
    done
fi

if $default; then
    echo "Setting up default routes"
    ip route add 0.0.0.0/1 via $route_vpn_gateway
    ip route add 128.0.0.0/1 via $route_vpn_gateway
fi

ip route flush cache
