#!/bin/sh

PATH=/jffs/scripts:$PATH

WanIface=$(get_wanface)
WanGateway=$(nvram get wan_gateway)

if [[ $WanIface && $WanGateway ]]; then
    log.sh "Firewall: iptables -D OUTPUT -o $WanIface -d $WanGateway -j logaccept"
    iptables -D OUTPUT -o $WanIface -d $WanGateway -j logaccept
    log.sh "Firewall: iptables -I OUTPUT -o $WanIface -d $WanGateway -j logaccept"
    iptables -I OUTPUT -o $WanIface -d $WanGateway -j logaccept
else
    log.sh "!! Can't add firewall rules: no WanIface/WanGateway"
    exit 1
fi

exit 0
