#!/usr/bin/env bash
set -Eeuo pipefail

EXPECTED_CONTEXT="${EXPECTED_CONTEXT:-tca-infraforge}"
CURRENT_CONTEXT="$(kubectl config current-context)"

if [[ "${CURRENT_CONTEXT}" != "${EXPECTED_CONTEXT}" ]]; then
  echo "ERROR: expected kubectl context ${EXPECTED_CONTEXT}, got ${CURRENT_CONTEXT}" >&2
  exit 1
fi

kubectl apply -k deploy/k8s/homelab
kubectl -n hermes-olufunke rollout status deploy/hermes-cloud-agent --timeout=180s
