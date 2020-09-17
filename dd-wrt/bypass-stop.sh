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

    log.sh "# Delete bypass iptables rules $iface $BypassNetwork"
    log.sh "iptables -D FORWARD -i $iface -o $WanIface -j ACCEPT"
    iptables -D FORWARD -i $iface -o $WanIface -j ACCEPT
    log.sh "iptables -I FORWARD -i $WanIface -o $iface -j ACCEPT"
    iptables -D FORWARD -i $WanIface -o $iface -j ACCEPT
    log.sh "iptables -t mangle -D OUTPUT -s $BypassNetwork/24 -j MARK --set-mark $tbl"
    iptables -t mangle -D OUTPUT -s $BypassNetwork/24 -j MARK --set-mark $tbl
    log.sh "iptables -t mangle -D PREROUTING -s $BypassNetwork/24 -j MARK --set-mark $tbl"
    iptables -t mangle -D PREROUTING -s $BypassNetwork/24 -j MARK --set-mark $tbl

    log.sh "# Delete bypass marking rules"
    log.sh "ip rule delete from $iface table $tbl"
    ip rule delete from $BypassNetwork/24 table $tbl
    log.sh "ip rule delete fwmark $tbl table $tbl"
    ip rule delete fwmark $tbl table $tbl

    log.sh "# Delete bypass custom table route"
    log.sh "ip route delete $BypassNetwork/24 dev $iface table $tbl"
    ip route delete $BypassNetwork/24 dev $iface table $tbl
    log.sh "ip route delete 127.0.0.0/8 dev lo table $tbl"
    ip route delete 127.0.0.0/8 dev lo table $tbl
    log.sh "ip route delete default via $IspGateway table $tbl"
    ip route delete default via $IspGateway table $tbl
done < /jffs/etc/bypass.iface

ip route flush cache

exit 0
