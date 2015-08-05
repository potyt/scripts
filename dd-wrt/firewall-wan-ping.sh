#!/bin/sh

a=$1
iptables -$a INPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -$a OUTPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -$a FORWARD -p icmp --icmp-type echo-request -j ACCEPT
