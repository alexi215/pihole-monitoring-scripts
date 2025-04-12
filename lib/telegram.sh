#!/bin/bash
# lib/telegram.sh

send_telegram() {
  local message="$1"
  local escaped_message
  escaped_message=$(echo "$message" | sed 's/"/\\"/g')

  curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -d "chat_id=${TELEGRAM_CHAT_ID}" \
    -d "text=${escaped_message}" \
    -d "parse_mode=Markdown" > /dev/null
}
