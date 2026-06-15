#!/usr/bin/env bash
set -Eeuo pipefail

kubectl -n hermes-olufunke get pods -o wide
kubectl -n hermes-olufunke get externalsecret,secret,deploy,svc
kubectl -n hermes-olufunke logs deploy/hermes-cloud-agent --tail=120

kubectl -n hermes-olufunke port-forward svc/hermes-cloud-agent 10000:10000 >/tmp/hermes-olufunke-port-forward.log 2>&1 &
PF_PID=$!
trap 'kill ${PF_PID} 2>/dev/null || true' EXIT
sleep 3

curl -fsS http://127.0.0.1:10000/healthz
printf '\n'
curl -fsS http://127.0.0.1:10000/statusz
printf '\n'
curl -i http://127.0.0.1:10000/readyz
