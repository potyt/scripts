#!/bin/sh

set -e

PATH=/jffs/scripts:$PATH

logfile=/var/log/wanup.log

runfile=/var/tmp/wanup.start
if [[ -r $runfile ]]; then
    log.sh "# wanup.sh already running"
    exit 0
else
    touch $runfile
fi

log.sh "# Blocking WAN" >> $logfile
firewall-wan-block.sh >> $logfile
log.sh "# Blocked WAN" >> $logfile

log.sh "# Opening WAN gateway" >> $logfile
firewall-wan-gateway.sh >> $logfile
log.sh "# Opened WAN gateway" >> $logfile

log.sh "# Restarting DNS" >> $logfile   
dns-restart.sh >> $logfile      
log.sh "# Restarted DNS" >> $logfile   

log.sh "# Caching NTP server IP" >> $logfile
ntp-ip-cache.sh >> $logfile        
log.sh "# Cached NTP server IP" >> $logfile

log.sh "# Setting up firewall loopback" >> $logfile   
firewall-loopback.sh >> $logfile   
log.sh "# Set up firewall loopback" >> $logfile   

log.sh "# Capturing DNS" >> $logfile 
firewall-capture-dns.sh >> $logfile
log.sh "# Captured DNS" >> $logfile 

log.sh "# Marking WAN setup complete" >> $logfile
touch /var/tmp/wanup

log.sh "# Starting tunnels" >> $logfile
vpn-checkall.sh >> $logfile
log.sh "# Started tunnels" >> $logfile

log.sh "# Starting cron reset watchdog" >> $logfile
(nohup /jffs/scripts/cron-reset.sh 2>&1 > /var/log/cron-reset.log &)
log.sh "# Started cron reset watchdog" >> $logfile
