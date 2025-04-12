#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

echo ">>> Installing Pi-hole Monitoring Scripts"

# 1. Ensure all scripts in /bin are executable
chmod +x "$SCRIPT_DIR"/bin/*.sh

# 2. Verify .env exists
if [ ! -f "$ENV_FILE" ]; then
  echo ">>> .env file not found!"
  echo "Please create one by copying .env.example and editing your config:"
  echo ""
  echo "cp .env.example .env && nano .env"
  exit 1
fi

# 3. Install cron jobs
(crontab -l 2>/dev/null; echo "*/2 * * * * $SCRIPT_DIR/bin/monitor-pihole.sh") | crontab -
(crontab -l 2>/dev/null; echo "0 8 1 1,4,7,10 * $SCRIPT_DIR/bin/quarterly-report.sh") | crontab -

echo ">>> Install complete."
