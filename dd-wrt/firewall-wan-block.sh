#!/bin/sh

WanIface=$(get_wanface)

iptables -A lan2wan -j DROP
iptables -A OUTPUT -o $WanIface -j DROP
