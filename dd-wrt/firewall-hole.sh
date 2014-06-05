#!/bin/sh

WanIface=`nvram get wan_iface`

d=$1; a=$2

iptables -$a OUTPUT -d $d -o $WanIface -j ACCEPT
iptables -$a FORWARD -d $d -o $WanIface -j ACCEPT
