#!/bin/sh

PATH=/jffs/scripts:$PATH

vpn-stopall.sh && vpn-startall.sh
