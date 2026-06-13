#!/usr/bin/env bash
set -euo pipefail

export HOME="${HOME:-/home/hermes}"
export PATH="$HOME/.local/bin:/root/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

mkdir -p "$HOME/.hermes"

if ! command -v hermes >/dev/null 2>&1; then
  echo "ERROR: hermes command not found in PATH=$PATH" >&2
  exit 1
fi

required_vars=(
  "TELEGRAM_BOT_TOKEN"
  "TELEGRAM_ALLOWED_USERS"
)

for var_name in "${required_vars[@]}"; do
  if [ -z "${!var_name:-}" ]; then
    echo "ERROR: required environment variable ${var_name} is not set." >&2
    exit 1
  fi
done

if [ -z "${OPENROUTER_API_KEY:-}" ] && \
   [ -z "${KIMI_API_KEY:-}" ] && \
   [ -z "${NVIDIA_API_KEY:-}" ] && \
   [ -z "${OPENAI_API_KEY:-}" ] && \
   [ -z "${ANTHROPIC_API_KEY:-}" ] && \
   [ -z "${GOOGLE_API_KEY:-}" ]; then
  echo "ERROR: no supported model provider API key is set." >&2
  exit 1
fi

python3 /usr/local/bin/hermes-health-server.py &
HEALTH_PID="$!"

echo "Starting Hermes gateway..."
hermes gateway &
HERMES_PID="$!"

trap 'kill "$HEALTH_PID" "$HERMES_PID" 2>/dev/null || true' INT TERM EXIT

wait "$HERMES_PID"
