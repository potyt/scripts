#!/bin/sh

PATH=/jffs/scripts:$PATH

firewall-wan-open.sh
ntp-sync.sh
firewall-wan-block.sh
firewall-loopback.sh
firewall-capture-dns.sh
