#!/bin/sh

PATH=/jffs/scripts:$PATH

log.sh "# NTP sync $(date)"

Ip=$(ip-cacher.sh $(nvram get ntp_server))
if [[ -n $Ip ]]; then
    log.sh "# Syncing to NTP server $Ip"
    firewall-hole.sh $Ip I
    ntpclient $Ip && stopservice process_monitor && startservice process_monitor
    sleep 5
    firewall-hole.sh $Ip D
else
    log.sh "# Not syncing to NTP server $Ip"
fi
