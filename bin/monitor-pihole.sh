#!/bin/bash

# Load secrets
source "$(dirname "$0")/../.env"

# Load helper function
source "$(dirname "$0")/../lib/telegram.sh"

#  Awkward: we define a variable, before determining if we need to use it at all.
DATE_STR=$(date)

# Check Pi-hole status
if ! systemctl is-active --quiet pihole-FTL; then
    MSG="❌ *ALERT:* Pi-hole *$PIHOLE_HOSTNAME* is *down* at $DATE_STR

	Please check service status and logs immediately."

	send_telegram "$MSG"
fi
