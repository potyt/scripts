#!/bin/sh

PATH=/jffs/scripts:$PATH

def=1
for conf in /jffs/etc/openvpn/client-*.conf; do
    f=$(basename $conf)
    idx=${f//[A-Za-z\-\.]/}
    vpn-start.sh $idx $def
    sleep 10
    def=0
done

exit 0
