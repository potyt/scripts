#!/bin/sh

PATH=/jffs/scripts:$PATH

head=/jffs/etc/dnsmasq.conf-head
tail=/jffs/etc/dnsmasq.conf-tail

dest=/var/tmp/dnsmasq.conf

checklogfile=/var/log/vpn-checkall.log

warning="WARNING writing DNSMasq options to nvram"

cat $head > $dest
for f in /var/tmp/dnsmasq.server-*.conf; do
    if [[ -r $f ]]; then
        log.sh "Reading $f"
        cat $f >> $dest
    fi
done
cat $tail >> $dest

if [[ -r $dest ]]; then
    new=$(cat $dest)
    cfg=$(nvram get dnsmasq_options)

    if [[ "$cfg" != "$new" ]]; then
        log.sh "WARNING writing DNSMasq options to nvram"
        nvram set dnsmasq_options="$new"
        nvram commit
        log.sh "DNSMasq settings changed, restarting"
        stopservice dnsmasq
        startservice dnsmasq
        if [[ -r $checklogfile ]]; then
            nvram_count=$(grep "$warning" $checklogfile | wc -l)
            log.sh "** Total nvram writes: $nvram_count"
        fi
    fi
fi
