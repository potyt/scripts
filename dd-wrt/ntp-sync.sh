#!/bin/sh

PATH=/jffs/scripts:$PATH

echo NTP sync $(date)

NtpServer=$(nvram get ntp_server)
file=/var/tmp/ntp_server_ip

touch $file

OldIp=$(cat $file)
NewIp=$(ping -q -c 1 $NtpServer | grep PING | sed -e "s/).*//" | sed -e "s/.*(//")

Ip=""
if [[ -n $OldIp ]]; then
    Ip=$OldIp
fi
if [[ -n $NewIp ]]; then
    Ip=$NewIp
fi

if [[ -n $Ip ]]; then
    echo Syncing to NTP server $Ip
    firewall-hole.sh $Ip I
    echo $Ip > $file
    ntpclient $Ip && stopservice process_monitor && startservice process_monitor
    firewall-hole.sh $Ip D
fi
