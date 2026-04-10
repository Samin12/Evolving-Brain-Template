---
description: Check every upstream source for changes and report diffs — never auto-applies
argument-hint: [source-name] | --all
---

Run `9 - Operations/workflows/sync upstream.md` to check upstream sources for changes since the last pin.

## Arguments

- No argument or `--all` → check every source under `9 - Operations/upstream/`
- `<source-name>` → check only that source (e.g., `gbrain`)

## What happens

1. Follow the sync upstream workflow procedure.
2. Fetch the current state of each tracked upstream file.
3. Diff against the pinned copy in `9 - Operations/upstream/<source>/`.
4. Generate a report at `9 - Operations/upstream/SYNC-REPORT-YYYY-MM-DD.md`.
5. Print a summary of the report: counts by recommendation (ADOPT / CONSIDER / IGNORE / BLOCKED).
6. Tell the user where the full report is and what the single next action is.

## After the report

Ask the user if they want to:
- **Review the full report** — open the file and walk through it together
- **Adopt specific changes** — walk through each ADOPT item and decide whether to merge into our workflows/templates
- **Schedule it** — if this is the first sync and the workflow isn't scheduled, offer to set up a cron
- **Nothing for now** — leave it for a human read later

## Rules

- **Never** auto-merge changes. Adoption is a separate human decision.
- **Never** update pinned commits during a sync report run.
- **Never** fetch gigantic files blindly. If a file grew by >10x since last pin, flag it and ask whether to fetch.
- If network errors happen, print them and continue — partial reports are better than none.
