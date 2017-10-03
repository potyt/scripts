#!/bin/sh

PATH=/jffs/scripts:$PATH

ip=$1

ping -4 -c 1 $ip >/dev/null 2>&1 && exit 0 || exit 1
