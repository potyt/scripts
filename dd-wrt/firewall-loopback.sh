#!/bin/sh

PATH=/jffs/scripts:$PATH

WanIface=$(get_wanface)
WanIp=$(nvram get wan_ipaddr)

if [[ $WanIface && $WanIp ]]; then
    log.sh "Firewall: iptables -t mangle -D PREROUTING -i ! $WanIface -d $WanIp -j MARK --set-mark 0xd001"
    iptables -t mangle -D PREROUTING -i ! $WanIface -d $WanIp -j MARK --set-mark 0xd001
    log.sh "Firewall: iptables -t nat -D POSTROUTING -m mark --mark 0xd001 -j MASQUERADE"
    iptables -t nat -D POSTROUTING -m mark --mark 0xd001 -j MASQUERADE
    log.sh "Firewall: iptables -t mangle -A PREROUTING -i ! $WanIface -d $WanIp -j MARK --set-mark 0xd001"
    iptables -t mangle -A PREROUTING -i ! $WanIface -d $WanIp -j MARK --set-mark 0xd001
    log.sh "Firewall: iptables -t nat -A POSTROUTING -m mark --mark 0xd001 -j MASQUERADE"
    iptables -t nat -A POSTROUTING -m mark --mark 0xd001 -j MASQUERADE
else
    log.sh "!! Can't add firewall rules: no WanIface/WanIp"
    exit 1
fi
