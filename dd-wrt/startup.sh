#!/bin/sh

PATH=/jffs/scripts:$PATH

rmdir /tmp/www; ln -s /jffs/www /tmp/www

sleep 5

log.sh "# Starting cron reset watchdog" >> $logfile 
(nohup /jffs/scripts/cron-reset.sh 2>&1 > /var/log/cron-reset.log &)
log.sh "# Started cron reset watchdog" >> $logfile 
