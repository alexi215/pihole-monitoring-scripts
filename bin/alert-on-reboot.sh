#!/bin/bash
# alert-on-reboot.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../.env"
source "$SCRIPT_DIR/../lib/telegram.sh"

CACHE_DIR="$SCRIPT_DIR/../.cache"
mkdir -p "$CACHE_DIR"

REBOOT_LOG="$CACHE_DIR/reboot-events.log"
ALERT_LOG="$CACHE_DIR/last-reboot-alert"

NOW_EPOCH=$(date +%s)
FOUR_HOURS=14400

date -Is >> "$REBOOT_LOG"

if [[ -f "$ALERT_LOG" ]]; then
  LAST_ALERT_EPOCH=$(cat "$ALERT_LOG")
else
  LAST_ALERT_EPOCH=0
fi

TIME_SINCE_LAST_ALERT=$((NOW_EPOCH - LAST_ALERT_EPOCH))

if (( TIME_SINCE_LAST_ALERT >= FOUR_HOURS )); then
  RECENT_REBOOTS=$(awk -v cutoff="$LAST_ALERT_EPOCH" '{ cmd="date -d "$0" +%s"; cmd | getline ts; close(cmd); if (ts >= cutoff) print }' "$REBOOT_LOG")

  COUNT=$(echo "$RECENT_REBOOTS" | grep -c '^' || true)
  LATEST=$(echo "$RECENT_REBOOTS" | tail -n 1)

  MSG="🔁 *Reboot Summary for* \`$PIHOLE_HOSTNAME\`
- *Reboots in last 4 hours:* $COUNT
- *Most recent:* \`$LATEST\`"

  send_telegram "$MSG"
  echo "$NOW_EPOCH" > "$ALERT_LOG"
fi
