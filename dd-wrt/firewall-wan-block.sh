#!/bin/sh

WanIface=`nvram get wan_iface`

iptables -I OUTPUT -o $WanIface -j DROP
iptables -I FORWARD -o $WanIface -j DROP
