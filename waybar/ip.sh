#!/bin/sh

IP=$(/usr/sbin/ifconfig wlp0s20f3 | grep "inet " | awk '{print $2}')
echo "{\"text\": \"LAN:$IP\", \"class\": \"custom-ip-address\"}" 
