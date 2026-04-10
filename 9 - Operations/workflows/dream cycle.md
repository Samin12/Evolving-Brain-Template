---
status: active
schedule: "0 3 * * *"     # every night at 3am
scope: global
last_run: null
next_run: null
owner: claude
---

# Dream cycle

The nightly maintenance run. Scans the day's captures, enriches entities, fixes broken citations, consolidates timeline entries, and reports anything that surfaced overnight. The user sleeps; the brain gets smarter.

Borrowed concept from [gbrain's DREAMS.md](https://github.com/garrytan/gbrain) (`9 - Operations/upstream/gbrain/docs/GBRAIN_SKILLPACK.md` Section on "The Dream Cycle"). Our version runs against a markdown vault with no database — the principles are the same, the mechanics are simpler.

## Role

You are the brain running its own maintenance. Every night, you:

1. Pull in anything new that arrived in `.inbox/` during the day (via the inbox processor)
2. Cross-reference recent captures against existing entity pages
3. Fix broken wiki-links caused by renames or moves
4. Consolidate append-only timeline entries that belong together
5. Detect contradictions between new captures and compiled-truth sections
6. Flag stale information that may need human review

You never delete content. You never edit `0 - Identity/`. You never rewrite `NORTH STAR.md` targets. You report, you enrich, you consolidate — but you don't overreach.

## Inputs

- Everything added to the vault in the last 24 hours (via `git log --since=1.day`)
- Entity pages affected by those changes (via following `[[wiki links]]`)
- `.inbox/` contents (processed fresh if anything is there)

## Output

- Updated entity pages (compiled-truth sections refined, timeline entries added)
- A nightly report at `9 - Operations/dreams/YYYY-MM-DD.md` with:
  - How many captures processed
  - How many entities enriched
  - How many broken links fixed
  - Contradictions surfaced (flagged, not resolved)
  - Stale-info candidates (entities not updated in >90 days)
  - Anything that needs human attention
- Updated `last_run` and a row in `9 - Operations/runs/YYYY-MM.md`
- A single commit: `dream cycle: YYYY-MM-DD — N captures, M entities enriched, P links fixed`

## Procedure

### 1. Run the inbox processor first

If `.inbox/` has unprocessed files, run `9 - Operations/workflows/inbox processing.md` to get them into the vault before starting the dream cycle proper. The dream cycle works on the post-inbox state.

### 2. Enumerate today's changes

```bash
git log --since="24 hours ago" --name-only --format="" | sort -u
```

This gives you every file that changed in the last day. Group by folder.

### 3. For each changed entity page

Read the file. Look at what changed today (from the diff). Then:

**Refine the compiled-truth section (top of file):**
- If new timeline entries today added facts the top doesn't reflect, update the top to reflect the current best understanding
- If the top makes a claim contradicted by today's entries, flag it as a contradiction (do NOT silently update — see rule below)
- Keep the top concise. If it grows past ~40 lines, that's a signal to compress

**Never rewrite timeline entries.** The timeline is append-only. Consolidation means editing the compiled-truth section above the timeline, not rewriting timeline rows.

### 4. Cross-reference recent captures

For each capture that landed in `2 - Live Logs/` today, check:

- Does it mention people who have pages in `People/`? If so, append a timeline entry to that person's page.
- Does it mention projects? Append to the project page's timeline.
- Does it mention topics that exist as entity pages in `7 - Resources/`? Same.
- Does it introduce a new person / project / topic that appears in 2+ captures but has no page? Create a stub with just the compiled-truth section empty and one timeline entry.

### 5. Fix broken wiki links

Walk every `[[link]]` in files changed today. If the link target doesn't exist (file renamed, moved, or never created):

- If there's an obvious successor (e.g., `[[John]]` → `People/John Smith.md` because there's exactly one match), fix the link.
- If ambiguous, flag in the report. Do not guess.

Use `git mv` history to detect renames automatically when possible.

### 6. Detect contradictions

A contradiction is when a new timeline entry claims something the compiled-truth section denies, or vice versa. Examples:
- Compiled truth says "works at Acme" but a meeting note today says "just joined Beta Corp"
- Compiled truth says "prefers async communication" but reflection today says "told me she hates Slack and wants phone calls"

**Rule:** never silently update the compiled-truth section when you detect a contradiction. Instead:
1. Leave the compiled-truth as-is
2. Add a "⚠️ Contradiction" note near the top of the entity page
3. Include both claims with their sources (dates + file links)
4. Flag in the nightly report for human review

The human decides which claim wins.

### 7. Flag stale info

Any entity page whose most recent timeline entry is older than 90 days is a stale candidate. Add it to the report under "Stale candidates — may need check-in or archival." Do NOT auto-archive.

### 8. Write the nightly report

Create `9 - Operations/dreams/YYYY-MM-DD.md`:

```markdown
# Dream cycle — YYYY-MM-DD

Started: <timestamp>
Duration: <duration>

## Captures processed today
- N files from .inbox/ → synthesized into M log entries + P entity updates

## Entities enriched
- People/Alex Chen: added 2 timeline entries (meeting + decision)
- 5 - Projects/Q2 launch: refined compiled-truth section (scope changed)
- ...

## Broken links fixed
- 5 - Projects/Old name.md → 5 - Projects/New name.md (3 links updated)
- ...

## Contradictions surfaced (NEEDS REVIEW)
- People/Alex Chen: compiled truth says "works at Acme", new note says "Beta Corp"
  - Sources: [[People/Alex Chen]] line 12 vs [[4 - Meetings/2026-04-10 - intro call]] line 18
- ...

## Stale candidates (>90 days since last update)
- People/Jordan Park (last updated 2026-01-05)
- ...

## Nothing surprising
- N entity pages were touched but nothing noteworthy happened

## Next dream in
- ~24 hours, at <next scheduled timestamp>
```

### 9. Commit

One commit with a summary message. Push automatically only if configured; default is commit-only, human pushes later.

## Hard rules

- **Never delete** content. Ever.
- **Never silently update** compiled-truth sections when a contradiction exists. Flag, don't resolve.
- **Never edit** `0 - Identity/`, `NORTH STAR.md` targets, or anything in `Vault/`.
- **Never archive** stale entities automatically. Stale is a flag, not a decision.
- **Never rewrite** timeline entries. They're append-only.
- **Never skip** the contradiction check — it's the single most valuable thing the dream cycle does.
- **If the dream cycle errors**, record the failure in `9 - Operations/runs/` and open a GitHub Issue on the repo if it fails 3 nights in a row.

## What the dream cycle does NOT do

- Does not run queries or briefings — those are separate workflows (`query.md`, `briefing.md`)
- Does not enrich from external APIs — that's `enrich.md` (and is opt-in)
- Does not send anything outside the vault (no emails, no slacks, no pings)
- Does not touch the user's other repos or files outside the vault
