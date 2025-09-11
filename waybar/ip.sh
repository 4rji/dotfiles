#!/bin/sh

#IP=$(/usr/sbin/ifconfig enp0s13f0u3 | grep "inet " | awk '{print $2}')
IP=$(/usr/sbin/ifconfig wlp0s20f3 | grep "inet " | awk '{print $2}')
echo "{\"text\": \"$IP\", \"class\": \"custom-ip-address\"}" 
