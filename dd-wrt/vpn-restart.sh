#!/bin/sh

PATH=/jffs/scripts:$PATH

idx=$1
def=$2

vpn-stop.sh $idx
sleep 5
vpn-start.sh $idx $def
