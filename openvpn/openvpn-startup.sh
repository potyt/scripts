#!/bin/sh

modprobe tun

vpn=$1
shift

for instance in $*; do
    sudo openvpn --cd /etc/openvpn-$vpn --daemon --config vpn-$instance.conf
done
