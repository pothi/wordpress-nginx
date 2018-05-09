#!/bin/bash

# script to set Cloudflare IPs (ipv4 and ipv6)

# empty the list
echo -n > /etc/nginx/globals/cloudflare-ip-list.conf;

# fetch and update ipv4
for i in `curl -s https://www.cloudflare.com/ips-v4`; do
    echo "set_real_ip_from $i;" >> /etc/nginx/globals/cloudflare-ip-list.conf;
done

# fetch and update ipv6
for i in `curl -s https://www.cloudflare.com/ips-v6`; do
    echo "set_real_ip_from $i;" >> /etc/nginx/globals/cloudflare-ip-list.conf;
done
