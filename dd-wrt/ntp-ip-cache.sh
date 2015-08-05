#!/bin/sh

PATH=/jffs/scripts:$PATH

ip-cachew.sh $(nvram get ntp_server)
