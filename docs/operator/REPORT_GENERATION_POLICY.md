# Hermes Report Generation Policy

This policy defines how Hermes should create business reports, Google Docs, and optional exported report artifacts.

## Purpose

Generated reports must be readable, professional, and easy to reuse. A report is successful only if the user can open it, understand it quickly, and trust that it was saved in the correct place.

## Standard report structure

Use this structure unless the user asks for something different:

1. Title
2. Executive Summary
3. Source Context
4. Findings
5. Decisions or Recommendations
6. Next Actions
7. Links or Artifacts Created

Prefer short paragraphs and clean sections. Use tables only when a table makes the document clearer. Do not force wide tables into Google Docs if paragraphs or bullets would be cleaner.

## Google Docs formatting rules

When creating Google Docs reports:

- Use clean plain text and simple headings.
- Avoid broken words and unnatural spacing.
- Write "PDF", not broken letter spacing.
- Write "spreadsheets", not split wording.
- Avoid artificial line breaks inside normal sentences.
- Avoid cramped Markdown tables unless specifically requested.
- Use bullet lists only when each bullet is short and useful.
- Verify that the final content is readable before returning the link.

## Storage rules

- Save report-type Google Docs in the Hermes Workspace Reports folder unless the user gives a different destination.
- If the user asks for a PDF export, save the PDF in the same Reports folder.
- If both a Google Doc and PDF are created, return both links.
- Do not create duplicate reports unless the user asks for a revised copy.

## Source handling

When a report is based on memory or workspace data:

- Prefer Notion as the living index and memory map.
- Prefer Google Drive as the archive and generated-file layer.
- Mention source pages or folders when useful.
- Do not invent source material.
- Say when a source was unavailable or incomplete.

## Anti-patterns

Avoid the following:

- Broken words caused by formatting or wrapping.
- Over-wide tables that render poorly on mobile.
- Raw Markdown pasted into Google Docs without cleanup.
- Fake progress claims when the Telegram adapter only returns final output.
- Any credential, password, token, or private secret in generated documents.
- Returning a document link before confirming the document was created.

## Acceptance checklist

Before returning a report link, verify:

- The title is clear.
- Sections are readable.
- No broken terms appear.
- The file is saved to the correct folder.
- The user receives the document link.
- Optional PDF export is linked when requested.
