---
status: active
schedule: one-time
scope: global
last_run: null
modes: [bulk-only, full]   # bulk-only skips Identity/Aspirations generation
owner: claude
---

# Onboarding processing

The one-time bulk processor. Runs after a human has filled out the identity/aspirations questions and dumped bulk notes into `.inbox/onboarding/`. Produces first-draft Identity and Aspirations files plus a big initial batch of entity pages and log entries.

## Two modes

- **`bulk-only`** (the quick-win mode): process only the bulk dump into Live Logs and entity pages. Skip Identity/Aspirations generation entirely. Use when the user has dumped data but hasn't answered the onboarding questions yet. This gives them a fast visualization win before asking for the harder work.
- **`full`** (the complete mode): process both the question answers and the bulk dump. Generate first-draft Identity and Aspirations files. Use only after the user has actually answered `Onboarding/01` and `02`.

Detect mode automatically: if `Onboarding/01 - identity questions.md` has no answers filled in under any `>` prompt, default to `bulk-only` and tell the user. If answers are present, default to `full`.

This is the single biggest write event in the lifetime of the vault. Treat it with more care than the ongoing processor.

---

## Role

Same role as `inbox processing.md`: writer compiling, not filing clerk. Synthesize. Link. Compress. Do not overwrite.

But with two differences:

1. You **are allowed** to write first drafts of `0 - Identity/*.md` and `1 - Aspirations/*.md` during onboarding. This is the one moment when those files get generated. After onboarding, they are immutable to you.
2. You must produce **a review report** (not just a commit) so the human can read and approve before anything becomes canonical.

## Inputs

- `Onboarding/01 - identity questions.md` (filled in by human)
- `Onboarding/02 - aspirations questions.md` (filled in by human)
- Everything under `.inbox/onboarding/` (bulk dumps from their existing tools)
- Current vault state (which is mostly empty — you're filling it)

## Output

- First-draft versions of all files in `0 - Identity/` and `1 - Aspirations/`
- Initial entries in all `2 - Live Logs/` files based on what you found in the bulk dump
- Entity pages in `5 - Projects/`, `6 - Areas/`, `People/`, `7 - Resources/` for every project, person, and topic that appears more than twice in the bulk dump
- `Onboarding/REVIEW REPORT.md` — a structured report of what you did, what you were unsure about, and what the human should review first
- Raw files moved to `.inbox/processed/onboarding/<source>/`
- One commit with message `onboarding: initial synthesis (N entities, M log entries)` — but **do not push** until the human approves

---

## Procedure

### 1. Read the question responses

Read both onboarding question files fully. These are the ground truth for identity and aspirations. The bulk dump gives you voice, examples, and context — but if the questions and the dump conflict, the questions win.

If a question is unanswered, do not make something up. Leave that part of the generated Identity file as `> _Unanswered during onboarding — fill in when ready._`

### 2. Sample and read the bulk dump

You may not have context budget to read every file in `.inbox/onboarding/`. Strategy:

- **Read in full**: any folder with ≤50 files. Read everything.
- **Sample**: any folder with >50 files. Read a chronological sample — roughly every Nth file to hit ~50 per folder — plus any file whose filename contains keywords from the question answers (names of projects, people, goals).
- **Skip**: files >20KB unless the first 2KB suggests they're high-signal. Note skipped files in the review report.

Always read the most recent 10 files in each folder in full, regardless of size.

### 3. Generate Identity and Aspirations first drafts

Write `SOUL.md`, `DECISION MAKING PRINCIPLES.md`, `INTELLECTUAL BLUEPRINT.md`, `GOALS.md`, `HABITS.md`, `ACTIVE PROJECTS.md`, `12 FAVORITE PROBLEMS.md`, and update `NORTH STAR.md` baselines.

Rules:

- Use the human's own voice whenever possible. Quote directly from the bulk dump for lines that carry weight. Attribute quotes with dates where possible.
- Where the questions and dump agree, write with confidence.
- Where they're silent, leave a placeholder with a `TODO` marker.
- Do not add content that isn't supported by either the questions or the dump. No filler wisdom, no generic advice, no LinkedIn-isms.
- At the top of each file, add a comment: `<!-- Generated during onboarding on YYYY-MM-DD. Review, edit, and remove this comment when satisfied. -->`

### 4. Extract entities from the dump

For every project mentioned in the dump, create `5 - Projects/<name>.md`. Populate with: 1-sentence description (from the dump), any dates you can infer, links to the dump files that mention it.

For every person mentioned more than twice, create `People/<name>.md`. Populate with: relationship to the user (inferred or from the question answers), first and most recent mention dates, 1-2 direct quotes if they carry signal.

For every recurring topic or area, create or update `6 - Areas/<area>.md`.

### 5. Backfill the Live Logs

For each Live Log file (`ACTIONS`, `DECISIONS`, `EMOTIONS`, `LEARNING`, `REFLECTIONS`), write ~5-20 entries drawn from the bulk dump. Cover the last 6-12 months. These are retrospective entries — mark them clearly: `**Date:** 2025-11-14 _(backfilled from onboarding)_`.

### 6. Write the review report

Create `Onboarding/REVIEW REPORT.md` with:

```markdown
# Onboarding review report

Generated on YYYY-MM-DD.

## Files written
- 0 - Identity/SOUL.md (generated from 5/5 question answers + 12 dump files)
- 0 - Identity/DECISION MAKING PRINCIPLES.md (generated from 5/5 question answers + 8 dump files)
- ...

## Confidence levels
- HIGH: files where questions and dump clearly agreed
- MEDIUM: files where I had to interpolate
- LOW: files with thin source material — review carefully

## Flagged for human attention
- Contradictions between questions and dump (with file references)
- Sensitive content noticed in the dump that might not belong in the vault
- Identity claims in the dump that felt aspirational rather than true — flagged, not filtered
- Files I chose to skip and why

## What I could not do
- Questions left unanswered → listed by file
- Files I could not read → listed with reason
- Entities I was unsure about → listed

## Suggested first edits by the user
- A ranked list of 5-10 files the user should review first
```

### 7. Commit, do not push

Create the commit. Message: `onboarding: initial synthesis (N entities, M log entries) — needs human review`

**Do not push.** Wait for the human to read the review report, edit generated files, and manually push when satisfied.

---

## Hard rules

- Never invent quotes.
- Never claim a fact that isn't traceable to the questions or the dump.
- Never skip the review report. It is the contract between you and the human.
- Never push to origin during onboarding — that's the human's job after review.
- If the bulk dump contains anything that looks like a password, API key, or private key, do not copy it into the vault. Flag it in the review report.
