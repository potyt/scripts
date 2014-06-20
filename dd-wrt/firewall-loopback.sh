#!/bin/sh

WanIface=$(get_wanface)
WanIp=$(nvram get wan_ipaddr)

iptables -t mangle -D PREROUTING -i ! $WanIface -d $WanIp -j MARK --set-mark 0xd001
iptables -t nat -D POSTROUTING -m mark --mark 0xd001 -j MASQUERADE

iptables -t mangle -A PREROUTING -i ! $WanIface -d $WanIp -j MARK --set-mark 0xd001
iptables -t nat -A POSTROUTING -m mark --mark 0xd001 -j MASQUERADE
