#!/bin/sh

PATH=/jffs/scripts:$PATH

vpn-stopall.sh && sleep 5 && vpn-startall.sh
