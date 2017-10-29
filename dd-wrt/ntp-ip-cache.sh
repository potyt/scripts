#!/bin/sh

PATH=/jffs/scripts:$PATH

Ntp=$(nvram get ntp_server)

cached=false
while ! $cached; do
    ip-cachew.sh $Ntp
    if [[ $? = 0 ]]; then
        cached=true
    else
        log.sh "Failed to cache IP for $Ntp"
        sleep 10
    fi
done
