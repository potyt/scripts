#!/bin/sh

PATH=/jffs/scripts:$PATH

WanIface=$(get_wanface)

if [[ $WanIface ]]; then
    iptables -A lan2wan -j logdrop
    iptables -A OUTPUT -o $WanIface -j logdrop
else
    log.sh "!! Can't add firewall rules: no WanIface"
    exit 1
fi
