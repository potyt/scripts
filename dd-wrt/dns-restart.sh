#!/bin/sh

head=/jffs/etc/dnsmasq.conf-head
tail=/jffs/etc/dnsmasq.conf-tail

dest=/var/tmp/dnsmasq.conf

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
        nvram_count=$(grep "$warning" /var/log/vpn-checkall.log | wc -l)
        log.sh "** Total nvram writes: $nvram_count"
    fi
fi
