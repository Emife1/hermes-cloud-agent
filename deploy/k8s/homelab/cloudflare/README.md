# Cloudflare exposure

Cloudflare exposure is intentionally not enabled in the first migration.

Hermes Telegram long polling only needs outbound access, not public inbound HTTP.

Enable Cloudflare only after:

1. Pod is running in `hermes-olufunke`.
2. `/healthz` returns 200 through port-forward.
3. `/readyz` returns 200 after gateway startup.
4. Telegram probe succeeds.

Recommended internal service target if needed later:

```text
http://hermes-cloud-agent.hermes-olufunke.svc.cluster.local:10000
```

Suggested public paths:

- `/healthz`
- `/statusz`

Avoid exposing raw control surfaces until access policy is explicit.
