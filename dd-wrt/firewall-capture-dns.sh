#!/bin/sh

LanIp=`nvram get lan_ipaddr`
LanIface=`nvram get lan_ifname`

iptables -t nat -A PREROUTING -i $LanIface -p udp --dport 53 -j DNAT --to $LanIp
iptables -t nat -A PREROUTING -i $LanIface -p tcp --dport 53 -j DNAT --to $LanIp
