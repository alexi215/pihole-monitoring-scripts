#!/bin/bash

# Load centralized config
source "$(dirname "$0")/../.env"

DATE_STR=$(date)
UPTIME=$(uptime -p)
LAST_BOOT=$(who -b | awk '{print $3 " " $4}')

# Disk usage
ROOT_DISK=$(df -h / | awk 'NR==2 {print $3 " used, " $4 " free of " $2}')
BACKUP_DISK=$(df -h /mnt/backup_sd/pihole2 | awk 'NR==2 {print $3 " used, " $4 " free of " $2}')

# Package updates
SECURITY=$(apt list --upgradable 2>/dev/null | grep -c security)
UPGRADES=$(apt list --upgradable 2>/dev/null | grep -v "Listing" | grep -v security | wc -l)

# Pi-hole version check
VERSIONS=$(pihole -v | grep "version is" | sed 's/.*: //')

# Format Telegram message
MSG="📋 *Quarterly Status Report* for *$PIHOLE_HOSTNAME*  
🗓️  Date: $DATE_STR

🖥️  Uptime: $UPTIME  
🔄 Last boot: $LAST_BOOT

📦 Package updates:
- Non-security: $UPGRADES available
- Security: $SECURITY (auto-installed)

🧊 Disk usage:
- Root (/): $ROOT_DISK
- Backup (/mnt/backup_sd/pihole2): $BACKUP_DISK

🧪 Pi-hole versions:
$VERSIONS
"

# Send Telegram alert
curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
     -d chat_id="$TELEGRAM_CHAT_ID" \
     -d text="$MSG" \
     -d parse_mode="Markdown"
