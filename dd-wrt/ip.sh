#!/bin/sh

PATH=/jffs/scripts:$PATH

host=$1

ip-cachew.sh $host && ip-cacher.sh $host

exit 0
