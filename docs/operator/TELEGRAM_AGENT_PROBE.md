# Hermes Telegram Agent Probe

This document defines safe probes for checking Hermes from the user-facing Telegram path.

## Probe layers

Hermes has three different health layers:

1. `/healthz` confirms that the Render web service is alive.
2. `/readyz` confirms that the deployed service is ready enough for the gateway path.
3. A Telegram agent probe confirms that the real user path works: Telegram to Hermes to tools to Telegram reply.

A green web health check does not prove that Telegram message processing is healthy.

## Manual Telegram probe

Send this prompt in Telegram:

```text
Reply with exactly HERMES_AGENT_PROBE_OK and nothing else.
```

Expected result:

```text
HERMES_AGENT_PROBE_OK
```

If this fails, the Telegram adapter, gateway loop, or message queue may be unhealthy even if `/healthz` is green.

## Memory/tool probe

Send this prompt in Telegram:

```text
Check the Hermes Memory Map in Notion and return the latest saved memory about Notion and Google Drive.
```

Expected result:

- Hermes reads the Notion Memory Map.
- Hermes returns the latest Notion and Google Drive memory entries.
- Hermes does not create or modify anything.

Failure meanings:

- No response: Telegram or gateway dispatch may be queued or stuck.
- Response without Notion content: tool access or skill routing may be failing.
- Ambiguous Notion skill error: Notion skill disambiguation needs attention.

## Document-generation probe

Send this prompt in Telegram:

```text
Create a Google Doc report titled Hermes Probe Report using the Notion Memory Map as source, save it in the Reports folder, and return the link.
```

Expected result:

- Hermes reads the Notion Memory Map.
- Hermes creates a clean Google Doc.
- Hermes saves it in the Hermes Workspace Reports folder.
- Hermes returns the document link.

This probe validates the practical path: memory read to reasoning to document creation to Drive storage to Telegram reply.

## Heartbeat limitation

Prompt rules can ask Hermes to acknowledge work, but true live typing dots or live progress messages require Telegram adapter-level support. If the adapter buffers output until completion, progress text can appear only in the final answer.

Do not claim that live typing is working unless it is observed in Telegram.

## Probe cadence

Run the manual probe after deployments, after memory-provider changes, and after tool-connector changes.

Do not spam multiple probes rapidly. If messages appear queued, wait for the queue to drain before testing again.
