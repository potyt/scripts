#!/bin/sh

PATH=/jffs/scripts:$PATH

WanIface=$(get_wanface)
WanIp=$(nvram get wan_ipaddr)

if [[ $WanIface && $WanIp ]]; then
    iptables -t mangle -D PREROUTING -i ! $WanIface -d $WanIp -j MARK --set-mark 0xd001
    iptables -t nat -D POSTROUTING -m mark --mark 0xd001 -j MASQUERADE
    iptables -t mangle -A PREROUTING -i ! $WanIface -d $WanIp -j MARK --set-mark 0xd001
    iptables -t nat -A POSTROUTING -m mark --mark 0xd001 -j MASQUERADE
else
    log.sh "!! Can't add firewall rules: no WanIface/WanIp"
    exit 1
fi
