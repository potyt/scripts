#!/bin/sh

PATH=/jffs/scripts:$PATH

firewall-wan-block.sh
firewall-loopback.sh
stopvpn.sh
startvpn.sh
