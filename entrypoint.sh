#!/usr/bin/env bash
set -euo pipefail
export HOME="${HOME:-/home/hermes}"
export PATH="$HOME/.local/bin:/root/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
mkdir -p "$HOME/.hermes"
command -v hermes >/dev/null 2>&1 || exit 1
MODEL_VALUE="openai/gpt-oss-120b"
export HERMES_PROVIDER="nvidia"
export PROVIDER="nvidia"
export HERMES_MODEL="$MODEL_VALUE"
export HERMES_DEFAULT_MODEL="$MODEL_VALUE"
export DEFAULT_MODEL="$MODEL_VALUE"
export MODEL="$MODEL_VALUE"
export NVIDIA_MODEL="$MODEL_VALUE"
export OPENAI_MODEL="$MODEL_VALUE"
export ANTHROPIC_MODEL="$MODEL_VALUE"
find "$HOME/.hermes" "$HOME/.config" "$HOME/.local" -type f -size -2000k -exec sed -i 's#anthropic/claude-opus-4.6#openai/gpt-oss-120b#g' {} + 2>/dev/null || true
echo "Hermes clean runtime prepared with provider=nvidia model=$MODEL_VALUE"
python3 /usr/local/bin/hermes-health-server.py &
HEALTH_PID="$!"
echo "Starting Hermes gateway..."
hermes gateway &
HERMES_PID="$!"
trap 'kill "$HEALTH_PID" "$HERMES_PID" 2>/dev/null || true' INT TERM EXIT
wait "$HERMES_PID"
