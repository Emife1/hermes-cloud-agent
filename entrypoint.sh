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
MODEL_VALUE="${HERMES_MODEL:-openai/gpt-oss-120b}"
export HERMES_MODEL="$MODEL_VALUE"
export DEFAULT_MODEL="${DEFAULT_MODEL:-$MODEL_VALUE}"
export HERMES_DEFAULT_MODEL="${HERMES_DEFAULT_MODEL:-$MODEL_VALUE}"
export MODEL="${MODEL:-$MODEL_VALUE}"
export NVIDIA_MODEL="${NVIDIA_MODEL:-$MODEL_VALUE}"
printf '%s=%s\n' DEFAULT_MODEL "$DEFAULT_MODEL" >> "$HOME/.hermes/.env"
printf '%s=%s\n' HERMES_DEFAULT_MODEL "$HERMES_DEFAULT_MODEL" >> "$HOME/.hermes/.env"
printf '%s=%s\n' MODEL "$MODEL" >> "$HOME/.hermes/.env"
printf '%s=%s\n' NVIDIA_MODEL "$NVIDIA_MODEL" >> "$HOME/.hermes/.env"

# Start a lightweight health server on Render's required PORT, then run Hermes gateway.
# The Hermes CLI expects a gateway subcommand (run/start/etc.); passing PORT here
# makes Render's value become an invalid gateway command. The health server owns
# the Render web port while Hermes runs with its normal gateway defaults.
python3 /usr/local/bin/hermes-health-server.py &
HEALTH_PID="$!"

echo "Starting Hermes gateway..."
hermes gateway &
HERMES_PID="$!"

trap 'kill "$HEALTH_PID" "$HERMES_PID" 2>/dev/null || true' INT TERM EXIT

wait "$HERMES_PID"
