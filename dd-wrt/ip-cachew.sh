#!/bin/sh

PATH=/jffs/scripts:$PATH

host=$1
force=$2

LanIp=$(nvram get lan_ipaddr)

file=/var/tmp/$host.ip

if [[ $force ]]; then
    rm -f $file
fi

if [[ -r $file ]]; then
    CachedIp=$(cat $file)
    if [[ -z $CachedIp ]]; then
        rm -f $file
    fi
fi

if [[ ! -r $file ]]; then
    dns-restart.sh
    firewall-dns-hole.sh I
    Ip=$(nslookup $host | grep -v $LanIp | grep -v "::" | egrep "Address .:" | head -n 1 | awk '/^Address .: / { print $3 }')
    firewall-dns-hole.sh D

    if [[ $Ip ]]; then
        echo $Ip > $file
    else
        >&2 echo "Unable to lookup IP for $host"
        exit 1
    fi
else
    >&2 echo "IP cache file exists $file"
fi
