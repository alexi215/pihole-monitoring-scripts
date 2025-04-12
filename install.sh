#!/bin/bash

set -e

BIN_DIR="$(dirname "$0")/bin"
ENV_FILE="$(dirname "$0")/.env"

# 1. Check for .env file
if [ ! -f "$ENV_FILE" ]; then
    echo "❌ .env file not found. Please copy .env.example and fill in your details."
    exit 1
fi

# 2. Make scripts in bin/ executable
chmod +x "$BIN_DIR"/*.sh
echo "✅ Made all scripts in bin/ executable."

# 3. Check if backup disk is mounted
if ! mountpoint -q /mnt/backup_sd/pihole2; then
    echo "⚠️  WARNING: /mnt/backup_sd/pihole2 is not mounted. Backup may fail until fixed."
fi

# 4. Install cron jobs

# - Watchdog: every 2 minutes
(crontab -l 2>/dev/null | grep -v "monitor-pihole.sh" ; echo "*/2 * * * * $BIN_DIR/monitor-pihole.sh") | crontab -

# - Quarterly report: 8:00 AM on Jan 1, Apr 1, Jul 1, Oct 1
(crontab -l 2>/dev/null | grep -v "quarterly-report.sh" ; echo "0 8 1 1,4,7,10 * $BIN_DIR/quarterly-report.sh") | crontab -

echo "✅ Cron jobs installed:"
echo "  - monitor-pihole.sh every 2 minutes"
echo "  - quarterly-report.sh every 3 months at 8 AM"

echo "✅ Installation complete."
