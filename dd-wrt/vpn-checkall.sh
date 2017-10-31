#!/bin/sh

PATH=/jffs/scripts:$PATH

log.sh "# VPN check $(date)"

if [[ ! -r /var/tmp/wanup ]]; then
    log.sh "WAN setup not complete, exiting"
    exit 1
fi

runfile=/var/tmp/openvpn-checkall
if [[ -r $runfile ]]; then
    log.sh "VPN check already in progress"
    exit 0
else
    touch $runfile
fi

vpn_count=0

check_vpns()
{
    vpn_count=0
    restart=$1
    def=1
    for conf in /jffs/etc/openvpn/client-*.conf; do
        f=$(basename $conf)
        idx=${f//[A-Za-z\-\.]/}
        vpn-check.sh $idx
        vpn_ok=$?
        if [[ $vpn_ok != 0 ]]; then
            log.sh "VPN $idx down"
            vpn_count=$((1+$vpn_count))
            if [[ $restart != 0 ]]; then
                log.sh "Restarting VPN $idx"
                vpn-restart.sh $idx $def
            fi
        fi
        def=0
    done
}

check_vpns 0
vpn_restart=$vpn_count

if [[ $vpn_restart != 0 ]]; then
    log.sh "$vpn_count VPN tunnels down, restart check"
    check_vpns 1
    if [[ $vpn_count != 0 ]]; then
        log.sh "Some VPN tunnels restarted, waiting ..."
        sleep 60
        check_vpns 0
        if [[ $vpn_count = 0 ]]; then
            log.sh "All VPNs now up"
        fi

        if [[ $vpn_count != $vpn_restart ]]; then
            log.sh "New VPN tunnels, restarting DNS"
            dns-restart.sh
        else
            log.sh "No new VPN tunnels, not restarting DNS"
        fi
    else
        log.sh "All VPN tunnels up"
    fi
else
    log.sh "All VPN tunnels up"
fi

rm $runfile
