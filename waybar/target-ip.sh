#!/bin/sh

TARGET_FILE="$HOME/.config/waybar/target.txt"
if [ -f "$TARGET_FILE" ]; then
    TARGET_IP=$(cat "$TARGET_FILE")
else
    TARGET_IP="No target set"
fi
echo "{\"text\": \"󰓾 $TARGET_IP\", \"class\": \"custom-target-ip\"}" 