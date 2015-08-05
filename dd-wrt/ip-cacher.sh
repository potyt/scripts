#!/bin/sh

PATH=/jffs/scripts:$PATH

host=$1
file=/var/tmp/$host.ip

if [[ -r $file ]]; then
    echo $(cat $file)
else
    exit 1
fi
