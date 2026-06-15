# Hermes Cloud Agent homelab deployment

This pack runs Olufunke's Hermes Cloud Agent as an isolated, low-footprint, always-on Kubernetes workload.

Source of truth:

- Repository: `Emife1/hermes-cloud-agent`
- Branch: `clean-render`
- Image: `ghcr.io/emife1/hermes-cloud-agent:clean-render`
- Namespace: `hermes-olufunke`
- Vault runtime path: `temitayo/olufunke/hermes-cloud-agent/runtime`

## Intent

This replaces Render Free for Telegram long polling. Render can sleep; a Kubernetes pod in the homelab stays running and can keep the Telegram listener alive.

The first deployment is intentionally internal-only:

- `Service` is `ClusterIP`
- no Ingress
- no Cloudflare route yet
- outbound internet required for Telegram, Composio, model providers, Notion, and Google APIs

Expose with Cloudflare only after `/healthz`, `/readyz`, and Telegram probe pass.

## Resource boundary

The namespace has a hard quota and conservative defaults. The pod starts at:

- request: `100m` CPU / `256Mi` memory
- limit: `500m` CPU / `512Mi` memory

The namespace quota caps the whole namespace at:

- requests: `500m` CPU / `768Mi` memory
- limits: `1` CPU / `1Gi` memory

## Vault / ESO

Do not commit secrets to GitHub.

Use your `vault-ops` helper flow to create/apply Vault policy, role, and store material for:

```text
temitayo/olufunke/hermes-cloud-agent/runtime
```

Known vault-ops flow from your environment:

```bash
cd /Volumes/512-B/Documents/PERSONAL/workloads/vault-ops
python scripts/generate.py --inventory inventory.yaml
python scripts/apply_to_vault.py \
  --vault-addr http://127.0.0.1:18201 \
  --vault-token "$TOKEN" \
  --policies ./policies \
  --roles ./roles
```

The `ExternalSecret` expects a `ClusterSecretStore` named:

```text
vault-hermes-olufunke-runtime
```

It produces this Kubernetes secret:

```text
hermes-cloud-agent-runtime
```

Required keys at the Vault path:

```text
TELEGRAM_BOT_TOKEN
COMPOSIO_API_KEY
NVIDIA_API_KEY
MODEL
PROVIDER
HERMES_MODEL
HERMES_PROVIDER
```

Optional fallback keys:

```text
OPENROUTER_API_KEY
NOUS_API_KEY
```

## Deploy

From this repository root:

```bash
kubectl config current-context
kubectl apply -k deploy/k8s/homelab
```

Then verify:

```bash
kubectl -n hermes-olufunke get pods
kubectl -n hermes-olufunke logs deploy/hermes-cloud-agent --tail=100
kubectl -n hermes-olufunke port-forward svc/hermes-cloud-agent 10000:10000
curl -fsS http://127.0.0.1:10000/healthz
curl -fsS http://127.0.0.1:10000/statusz
curl -i http://127.0.0.1:10000/readyz
```

Telegram probe:

```text
Reply with exactly HERMES_AGENT_PROBE_OK and nothing else.
```

## Rollback / removal

The workload is isolated. Full removal:

```bash
kubectl delete ns hermes-olufunke
```

## Cloudflare exposure

Not enabled in this first pack. Add after the pod is stable. Telegram long polling does not need public inbound traffic.
