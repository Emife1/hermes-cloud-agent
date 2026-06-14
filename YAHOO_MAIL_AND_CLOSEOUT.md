# Yahoo Mail and Closeout Plan

Olufunke's primary Yahoo mailbox is `orisaseemife@yahoo.com`.

## Yahoo Mail route

There is no confirmed native Yahoo Mail Composio mailbox connector in the current tool inventory. Until a dedicated Yahoo bridge exists, the practical route is:

1. Forward or collect Yahoo Mail into Olufunke's Gmail account.
2. Let Hermes use the connected Gmail tools against that routed mail.
3. Label or filter Yahoo-originated messages so Hermes can search them as Yahoo-routed mail.
4. Later add a dedicated Yahoo bridge through one of these routes:
   - IMAP/SMTP worker with secure credentials stored outside GitHub.
   - Windows worker for attended Yahoo webmail tasks.
   - A future native Yahoo MCP/tool if one becomes available.

## Staff model closeout

The live Telegram config now uses grouped desks rather than too many individual names:

- Chief of Staff
- Family and Home Office
- Admin, Calendar, and Inbox
- Documents, PDFs, Sheets, and Files
- Content and Brand Desk
- Business Operations Desk
- Business Research and Opportunity Scout
- Customer Follow-up Desk
- Finance and Records Desk
- Full-Stack App Developer
- QA and Review Desk
- Knowledge Manager

## Remaining technical work

- Verify the latest Render deploy reaches live.
- Test Telegram role list and routing behavior.
- Test heartbeat/progress updates with a longer task.
- Configure Yahoo to Gmail routing.
- Create Yahoo-routed Gmail labels/filters.
- Test Yahoo-routed search and summary from Telegram.
- Verify Google Docs to PDF from Telegram.
- Verify screenshot delivery or defer to the Windows worker.
- Create Drive folder structure for Reports, Family Admin, Customers, Finance, App Projects, Screenshots, and Inbox Exports.
- Add backend async job queue later if prompt-level heartbeat is not enough.

## Approval gates

Ask before sending, forwarding, deleting, sharing, publishing, submitting forms, spending money, or making irreversible changes.
