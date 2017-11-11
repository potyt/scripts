#!/bin/sh

PATH=/jffs/scripts:$PATH

idx=$1

file=/var/tmp/dns-$idx

down=false
if [[ -r $file ]]; then
    log.sh "Found DNS server record for VPN $idx"
    dns=$(cat /var/tmp/dns-$idx)
    log.sh "$dns"
    ping.sh $dns
    if [[ $? != 0 ]]; then
        log.sh "Can't ping DNS $dns"
        down=true
    fi
else
    log.sh "No DNS server record for VPN $idx"
    down=true
fi

if $down; then
    exit 1
fi

exit 0
