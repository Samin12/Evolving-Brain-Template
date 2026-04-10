# Runs

Append-only log of every scheduled and manually-triggered workflow run. Grouped by year-month.

## Format

One file per month: `YYYY-MM.md`. Each run appends a row to the month's table.

```markdown
# 2026-04

| Run at | Workflow | Duration | Status | Summary |
|---|---|---|---|---|
| 2026-04-10 13:45:23 | inbox processing | 42s | ok | 3 files → 2 log entries, 1 project update |
| 2026-04-10 12:01:07 | inbox processing | 1.2s | ok | 0 files (idle) |
| 2026-04-10 09:00:14 | weekly review | 2m 18s | ok | review draft written to 8 - North Star/reviews/2026-04-week-15.md |
```

## Rules

- Append-only. Never edit past rows even if the summary was wrong.
- `Status` values: `ok`, `no-op`, `error`, `skipped`.
- `Summary` is one line, max ~120 chars. Longer details go in the workflow's own file or a dated note in the vault.
- When a run errors, include the error type in the summary and open a GitHub Issue on the repo if the error persists across 3 consecutive runs.
