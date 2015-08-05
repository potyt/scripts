#!/bin/sh

WanIface=$(get_wanface)
WanGateway=$(nvram get wan_gateway)

iptables -D OUTPUT -o $WanIface -d $WanGateway -j ACCEPT
iptables -I OUTPUT -o $WanIface -d $WanGateway -j ACCEPT
