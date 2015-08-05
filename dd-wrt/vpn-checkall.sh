#!/bin/sh

PATH=/jffs/scripts:$PATH

echo "# VPN check $(date)"

if [[ ! -r /var/tmp/wanup ]]; then
    echo "WAN not up, exiting"
    exit 1
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
            echo "VPN $idx down"
            vpn_count=$((1+$vpn_count))
            if [[ $restart != 0 ]]; then
                echo "Restarting VPN $idx"
                vpn-restart.sh $idx $def
            fi
        fi
        def=0
    done
}

check_vpns 0
vpn_restart=$vpn_count

if [[ $vpn_restart != 0 ]]; then
    echo "$vpn_count VPN tunnels down, restart check"
    check_vpns 1
    if [[ $vpn_count != 0 ]]; then
        echo "Some VPN tunnels restarted, waiting ..."
        sleep 60
        check_vpns 0
        if [[ $vpn_count = 0 ]]; then
            echo "All VPNs now up"
        fi

        if [[ $vpn_count != $vpn_restart ]]; then
            echo "New VPN tunnels, restarting DNS"
            dns-restart.sh
        else
            echo "No new VPN tunnels, not restarting DNS"
        fi
    else
        echo "All VPN tunnels up"
    fi
else
    echo "All VPN tunnels up"
fi
