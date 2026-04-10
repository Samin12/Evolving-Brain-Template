---
status: active
schedule: "0 4 * * SUN"   # Sundays at 4am — after the last dream cycle of the week
scope: global
last_run: null
next_run: null
owner: claude
---

# Maintain

Weekly brain health check. Detects contradictions, stale information, broken links, orphan files, and naming drift. Reports findings, never auto-fixes anything that would lose information.

Borrowed pattern from [gbrain's maintain skill](https://github.com/garrytan/gbrain) (`9 - Operations/upstream/gbrain/skills/maintain.SKILL.md`).

## Relationship to other workflows

- **Dream cycle** runs nightly and does *per-day* maintenance — consolidation of today's changes, contradictions introduced today, broken links caused by today's renames.
- **Maintain** runs weekly and does *whole-vault* maintenance — scans for drift that accumulates over time, across many days.
- **Brain tidy** (`/brain-tidy`) handles *structural* mess — files in the wrong place, empty files, naming violations. That's a different kind of maintenance and it's interactive.

Maintain is the global, background scan. The other two handle fast-changing and structural issues.

## Role

You are the brain auditor. You read the whole vault, you find drift, and you write a report. You never delete, never rewrite, never silently resolve ambiguity.

## Inputs

- The entire vault (except `Vault/` and `.inbox/processed/`)
- Git history for the last 30 days (to detect staleness)

## Output

- A report at `9 - Operations/maintain/YYYY-MM-DD.md`
- Updated `last_run` and a row in `9 - Operations/runs/YYYY-MM.md`
- No file changes to the vault content

## Procedure

### 1. Contradictions

For every entity page (`People/`, `5 - Projects/`, `6 - Areas/`, `7 - Resources/`):

- Read the compiled-truth section at the top
- Read the last 10 timeline entries (or all if fewer)
- Check if any timeline entry contradicts the compiled truth

If you find contradictions, add them to the report under "⚠️ Contradictions":

```markdown
### People/Alex Chen
- Compiled truth: "Works at Acme, focused on platform infra"
- Timeline 2026-04-05: "Mentioned he's interviewing at Beta Corp"
- Timeline 2026-04-09: "Signed offer at Beta Corp, starts May"
- Recommendation: update compiled-truth section and add a "previously: Acme" note
```

Dream cycle catches same-day contradictions. Maintain catches slow-drip contradictions where the truth changed over multiple days and nobody noticed.

### 2. Stale entity pages

An entity page is stale if:
- Most recent timeline entry is >90 days old, AND
- The entity appears in `ACTIVE PROJECTS.md` or in recent captures anyway (otherwise it's probably archived)

Report these under "Stale — in use but not updated":

```markdown
### 5 - Projects/Database migration
- Last timeline entry: 2026-01-05 (95 days ago)
- Still listed in ACTIVE PROJECTS.md
- Mentioned 3 times in captures in the last 30 days
- Recommendation: either update the project page to reflect current state, or move to Archive/
```

### 3. Broken wiki-links

For every `[[wiki link]]` in the vault:

- Check if the target exists
- If not, try to find an obvious successor (renames, exact substring match, capitalization differences)

Report under "Broken links":

```markdown
- `[[Old project name]]` in `2 - Live Logs/REFLECTIONS_LOG.md` line 47
  - No direct match
  - Possible successor: `5 - Projects/New project name.md`
```

Maintain does NOT auto-fix broken links. Dream cycle fixes them for same-day renames. Maintain reports the ones dream cycle didn't catch because the rename was old.

### 4. Orphan pages

An orphan is an entity page with:
- Zero incoming `[[wiki links]]` from any other file in the vault
- More than 7 days old (fresh pages are allowed to be orphans temporarily)

Orphans aren't necessarily wrong — some pages stand alone. But often they indicate a page that was created and forgotten.

Report under "Orphans":

```markdown
- `People/Jordan Park.md` — zero incoming links, created 2026-02-14, last updated 2026-02-14
  - Question: is this person still relevant? Consider archiving or linking from somewhere.
```

### 5. Naming drift

Scan file names for inconsistency:

- `People/` files: are they all `Firstname Lastname.md` or is there a mix of `Firstname.md`, `firstname-lastname.md`, etc.?
- `4 - Meetings/` files: are they all `YYYY-MM-DD - <topic>.md`?
- `5 - Projects/` files: consistent naming convention?

Report drift patterns, not individual files. Example:

```markdown
- People/ has 14 files in "Firstname Lastname" format and 3 in "firstname-lastname" format
- Recommendation: pick one and migrate (or accept the drift if it doesn't bother you)
```

### 6. Unprocessed inbox age

If `.inbox/` has files older than 7 days that aren't in `processed/`, the inbox processor is probably failing or not scheduled. Report this.

### 7. Write the report

Create `9 - Operations/maintain/YYYY-MM-DD.md`:

```markdown
# Maintain report — YYYY-MM-DD

Vault state: <total entity pages>, <total timeline entries>, <total captures processed>

## ⚠️ Contradictions (NEEDS REVIEW)
<count> found
...

## Stale — in use but not updated
<count> found
...

## Broken links
<count> found (dream cycle fixes fresh ones; these are older)
...

## Orphan pages
<count> found
...

## Naming drift
...

## Unprocessed inbox
<count> files older than 7 days

## Trends
- Vault grew by N files this week
- M entity pages updated
- P contradictions resolved since last maintain run
- Q captures processed by the inbox processor

## Nothing concerning this week
<if true>
```

### 8. Update state

Update `last_run` frontmatter and append a row to `9 - Operations/runs/YYYY-MM.md`.

### 9. Do not commit or push

Maintain is a report generator. The only file written is the report itself. No content changes. The user decides whether to act on the report and drives the fixes manually (or via targeted prompts to Claude).

## Hard rules

- **Never auto-resolve contradictions.** The whole point is to surface them for a human.
- **Never delete orphan pages.** Orphans are flagged, not removed.
- **Never auto-fix broken links.** Only the dream cycle does that, and only for fresh (same-day) renames.
- **Never archive stale pages.** Report, don't act.
- **Never edit the entity pages themselves** during a maintain run.
- **If maintain finds >50 issues total**, flag that the vault needs real attention and shorten the report to the top 20 by severity.

## What maintain does NOT do

- Does not process inbox (that's the inbox processor)
- Does not enrich from external sources (that's `enrich.md`, out of scope for now)
- Does not write to any entity page
- Does not run queries or briefings
