#!/bin/sh

PATH=/jffs/scripts:$PATH

LanIp=$(nvram get lan_ipaddr)
LanIface=$(nvram get lan_ifname)

if [[ $LanIp && $LanIface ]]; then
    log.sh "Firewall: iptables -t nat -D PREROUTING -i $LanIface -p udp --dport 53 -j DNAT --to $LanIp"
    iptables -t nat -D PREROUTING -i $LanIface -p udp --dport 53 -j DNAT --to $LanIp
    log.sh "Firewall: iptables -t nat -D PREROUTING -i $LanIface -p tcp --dport 53 -j DNAT --to $LanIp"
    iptables -t nat -D PREROUTING -i $LanIface -p tcp --dport 53 -j DNAT --to $LanIp
    log.sh "Firewall: iptables -t nat -A PREROUTING -i $LanIface -p udp --dport 53 -j DNAT --to $LanIp"
    iptables -t nat -A PREROUTING -i $LanIface -p udp --dport 53 -j DNAT --to $LanIp
    log.sh "Firewall: iptables -t nat -A PREROUTING -i $LanIface -p tcp --dport 53 -j DNAT --to $LanIp"
    iptables -t nat -A PREROUTING -i $LanIface -p tcp --dport 53 -j DNAT --to $LanIp
else
    log.sh "!! Can't add firewall rules: no LanIp/LanIface"
    exit 1
fi

exit 0
