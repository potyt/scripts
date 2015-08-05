#!/bin/sh

PATH=/jffs/scripts:$PATH

idx=$1

file=/var/tmp/dns-$idx

down=false
if [[ -r $file ]]; then
    echo "Found DNS server record for VPN $idx"
    dns=$(cat /var/tmp/dns-$idx)
    echo "$dns"
    ping -c1 $dns > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        echo "Can't ping DNS $dns"
        down=true
    fi
else
    echo "No DNS server record for VPN $idx"
    down=true
fi

if $down; then
    exit 1
else
    exit 0
fi
