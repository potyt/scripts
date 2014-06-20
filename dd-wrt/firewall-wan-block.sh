#!/bin/sh

WanIface=$(get_wanface)

iptables -I OUTPUT -o $WanIface -j DROP
iptables -I FORWARD -o $WanIface -j DROP
