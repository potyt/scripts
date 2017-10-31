#!/bin/sh

PATH=/jffs/scripts:$PATH

a=$1

if [[ $a ]]; then
    file=/tmp/dnsmasq.conf

    Ips=$(cat $file | egrep ^server= | grep -v "/" | cut -d"=" -f2 | cut -d" " -f1)

    for Ip in $Ips; do
        if [[ $Ip ]]; then
            firewall-hole.sh $Ip $a
        fi
    done
else
    log.sh "!! Can't add firewall rules: no LanIp/LanIface"
    exit 1
fi
