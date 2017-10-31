#!/bin/sh

PATH=/jffs/scripts:$PATH

WanIface=$(get_wanface)

d=$1; a=$2

if [[ $d && $a ]]; then
    log.sh "Firewall: iptables -$a OUTPUT -d $d -o $WanIface -j logaccept"
    iptables -$a OUTPUT -d $d -o $WanIface -j logaccept
    log.sh "Firewall: iptables -$a FORWARD -d $d -o $WanIface -j logaccept"
    iptables -$a FORWARD -d $d -o $WanIface -j logaccept
else
    log.sh "!! Can't add firewall rules: no destination/action/WanIface"
    exit 1
fi
