#!/bin/sh

dir="/jffs/scripts/"
PATH=$dir:$PATH
export PATH

idx=$1
def=$2

conf=/jffs/etc/openvpn/client-$idx.conf

client=$(basename $conf)
client=$(echo ${client/.conf/})
routes=${conf/client-/route-}
domains=${conf/client-/domain-}

def_flag=$([[ $def != 0 ]] && echo "-z" || echo "")

pidfile=/var/tmp/openvpn-$idx.pid
logfile=/var/log/openvpn-$idx.log

remote_str=""
while read -r line; do
    if [ "`expr \"$line\" : \"# *remote \"`" != "0" ]; then
        host=$(echo $line | cut -d" " -f3)
        port=$(echo $line | cut -d" " -f4)
        Ip=$(ip.sh $host)
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
else
    log.sh "No resolved remotes, not starting tunnel"
    exit 1
fi
