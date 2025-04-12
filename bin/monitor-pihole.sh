#!/bin/bash

# Load centralized config
source "$(dirname "$0")/../.env"

DATE_STR=$(date)

# Check Pi-hole status
if ! systemctl is-active --quiet pihole-FTL; then
    MSG="❌ *ALERT:* Pi-hole *$PIHOLE_HOSTNAME* is *down* at $DATE_STR

Please check service status and logs immediately."

    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
         -d chat_id="$TELEGRAM_CHAT_ID" \
         -d text="$MSG" \
         -d parse_mode="Markdown"
fi
