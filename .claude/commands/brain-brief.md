---
description: Compile and print a morning briefing — today's meetings, active projects, open commitments, what matters most today
argument-hint: [--save] | [YYYY-MM-DD]
---

Run `9 - Operations/workflows/briefing.md` and report back to the user.

## Arguments

- No argument → briefing for today, print to chat
- `--save` → briefing for today, write to `4 - Meetings/YYYY-MM-DD daily briefing.md` and commit
- `YYYY-MM-DD` → briefing for a specific date (past review or future prep)

## Procedure

1. Read the briefing workflow prompt at `9 - Operations/workflows/briefing.md` and follow it.
2. Gather today's (or the specified date's) events, meetings, active projects, open commitments, North Star snapshot.
3. Pick the two highest-leverage things that actually matter today.
4. Format the briefing per the workflow's template.
5. If `--save` was passed, write to `4 - Meetings/YYYY-MM-DD daily briefing.md` and `git add` + `git commit` with message `briefing: YYYY-MM-DD`. Do not push.
6. Update `last_run` in the workflow file.
7. Append a row to `9 - Operations/runs/YYYY-MM.md`.

## Before starting

Check if the user has any calendar connector wired in `9 - Operations/connectors/README.md`. If not, tell them the briefing will only cover what's in the vault (meeting files in `4 - Meetings/`, action items with dates in `ACTIONS_LOG.md`) — not their actual calendar. Offer to help them wire a calendar connector if they want real calendar integration.

## After printing the briefing

Ask if they want to:
- **Dig into one meeting** — pull full context on a specific person or project
- **Draft a prep note** for a specific meeting
- **Mark something done** — if a commitment in the briefing is actually completed, update the relevant log
- **Nothing, good briefing** — ack and exit

## Rules

- Never pad. A 4-line briefing with real signal beats a 40-line briefing with filler.
- Never fabricate context. Use only what's in the vault.
- Never cite information not in the vault.
- Every meeting / project / person mentioned must have a `[[wiki link]]` so the user can dig deeper.
