#!/bin/bash
# bin/quarterly-report.sh

# Load centralized config
ENV_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/.env"
if [[ -f "$ENV_FILE" ]]; then
  # shellcheck source=/dev/null
  source "$ENV_FILE"
else
  echo "[✗] .env not found at $ENV_FILE" >&2
  exit 1
fi

# 1) Gather system info
DATE_STR=$(date)
UPTIME=$(uptime -p)
LAST_BOOT=$(who -b | awk '{print $3 " " $4}')

# 2) Disk usage
ROOT_DISK=$(df -h /       | awk 'NR==2 {print $3 " used, " $4 " free of " $2}')
BACKUP_DISK=$(df -h "$BACKUP_PATH" | awk 'NR==2 {print $3 " used, " $4 " free of " $2}')

# 3) Package updates
SECURITY=$(apt list --upgradable 2>/dev/null | grep -c security)
UPGRADES=$(apt list --upgradable 2>/dev/null | grep -v "Listing" | grep -v security | wc -l)

# 4) Pi-hole version lookup (capture everything after “version is”)
VERSIONS=$(sudo pihole -v 2>/dev/null | sed -n 's/.*version is \(.*\)/\1/p')
# Format each line as a code bullet
VERSIONS_FORMATTED=$(printf '%s\n' "$VERSIONS" | sed 's/.*/- `&`/')

# 5) Build the Markdown message with backticks around underscores
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

# 6) Send via Telegram using the correct token variable
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" \
     -d "chat_id=${TELEGRAM_CHAT_ID}" \
     -d "text=${MSG}" \
     -d "parse_mode=Markdown"
