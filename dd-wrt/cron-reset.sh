#!/bin/sh

while true; do
    log.sh "Restarting cron service"
    stopservice cron && startservice cron
    sleep 3600
done
