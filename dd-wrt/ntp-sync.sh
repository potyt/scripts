#!/bin/sh

PATH=/jffs/scripts:$PATH

log.sh "# NTP sync $(date)"

Ntp=$(nvram get ntp_server)
ip-cachew.sh $Ntp
pinged=false
while ! $pinged; do
    Ip=$(ip-cacher.sh $Ntp)
    log.sh "# Opening firewall hole $Ip"
    firewall-hole.sh $Ip I
    log.sh "# Pinging $Ip"
    ping.sh $Ip
    if [[ $? != 0 ]]; then
        log.sh "# Can't reach NTP IP $Ip"
        ip-cachew.sh $Ntp 1
    else
        log.sh "# Reached NTP IP $Ip"
        pinged=true
        log.sh "# Syncing to NTP server $Ip"
        ntpclient $Ip && stopservice process_monitor && startservice process_monitor
        if [[ $? != 0 ]]; then
            log.sh "# Failed to sync"
        else
            sleep 20
        fi
    fi
    log.sh "# Closing firewall hole $Ip"
    firewall-hole.sh $Ip D
done
