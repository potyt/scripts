#!/bin/sh

PATH=/jffs/scripts:$PATH

rmdir /tmp/www; ln -s /jffs/www /tmp/www

(nohup /jffs/scripts/cron-reset.sh 2>&1 > /var/log/cron-reset.log &)
