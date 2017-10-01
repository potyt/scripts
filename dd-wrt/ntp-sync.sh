#!/bin/sh

PATH=/jffs/scripts:$PATH

log.sh "# NTP sync $(date)"

Ntp=$(nvram get ntp_server)
Ip=$(ip-cacher.sh $Ntp)
while ! ping.sh $Ip; do
    log.sh "# Can't reach NTP IP $Ip"
    Ip=$(ip-cacher.sh $Ntp 1)
    sleep 1
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
