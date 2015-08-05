#!/bin/sh

PATH=/jffs/scripts:$PATH

logfile=/var/log/wanup.log
                     
echo "# Blocking WAN" >>  >> $logfile
firewall-wan-open >> $logfile
firewall-wan-block.sh >> $logfile

echo "# Opening WAN gateway" >> $logfile
firewall-wan-gateway.sh >> $logfile

echo "# Restarting DNS" >>  >> $logfile   
dns-restart.sh >> $logfile      

echo "# Caching NTP server IP" >>  >> $logfile
ntp-ip-cache.sh >> $logfile        

echo "# Syncing NTP" >>  >> $logfile      
ntp-sync.sh >> $logfile            

echo "# Setting up firewall loopback" >>  >> $logfile   
firewall-loopback.sh >> $logfile   

echo "# Capturing DNS" >>  >> $logfile 
firewall-capture-dns.sh >> $logfile

touch /var/tmp/wanup
