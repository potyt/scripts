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
VpnGatewayNetwork="${route_vpn_gateway%?}0"
CIDR=$(cidr.sh $ifconfig_netmask)

log.sh "# Setting iptables rules"
iptables -I FORWARD -i $LanIface -o $dev -j ACCEPT
iptables -I FORWARD -i $dev -o $LanIface -j ACCEPT
iptables -I INPUT -i $dev -j ACCEPT
iptables -t nat -I POSTROUTING -o $dev -j MASQUERADE
iptables -t nat -I POSTROUTING -o $dev -j SNAT --to-source $ifconfig_local

log.sh "# Adding remote gateway route"
log.sh "ip route add $remote_1/32 via $IspGateway"
ip route add $remote_1/32 via $IspGateway

log.sh "# Adding custom table route"
log.sh "ip route add $VpnGatewayNetwork/$CIDR dev $dev src $ifconfig_local table $tbl"
ip route add $VpnGatewayNetwork/$CIDR dev $dev src $ifconfig_local table $tbl
log.sh "ip route add $LanNetwork/24 dev $LanIface table $tbl"
ip route add $LanNetwork/24 dev $LanIface table $tbl
log.sh "ip route add 127.0.0.0/8 dev lo table $tbl"
ip route add 127.0.0.0/8 dev lo table $tbl
log.sh "ip route add default via $route_vpn_gateway table $tbl"
ip route add default via $route_vpn_gateway table $tbl

log.sh "# Adding remote network route"
log.sh "ip route add $VpnGatewayNetwork/$CIDR via $route_vpn_gateway dev $dev"
ip route add $VpnGatewayNetwork/$CIDR via $route_vpn_gateway dev $dev

log.sh "# Add marking rules"
log.sh "ip rule add from $ifconfig_local table $tbl"
ip rule add from $ifconfig_local table $tbl
log.sh "ip rule add fwmark $tbl table $tbl"
ip rule add fwmark $tbl table $tbl

dns=$(echo $foreign_option_1 | grep "dhcp-option DNS" | cut -d' ' -f3)
echo $dns > /var/tmp/dns-$idx
log.sh "Contacting DNS server $dns"
ping -c1 $dns > /dev/null 2>&1

if [[ -r $routes ]]; then
    log.sh "Marking routes via table $tbl"
    grep -v '^#' $routes | grep -v '^[[:space:]]*$' | while read -r line ; do
        iptables -t mangle -I OUTPUT -d $line -j MARK --set-mark $tbl
        iptables -t mangle -I PREROUTING -d $line -j MARK --set-mark $tbl
    done
fi

if [[ -r $domains ]]; then
    if $default; then
        log.sh "Setting default DNS"
        echo "server=$dns" >> /var/tmp/dnsmasq.server-$idx.conf
    fi
    log.sh "Setting up domain-specific DNS"
    grep -v '^#' $domains | grep -v '^[[:space:]]*$' | while read -r hostname ; do
        if [[ $hostname ]]; then
            log.sh "> $hostname: $dns"
            echo "server=/$hostname/$dns" >> /var/tmp/dnsmasq.server-$idx.conf
        fi
    done
fi

if $default; then
    log.sh "Setting up default routes"
    ip route add 0.0.0.0/1 via $route_vpn_gateway
    ip route add 128.0.0.0/1 via $route_vpn_gateway
fi

ip route flush table main
ip route flush cache
