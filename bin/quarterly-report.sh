#!/bin/bash

# Load centralized config
source "$(dirname "$0")/../.env"
source "$(dirname "$0")/../lib/telegram.sh"

DATE_STR=$(date)
UPTIME=$(uptime -p)
LAST_BOOT=$(who -b | awk '{print $3 " " $4}')

# Disk usage
ROOT_DISK=$(df -h / | awk 'NR==2 {print $3 " used, " $4 " free of " $2}')
BACKUP_DISK=$(df -h "$BACKUP_PATH" | awk 'NR==2 {print $3 " used, " $4 " free of " $2}')

# Package updates
SECURITY=$(apt list --upgradable 2>/dev/null | grep -c security)
UPGRADES=$(apt list --upgradable 2>/dev/null | grep -v "Listing" | grep -v security | wc -l)

# Pi-hole version check
VERSIONS=$(sudo pihole -v 2>/dev/null | sed -n 's/.*version is \(.*\)/\1/p')
VERSIONS_FORMATTED=$(printf '%s\n' "$VERSIONS" | sed 's/.*/- `&`/')

# Format Telegram message
MSG="📋 *Quarterly Status Report* for *$PIHOLE_HOSTNAME*
🗓️  Date: $DATE_STR

🖥️  Uptime: \`$UPTIME\`
🔄 Last boot: \`$LAST_BOOT\`

📦 *Package updates:*
- Non-security: \`$UPGRADES available\`
- Security: \`$SECURITY (auto-installed)\`

💾 *Disk usage:*
- Root (\`/\`): \`$ROOT_DISK\`
- Backup (\`$BACKUP_PATH\`): \`$BACKUP_DISK\`

🧿 *Pi-hole versions:*
$VERSIONS_FORMATTED
"

send_telegram "$MSG" || echo "[!] Failed to send message"
