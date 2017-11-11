#!/bin/sh

PATH=/jffs/scripts:$PATH

idx=$1
def=$2
log.sh "Starting VPN $idx $def"

conf=/jffs/etc/openvpn/client-$idx.conf
dir=/jffs/scripts

client=$(basename $conf)
client=$(echo ${client/.conf/})
routes=${conf/client-/route-}
domains=${conf/client-/domain-}

def_flag=$([[ $def != 0 ]] && echo "-z" || echo "")

runfile=/var/tmp/openvpn-starting-$idx
pidfile=/var/tmp/openvpn-$idx.pid
logfile=/var/log/openvpn-$idx.log

if [[ -r $runfile ]]; then
    log.sh "VPN $idx start already in progress"
    exit 0
else
    touch $runfile
fi

rv=1
remote_str=""
while read -r line; do
    if [ "`expr \"$line\" : \"# *remote \"`" != "0" ]; then
        host=$(echo $line | cut -d" " -f3)
        port=$(echo $line | cut -d" " -f4)
        log.sh "Getting IP for $host"
        ip-cachew.sh $host
        Ip=$(ip-cacher.sh $host)
        if [[ $Ip ]]; then
            firewall-hole.sh $Ip I
            remote_str="$remote_str --remote $Ip $port"
        else
            log.sh "Can't resolve $host"
        fi
    fi
done < $conf

if [[ "$remote_str" ]]; then                                       
    openvpn --config $conf $remote_str --route-noexec --ping 60 --up "$dir/vpn-up.sh -r $routes -d $domains $def_flag" --down "$dir/vpn-down.sh -r $routes -d $domains $def_flag" --down-pre --writepid $pidfile --log $logfile --daemon
    rv=$?
else
    log.sh "No resolved remotes, not starting tunnel"
fi

rm $runfile

exit $rv
