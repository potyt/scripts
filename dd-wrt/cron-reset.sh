#!/bin/sh

PATH=/jffs/scripts:$PATH

while true; do
    ntp-sync.sh
    log.sh "Restarting cron service"
    stopservice cron && startservice cron
    sleep 600
done
