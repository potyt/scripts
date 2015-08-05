#!/bin/sh

PATH=/jffs/scripts:$PATH

a=$1

file=/tmp/dnsmasq.conf

Ips=$(cat $file | egrep ^server= | grep -v "/" | cut -d"=" -f2 | cut -d" " -f1)

for Ip in $Ips; do
    firewall-hole.sh $Ip $a
done
