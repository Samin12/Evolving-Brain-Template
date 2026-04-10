---
status: active
schedule: "0 7 * * *"     # every morning at 7am
scope: global
last_run: null
next_run: null
owner: claude
---

# Briefing

Compile a morning briefing: today's meetings + relevant context, active projects, open commitments, things the user said they wanted to follow up on, and the one or two things that actually matter today.

Borrowed concept from [gbrain's briefing skill](https://github.com/garrytan/gbrain) (`9 - Operations/upstream/gbrain/skills/briefing.SKILL.md`). Our version works against a markdown vault; theirs hits a Postgres index.

## Role

You are the chief of staff reading the user's brain first thing in the morning and preparing them for the day. Concise, useful, zero fluff. Every line earns its place.

## Inputs

- Today's date (from the system clock)
- Today's calendar events (from the user's connected calendar MCP, or `.inbox/meetings/` for scheduled meetings, or a calendar export if available)
- `1 - Aspirations/ACTIVE PROJECTS.md`
- `8 - North Star/NORTH STAR.md` current state
- `2 - Live Logs/ACTIONS_LOG.md` last 7 days (for open commitments)
- `2 - Live Logs/ASSISTANT_ACTIONS_LOG.md` last 7 days (for things Claude is holding for the user)
- `People/` for anyone in today's meetings
- Any `[[link]]`ed files from the above

## Output

- A briefing note at `4 - Meetings/YYYY-MM-DD daily briefing.md` OR printed to the chat, depending on how invoked
- Update `last_run` in this workflow
- Row in `9 - Operations/runs/YYYY-MM.md`

## Procedure

### 1. Gather today's events

Find meetings, calls, or scheduled events for today. Sources in priority order:
1. A calendar MCP that exposes events (if wired — check `9 - Operations/connectors/README.md`)
2. Upcoming meeting files in `4 - Meetings/` dated today
3. Action items in `ACTIONS_LOG.md` with a due date of today
4. Manual input from the user

If nothing found, note "no scheduled events" and proceed.

### 2. For each meeting / event

Pull context:
- **Person(s) involved** — read their `People/<name>.md` pages. Grab the compiled-truth section (not the full timeline).
- **Most recent interactions** — search the vault for the last 3 meetings / mentions involving this person
- **Open threads** — any unresolved commitments from the last interaction
- **Relevant projects** — if the person is tagged with projects in `ACTIVE PROJECTS.md`, surface them

Write a 4-6 line context block per meeting.

### 3. Active project status

For each entry in `ACTIVE PROJECTS.md`, check:
- When was the project's entity page last updated?
- Is there an open action in `ACTIONS_LOG.md` for this project in the last 7 days?
- Any blockers mentioned in the last update?

Flag anything that looks stuck or overdue.

### 4. Open commitments

Grep `ASSISTANT_ACTIONS_LOG.md` and `ACTIONS_LOG.md` for the last 7 days for entries marked "awaiting" or "draft" or "pending" — things that need the user's attention to move forward.

### 5. North Star snapshot

One line: "Metric X trended [up/down/flat] this week. Target: Y. Current: Z."

Only flag if there's a drift worth acting on. If everything's on track, say so in one line.

### 6. The two things that actually matter

This is the part the user will read if they skim everything else. Pick the **two** highest-leverage things on their plate today. One can be a meeting; one should be a project move. Justify each in one sentence.

### 7. Write the briefing

Format:

```markdown
# Briefing — YYYY-MM-DD

## Today at a glance
- 09:00 Meeting with [[Alex Chen]] — Q2 launch check-in
- 11:30 Focus block
- 14:00 Dentist
- 16:00 Meeting with [[Maya Patel]] — intro call for contractor role

## What matters today (read this first)

1. **The Alex meeting decides whether Q2 launch slips.** He's been tracking at 70% confidence for two weeks; if today's number is still 70%, you need to cut scope. Don't leave that call without a decision.
2. **Ship the draft email to the board.** Claude has it in `5 - Projects/<project>/drafts/` from Tuesday. Review, edit, send. It's been "awaiting" for 6 days.

## Meeting context

### 09:00 Alex Chen — Q2 launch check-in
Alex is the PM on Q2 launch. Last met 2026-04-03. Compiled truth: detail-oriented, prefers async written updates, pushed back last time on a scope expansion. Open thread: you asked for a revised timeline — does he have it today?
Related: [[5 - Projects/Q2 launch]], [[People/Alex Chen]]

### 16:00 Maya Patel — intro call for contractor role
First meeting. Maya was introduced by Jordan Park (see [[People/Jordan Park]] for context on Jordan). Background: ex-Acme infra engineer, looking for contract work. You told Jordan you'd consider her for the migration project.
Related: [[People/Maya Patel]], [[5 - Projects/Database migration]]

## Active projects
- **Q2 launch** (active, last update 2026-04-09): on track but 70% confident, Alex meeting today
- **Database migration** (active, last update 2026-04-05): stalled waiting on vendor; consider Maya
- **Marketing push** (paused): no change

## Open commitments (>= 3 days old)
- Draft email to board (6 days) — from Tuesday, awaiting your review in `5 - Projects/<project>/drafts/`
- Follow-up with Jordan Park on Maya intro (4 days)

## North Star
Step-away hours trending flat at ~4h. Target 6h by 90 days. No action needed today, but the automation % moved from 35% → 40% last week — that's the leverage lane.

## Nothing else to report.
```

### 8. Commit (optional)

If the user invoked this via `/brain-brief --save`, commit the file. Otherwise just print it to chat.

### 9. Update state

Update `last_run` frontmatter and append a row to `9 - Operations/runs/YYYY-MM.md`.

## Hard rules

- **Never fabricate context.** If a person's page doesn't exist, say "no prior context" — don't invent one.
- **Never pad.** If there's nothing notable, say so in one line. A 4-line briefing with real signal beats a 40-line briefing with filler.
- **Never reference information that isn't in the vault.** This is a brain briefing, not a general-knowledge chat.
- **Never skip "what matters today."** That section is the whole point.
- **Always cite sources** via `[[wiki links]]` so the user can dig deeper on anything.

## What briefing does NOT do

- Does not run maintenance — that's `dream cycle.md`
- Does not query external information — that's out of scope
- Does not schedule events or send messages
- Does not write action items back to logs (briefings are read-only views of existing state)
