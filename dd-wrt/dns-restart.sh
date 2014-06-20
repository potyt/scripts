#!/bin/sh

dest=/var/tmp/dnsmasq.server.conf

rm -f $dest

for f in /var/tmp/dnsmasq.server-*.conf; do
    if [[ -r $f ]]; then
        cat $f >> $dest
    fi
done

new=$(cat $dest)
cfg=$(nvram get dnsmasq_options)

if [[ "$cfg" != "$new" ]]; then
    echo "WARNING writing DNSMasq options to nvram"
    nvram set dnsmasq_options="$new"
    nvram commit
    echo "Restarting DNSMasq"
    stopservice dnsmasq
    startservice dnsmasq
fi
