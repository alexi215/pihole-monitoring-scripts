#!/bin/bash

# alert-on-reboot.sh - Notifies via Telegram when the Pi reboots.
# Sends no more than 1 alert every 4 hours, summarizing recent reboot events.

set -e

# Load environment variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/.env"
source "$SCRIPT_DIR/lib/telegram.sh"

# Log files
REBOOT_LOG="/tmp/reboot-events.log"
ALERT_LOG="/tmp/last-reboot-alert"

# Time thresholds
NOW_EPOCH=$(date +%s)
FOUR_HOURS=14400

# Record current reboot timestamp
date -Is >> "$REBOOT_LOG"

# Determine when the last alert was sent
if [[ -f "$ALERT_LOG" ]]; then
  LAST_ALERT_EPOCH=$(cat "$ALERT_LOG")
else
  LAST_ALERT_EPOCH=0
fi

TIME_SINCE_LAST_ALERT=$((NOW_EPOCH - LAST_ALERT_EPOCH))

if (( TIME_SINCE_LAST_ALERT >= FOUR_HOURS )); then
  # Count reboot events since last alert
  RECENT_REBOOTS=$(awk -v cutoff="$LAST_ALERT_EPOCH" \
    '{ cmd="date -d "$0" +%s"; cmd | getline ts; close(cmd); if (ts >= cutoff) print }' "$REBOOT_LOG")

  COUNT=$(echo "$RECENT_REBOOTS" | grep -c '^' || true)
  LATEST=$(echo "$RECENT_REBOOTS" | tail -n 1)

  MSG="🔁 *Reboot Summary for* \`$PIHOLE_HOSTNAME\`
- *Reboots in last 4 hours:* $COUNT
- *Most recent:* \`$LATEST\`"

  send_telegram "$MSG"

  echo "$NOW_EPOCH" > "$ALERT_LOG"
fi
