#!/bin/sh

IP=$(/usr/sbin/ifconfig enp0s13f0u3 | grep "inet " | awk '{print $2}')
echo "{\"text\": \" $IP\", \"class\": \"ip-address\"}" 