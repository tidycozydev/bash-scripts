#!/bin/bash
csv_file=$1

# if the server restarted less than 24h ago, iptables are back to original state, we import the backup
if test $(cut -d '.' -f1 /proc/uptime) -lt 86400; then
    /sbin/iptables-restore < /bash-scripts/iptables.backup
fi

# we add a conf in iptables for every IP in our file
while read -r line
do
    /sbin/iptables -A INPUT -s "$line" -j DROP
done < "$csv_file"

# finally we update the iptables backup
/sbin/iptables-save > /bash-scripts/iptables.backup
