#!/bin/bash
csv_file=$1

# if the server restarted less than 24h ago, iptables are back to original state, we import the backup
if test $(cut -d '.' -f1 /proc/uptime) -lt 86400; then
    /sbin/iptables-restore < /bash-scripts/iptables.backup
fi

# we add an iptable rule for every IP in our file
# we check if the rule does not exist already in case the server restarted and 
# we got annoyed again by the same guy meanwhile, before restoring the backup
while read -r line
do
    if ! $(/sbin/iptables -C INPUT -s $line -j DROP); then
        /sbin/iptables -A INPUT -s "$line" -j DROP
    fi
done < "$csv_file"

# finally we update the iptables backup
/sbin/iptables-save > /bash-scripts/iptables.backup
