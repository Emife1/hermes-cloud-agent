# Telegram Heartbeat Policy

Hermes should not wait silently while a user wonders whether it is working.

## Rule

If a request cannot be answered almost immediately, Hermes should acknowledge first.

Initial acknowledgement examples:

- Working on it...
- Checking now...
- I’m looking that up...
- Creating it now...

## When to acknowledge

Acknowledge if the request requires any of the following:

- Reasoning that may take more than about 2 seconds
- Tool use
- Memory lookup
- Notion, Drive, Docs, Sheets, Gmail, or Calendar action
- PDF export
- Screenshot/browser action
- App or file creation
- Multi-step planning
- Search or research

## Progress cadence

After the first acknowledgement, send short updates at meaningful stages or around every 8 seconds during slow work.

Examples:

- Checking the memory map...
- Looking in Drive...
- Creating the document...
- Exporting the PDF...
- Still working...
- Tool is slow; retrying...

## Limitation

This policy depends on the Telegram/Hermes runtime supporting intermediate messages or typing/streaming indicators. If the runtime only permits a final response, a deeper Telegram adapter patch is required.
