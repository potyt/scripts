#!/bin/sh

PATH=/jffs/scripts:$PATH

WanIface=$(get_wanface)

if [[ $WanIface ]]; then
    log.sh "Firewall: iptables -D lan2wan -j logdrop"
    iptables -D lan2wan -j logdrop
    log.sh "Firewall: iptables -D OUTPUT -o $WanIface -j logdrop"
    iptables -D OUTPUT -o $WanIface -j logdrop
else
    log.sh "!! Can't add firewall rules: no WanIface"
    exit 1
fi

exit 0
