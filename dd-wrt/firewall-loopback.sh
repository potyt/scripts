#!/bin/sh

iptables -t mangle -A PREROUTING -i ! `get_wanface` -d `nvram get wan_ipaddr` -j MARK --set-mark 0xd001
iptables -t nat -A POSTROUTING -m mark --mark 0xd001 -j MASQUERADE
