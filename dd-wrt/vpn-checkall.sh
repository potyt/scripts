#!/bin/sh

PATH=/jffs/scripts:$PATH

echo VPN check $(date)

vpn_ok=0

check_vpn()
{
    vpn_ok=0
    restart=$1
    def=1
    for conf in /jffs/etc/openvpn/client-*.conf; do
        f=$(basename $conf)
        idx=${f//[A-Za-z\-\.]/}
        vpn-check.sh $idx
        vpn_ok=$?
        if [[ $vpn_ok != 0 ]]; then
            echo "VPN $idx down"
            vpn_ok=$((1+$vpn_ok))
            if [[ $restart != 0 ]]; then
                echo "Restarting VPN $idx"
                vpn-restart.sh $idx $def
            fi
        fi
        def=0
    done
}

restarted=false

check_vpn 0
if [[ $vpn_ok != 0 ]]; then
    echo "Some VPNs down, restart check"
    check_vpn 1
    if [[ $vpn_ok != 0 ]]; then
        restarted=true
    fi
fi

if $restarted; then
    echo "Some VPNs restarted, waiting ..."
    sleep 60
    check_vpn 0
    if [[ $vpn_ok = 0 ]]; then
        echo "VPNs now up, restarting DNS"
        dns-restart.sh
    else
        echo "VPNs still down, not restarting DNS"
    fi
fi
