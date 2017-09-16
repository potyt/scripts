#!/bin/sh

PATH=/jffs/scripts:$PATH

ntp-sync.sh
vpn-startall.sh

while true; do
    ntp-sync.sh
    log.sh "Restarting cron service"
    stopservice cron && startservice cron
    sleep 600
done
