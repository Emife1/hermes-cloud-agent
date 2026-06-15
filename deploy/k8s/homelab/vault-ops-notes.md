# vault-ops notes for Hermes Olufunke runtime

Target Vault path:

```text
temitayo/olufunke/hermes-cloud-agent/runtime
```

Expected `ClusterSecretStore`:

```text
vault-hermes-olufunke-runtime
```

Expected Kubernetes Secret rendered by ESO:

```text
namespace: hermes-olufunke
secret: hermes-cloud-agent-runtime
```

Use the existing vault-ops generator flow:

```bash
cd /Volumes/512-B/Documents/PERSONAL/workloads/vault-ops
python scripts/generate.py --inventory inventory.yaml
python scripts/apply_to_vault.py \
  --vault-addr http://127.0.0.1:18201 \
  --vault-token "$TOKEN" \
  --policies ./policies \
  --roles ./roles
```

Required runtime keys:

```text
TELEGRAM_BOT_TOKEN
COMPOSIO_API_KEY
NVIDIA_API_KEY
MODEL
PROVIDER
HERMES_MODEL
HERMES_PROVIDER
```

Recommended values for model/provider keys:

```text
MODEL=openai/gpt-oss-120b
PROVIDER=nvidia
HERMES_MODEL=openai/gpt-oss-120b
HERMES_PROVIDER=nvidia
```
