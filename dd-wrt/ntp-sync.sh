#!/bin/sh

PATH=/jffs/scripts:$PATH

log.sh "# NTP sync $(date)"

Ntp=$(nvram get ntp_server)
pinged=1
while ! $pinged; do
    Ip=$(ip-cacher.sh $Ntp)
    firewall-hole.sh $Ip I
    pinged=$(ping.sh $Ip)
    if ! $pinged; then
        log.sh "# Can't reach NTP IP $Ip"
        ip-cachew.sh $Ntp 1
    fi
    firewall-hole.sh $Ip D
    sleep 5
done
log.sh "# Reached NTP IP $Ip"
if [[ -n $Ip ]]; then
    log.sh "# Syncing to NTP server $Ip"
    firewall-hole.sh $Ip I
    ntpclient $Ip && stopservice process_monitor && startservice process_monitor
    sleep 5
    firewall-hole.sh $Ip D
else
    log.sh "# Not syncing to NTP server $Ip"
fi
