#!/usr/bin/env bash
set -euo pipefail

export HOME="${HOME:-/home/hermes}"
export PATH="$HOME/.local/bin:/root/.local/bin:/usr/local/bin:/usr/bin:/bin"

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
  echo "Set at least one of OPENROUTER_API_KEY, KIMI_API_KEY, NVIDIA_API_KEY, OPENAI_API_KEY, ANTHROPIC_API_KEY, or GOOGLE_API_KEY." >&2
  exit 1
fi

echo "Starting Hermes gateway..."
exec hermes gateway
