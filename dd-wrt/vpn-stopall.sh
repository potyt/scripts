#!/bin/sh

PATH=/jffs/scripts:$PATH

for conf in /jffs/etc/openvpn/client-*.conf; do
    f=$(basename $conf)
    idx=${f//[A-Za-z\-\.]/}
    vpn-stop.sh $idx
done

sleep 10

killall -q openvpn
