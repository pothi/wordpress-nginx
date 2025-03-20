#!/bin/bash

#TODO:
# take a backup
# take a backup only if there is a diff

# script to update Bunny CDN IPs from https://bunnycdn.com/api/system/edgeserverlist

# version=1.0

# changelog
#	- version: 1.0
#	- date: 2025-03-20

# variable
IPLIST_FILE=/etc/nginx/globals/bunnycdn-ip-list.conf
IPLIST_SOURCE=https://bunnycdn.com/api/system/edgeserverlist
IPLIST_TMP=~/tmp/ip-list.txt

export PATH=~/bin:~/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin

curl -s $IPLIST_SOURCE | tr -d '[]"' | tr ',' "\n" > $IPLIST_TMP

# empty the list
echo -n > $IPLIST_FILE;

# fetch and update ipv4
for i in $(cat $IPLIST_TMP); do
    # echo "$i"
    echo "set_real_ip_from $i;" >> $IPLIST_FILE;
done

nginx -t && systemctl reload nginx
