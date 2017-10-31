#!/bin/sh

PATH=/jffs/scripts:$PATH

WanIface=$(get_wanface)

if [[ $WanIface ]]; then
    log.sh "Firewall: iptables -A lan2wan -j logdrop"
    iptables -A lan2wan -j logdrop
    log.sh "Firewall: iptables -A OUTPUT -o $WanIface -j logdrop"
    iptables -A OUTPUT -o $WanIface -j logdrop
else
    log.sh "!! Can't add firewall rules: no WanIface"
    exit 1
fi
