#!/bin/sh

WanIface=$(get_wanface)

iptables -D lan2wan -j DROP
iptables -D OUTPUT -o $WanIface -j DROP
