#!/usr/bin/env bash
set -euo pipefail

export HOME="${HOME:-/home/hermes}"
export PATH="$HOME/.local/bin:/root/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

mkdir -p "$HOME/.hermes"

command -v hermes >/dev/null 2>&1 || exit 1

: "${TELEGRAM_BOT_TOKEN:?}"
: "${TELEGRAM_ALLOWED_USERS:?}"
: "${NVIDIA_API_KEY:?}"

umask 077
: > "$HOME/.hermes/.env"

printf '%s=%s\n' TELEGRAM_BOT_TOKEN "$TELEGRAM_BOT_TOKEN" >> "$HOME/.hermes/.env"
printf '%s=%s\n' TELEGRAM_ALLOWED_USERS "$TELEGRAM_ALLOWED_USERS" >> "$HOME/.hermes/.env"
printf '%s=%s\n' NVIDIA_API_KEY "$NVIDIA_API_KEY" >> "$HOME/.hermes/.env"
printf '%s=%s\n' NVIDIA_BASE_URL "${NVIDIA_BASE_URL:-https://integrate.api.nvidia.com/v1}" >> "$HOME/.hermes/.env"
printf '%s=%s\n' HERMES_MODEL "${HERMES_MODEL:-openai/gpt-oss-120b}" >> "$HOME/.hermes/.env"

# Start gateway bound to Render port
exec hermes gateway --port "${PORT:-10000}"
