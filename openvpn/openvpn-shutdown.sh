#!/bin/sh

sudo -u nobody -- kill -TERM $(ps -ef | awk /[o]penvpn-$1/'{print $2}')
