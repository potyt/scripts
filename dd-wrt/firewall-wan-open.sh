#!/bin/sh

WanIface=`nvram get wan_iface`

iptables -D OUTPUT -o $WanIface -j DROP
iptables -D FORWARD -o $WanIface -j DROP
