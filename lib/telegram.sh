#!/bin/bash
# lib/telegram.sh

send_telegram() {
  local message="$1"

  curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" \
    -d "chat_id=${TELEGRAM_CHAT_ID}" \
    -d "text=${message}" \
    -d "parse_mode=Markdown" \
    || echo "⚠️  Telegram API call failed"
}
