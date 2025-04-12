#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Verify .env exists
if [[ ! -f .env ]]; then
  echo "[✗] Missing .env file."
  echo "    Please copy .env.example and fill in the required values before running install."
  exit 1
fi

# Verify required values exist in .env
MISSING_VARS=()

for var in TELEGRAM_BOT_TOKEN TELEGRAM_CHAT_ID PIHOLE_HOSTNAME; do
  value=$(grep "^$var=" .env | cut -d '=' -f2-)
  [[ -z "$value" ]] && MISSING_VARS+=("$var")
done

if [[ ${#MISSING_VARS[@]} -ne 0 ]]; then
  echo "[✗] The following required values are missing from .env:"
  for var in "${MISSING_VARS[@]}"; do
    echo "    - $var"
  done
  exit 1
fi

# Make all scripts in bin/ and lib/ executable
chmod +x bin/*.sh
chmod +x lib/*.sh

# Future: Interactive setup can go here
# ./bin/setup-interactive.sh

echo "[✓] All monitoring scripts are executable."
echo "[✓] Environment file validated."
echo "[✓] Install script completed."
