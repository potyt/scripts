#!/bin/sh

PATH=/jffs/scripts:$PATH

echo "# NTP sync $(date)"

Ip=$(ip-cacher.sh $(nvram get ntp_server))
if [[ -n $Ip ]]; then
    echo Syncing to NTP server $Ip
    firewall-hole.sh $Ip I
    ntpclient $Ip && stopservice process_monitor && startservice process_monitor
    firewall-hole.sh $Ip D
fi
