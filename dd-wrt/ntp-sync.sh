#!/bin/sh

PATH=/jffs/scripts:$PATH

log.sh "NTP sync $(date)"

runfile=/var/tmp/ntp-sync

if [[ -r $runfile ]]; then
    log.sh "NTP sync already in progress"
    exit 0
else
    touch $runfile
fi

Ntp=$(nvram get ntp_server)
ip-cachew.sh $Ntp
synced=false
while ! $synced; do
    log.sh "Looking up NTP server $Ntp"
    Ip=$(ip-cacher.sh $Ntp)
    if [[ $Ip ]]; then
        log.sh "Trying NTP server $Ip"
        firewall-hole.sh $Ip I
        log.sh "Pinging $Ip"
        ping.sh $Ip
        if [[ $? != 0 ]]; then
            log.sh "Can't ping $Ip"
        else
            log.sh "Syncing to NTP server $Ip"
            ntpclient $Ip && stopservice process_monitor && startservice process_monitor
            if [[ $? = 0 ]]; then
                synced=true
                sleep 20
                log.sh "NTP sync successful"
            fi
        fi
        firewall-hole.sh $Ip D
    fi

    if ! $synced; then
        log.sh "Failed to sync, resolving new NTP server IP"
        ip-cachew.sh $Ntp 1
        sleep 30
    fi
done

rm $runfile
