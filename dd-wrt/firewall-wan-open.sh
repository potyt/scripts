#!/bin/sh

WanIface=$(get_wanface)

iptables -D OUTPUT -o $WanIface -j DROP
iptables -D FORWARD -o $WanIface -j DROP
