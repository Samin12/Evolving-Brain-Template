---
description: Show the current state of the Evolving Brain — active workflows, recent runs, connectors, what's due next
---

Give the user a concise status report on their brain. No fluff.

## What to report

### 1. Workflows
Read `9 - Operations/workflows/README.md` and list:
- Count of active / paused / archived workflows
- Any workflow whose `last_run` frontmatter is older than 2x its schedule interval (potentially stuck)
- Any workflow with a `next_run` in the next 24 hours

### 2. Recent runs
Read the current month's file at `9 - Operations/runs/YYYY-MM.md` and list:
- Last 5 runs
- Any runs with status `error` in the last 7 days
- If no runs file exists for this month, say so

### 3. Connectors
Read `9 - Operations/connectors/README.md` and list:
- Count of active connectors by type (MCP, poller, watch, shortcut)
- Any connector whose health you can check cheaply (e.g., "last file in `.inbox/<source>/` was N hours ago")

### 4. Inbox health
- How many unprocessed files in `.inbox/` (excluding `processed/`)
- Oldest unprocessed file's age
- If > 50 files or > 24h old, flag it

### 5. North Star snapshot
Read `8 - North Star/METRICS_LOG.md` and report the most recent row. If the latest row is older than 10 days, flag it.

### 6. What's due next
The single next action the user should take. Pick one of:
- "Inbox has N unprocessed files — run `/brain-inbox` or wait for next scheduled run"
- "Weekly review is due today"
- "Metric X is stale — update it in the next review"
- "Nothing is due. Good time to rest or work on a project."

## Format

Short. Tables where possible. No preamble. No "Here's your status:" — just start with the tables.

## Rules

- Do not make suggestions beyond what's in the data.
- Do not trigger any workflows during a status check.
- Do not modify any files.
- Read-only. Fast.
