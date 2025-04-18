#!/bin/bash

# test-suite.sh
# Developer test script to verify Telegram alerts, backup integrity, and monitor behavior

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

source "$SCRIPT_DIR/../.env"
source "$SCRIPT_DIR/../lib/telegram.sh"

print_title() {
  echo -e "\n\e[1;34m==> $1\e[0m"
}

# Test 1: Telegram send_telegram function
print_title "Testing Telegram Alert Function"
send_telegram "✅ *Pi-hole Monitoring Test*\nThis is a test alert from *$PIHOLE_HOSTNAME* to confirm Telegram is working."

# Test 2: Fake Pi-hole down alert
print_title "Testing FTL Alert (Simulated)"
/bin/bash "$SCRIPT_DIR/monitor-pihole.sh"

# Test 3: Reboot alert (simulated trigger)
print_title "Testing Reboot Alert (Simulated)"
/bin/bash "$SCRIPT_DIR/alert-on-reboot.sh"

# Test 4: Quarterly report send (simulated)
print_title "Testing Quarterly Status Report"
/bin/bash "$SCRIPT_DIR/quarterly-report.sh"

# Test 5: Check mount path
print_title "Checking Mount Status"
if mountpoint -q "$BACKUP_PATH"; then
  echo "✅ Backup path is mounted at: $BACKUP_PATH"
else
  echo "❌ Backup path is NOT mounted: $BACKUP_PATH"
fi

print_title "✅ All tests completed"
