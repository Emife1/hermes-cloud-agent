#!/usr/bin/env bash
set -euo pipefail

export HOME="${HOME:-/home/hermes}"
export PATH="$HOME/.local/bin:/root/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

mkdir -p "$HOME/.hermes"

if ! command -v hermes >/dev/null 2>&1; then
  echo "ERROR: hermes command not found" >&2
  exit 1
fi

: "${TELEGRAM_BOT_TOKEN:?}"
: "${TELEGRAM_ALLOWED_USERS:?}"
: "${NVIDIA_API_KEY:?}"

umask 077
: > "$HOME/.hermes/.env"

cat >> "$HOME/.hermes/.env" <<EOF
TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}
TELEGRAM_ALLOWED_USERS=${TELEGRAM_ALLOWED_USERS}
NVIDIA_API_KEY=${NVIDIA_API_KEY}
NVIDIA_BASE_URL=${NVIDIA_BASE_URL:-https://integrate.api.nvidia.com/v1}
HERMES_MODEL=${HERMES_MODEL:-openai/gpt-oss-120b}
EOF

hermes gateway &
PID=$!

trap "kill $PID" INT TERM EXIT
wait $PID
