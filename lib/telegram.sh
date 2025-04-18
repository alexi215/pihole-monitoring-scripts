#!/bin/bash

# lib/telegram.sh

# Load environment variables from project .env
ENV_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/.env"
if [[ -f "$ENV_FILE" ]]; then
  # shellcheck source=/dev/null
  source "$ENV_FILE"
else
  echo "Error: .env file not found at $ENV_FILE" >&2
  return 1
fi

send_telegram() {
  local message="$1"
  local escaped_message
  escaped_message=$(printf '%s' "$message" | sed 's/"/\\"/g')

  # Send and show any errors
  curl -v -s -X POST "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" \
    -d "chat_id=${TELEGRAM_CHAT_ID}" \
    -d "text=${escaped_message}" \
    -d "parse_mode=Markdown"
}
