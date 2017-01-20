#!/bin/sh

PATH=/jffs/scripts:$PATH

logfile=/var/log/wanup.log
                     
log.sh "# Blocking WAN" >> $logfile
firewall-wan-open >> $logfile
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

log.sh "# Syncing NTP" >> $logfile      
ntp-sync.sh >> $logfile            
log.sh "# Synced NTP" >> $logfile      

log.sh "# Setting up firewall loopback" >> $logfile   
firewall-loopback.sh >> $logfile   
log.sh "# Set up firewall loopback" >> $logfile   

log.sh "# Capturing DNS" >> $logfile 
firewall-capture-dns.sh >> $logfile
log.sh "# Captured DNS" >> $logfile 

touch /var/tmp/wanup
