#!/bin/sh

IP=$(curl -s https://api.ipify.org)
echo "{\"text\": \" $IP\", \"class\": \"custom-public-ip\"}" 