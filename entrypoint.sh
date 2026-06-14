#!/usr/bin/env bash
set -Eeuo pipefail

export HOME="${HOME:-/home/hermes}"
export PORT="${PORT:-10000}"
export PATH="${HOME}/.local/bin:/usr/local/bin:/usr/bin:/bin:${PATH}"

mkdir -p "${HOME}/.hermes" /tmp/hermes

HEALTH_PID=""
HERMES_PID=""

cleanup() {
  status=$?
  echo "Shutting down Hermes cloud agent processes..." >&2 || true

  if [[ -n "${HERMES_PID:-}" ]] && kill -0 "${HERMES_PID}" 2>/dev/null; then
    kill "${HERMES_PID}" 2>/dev/null || true
  fi

  if [[ -n "${HEALTH_PID:-}" ]] && kill -0 "${HEALTH_PID}" 2>/dev/null; then
    kill "${HEALTH_PID}" 2>/dev/null || true
  fi

  wait 2>/dev/null || true
  exit "${status}"
}

trap cleanup INT TERM EXIT

echo "Starting Hermes health server first on 0.0.0.0:${PORT}..."
python3 /usr/local/bin/hermes-health-server.py &
HEALTH_PID=$!
echo "${HEALTH_PID}" > /tmp/hermes-health-server.pid

sleep 1

if ! kill -0 "${HEALTH_PID}" 2>/dev/null; then
  echo "ERROR: Hermes health server failed to start." >&2
  exit 1
fi

echo "Hermes health server pid=${HEALTH_PID}"

if [[ -f /usr/local/etc/hermes-render-config.yaml ]]; then
  cp /usr/local/etc/hermes-render-config.yaml "${HOME}/.hermes/config.yaml"
  echo "Hermes config prepared from known-good NVIDIA/Telegram profile."
else
  echo "ERROR: Missing /usr/local/etc/hermes-render-config.yaml" >&2
  exit 1
fi

if ! command -v hermes >/dev/null 2>&1; then
  echo "ERROR: hermes CLI not found on PATH." >&2
  exit 1
fi

MODEL_VALUE="${HERMES_MODEL:-${MODEL:-openai/gpt-oss-120b}}"
PROVIDER_VALUE="${HERMES_PROVIDER:-${PROVIDER:-nvidia}}"

export MODEL="${MODEL_VALUE}"
export PROVIDER="${PROVIDER_VALUE}"

echo "Hermes clean runtime prepared with provider=${PROVIDER_VALUE} model=${MODEL_VALUE}"
echo "Starting Hermes gateway..."

hermes gateway &
HERMES_PID=$!
echo "${HERMES_PID}" > /tmp/hermes-gateway.pid

echo "Hermes gateway pid=${HERMES_PID}"

wait -n "${HEALTH_PID}" "${HERMES_PID}"
