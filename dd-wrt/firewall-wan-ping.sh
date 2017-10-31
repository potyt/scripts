#!/bin/sh

PATH=/jffs/scripts:$PATH

a=$1

if [[ $a ]]; then
    iptables -$a INPUT -p icmp --icmp-type echo-reply -j logaccept
    iptables -$a OUTPUT -p icmp --icmp-type echo-request -j logaccept
    iptables -$a FORWARD -p icmp --icmp-type echo-request -j logaccept
else
    log.sh "!! Can't add firewall rules: no action"
    exit 1
fi
