#!/bin/sh

while true; do
    echo "Restarting cron service"
    stopservice cron && startservice cron
    sleep 3600
done
