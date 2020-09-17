#!/bin/sh

dir=/jffs/scripts
PATH=$dir:$PATH
export PATH

IspGateway=$(ip route list table main | awk '/default/ { print $3}')
WanIface=$(get_wanface)

while read iface; do
    idx=$(echo ${iface//[a-zA-Z]/})
    tbl=$((100+$idx))

    BypassNetwork=$(route -n | grep $iface | awk '{ print $1}')

    log.sh "# Add bypass iptables rules $iface $BypassNetwork"
    log.sh "iptables -I FORWARD -i $iface -o $WanIface -j ACCEPT"
    iptables -I FORWARD -i $iface -o $WanIface -j ACCEPT
    log.sh "iptables -I FORWARD -i $WanIface -o $iface -j ACCEPT"
    iptables -I FORWARD -i $WanIface -o $iface -j ACCEPT
    log.sh "iptables -t mangle -I OUTPUT -s $BypassNetwork/24 -j MARK --set-mark $tbl"
    iptables -t mangle -I OUTPUT -s $BypassNetwork/24 -j MARK --set-mark $tbl
    log.sh "iptables -t mangle -I PREROUTING -s $BypassNetwork/24 -j MARK --set-mark $tbl"
    iptables -t mangle -I PREROUTING -s $BypassNetwork/24 -j MARK --set-mark $tbl

    log.sh "# Add bypass marking rules"
    log.sh "ip rule add from $BypassNetwork/24 table $tbl"
    ip rule add from $BypassNetwork/24 table $tbl
    log.sh "ip rule add fwmark $tbl table $tbl"
    ip rule add fwmark $tbl table $tbl

    log.sh "# Add bypass custom table route"
    log.sh "ip route add $BypassNetwork/24 dev $iface table $tbl"
    ip route add $BypassNetwork/24 dev $iface table $tbl
    log.sh "ip route add 127.0.0.0/8 dev lo table $tbl"
    ip route add 127.0.0.0/8 dev lo table $tbl
    log.sh "ip route add default via $IspGateway table $tbl"
    ip route add default via $IspGateway table $tbl
done < /jffs/etc/bypass.iface

ip route flush cache

exit 0
