---
status: active
schedule: "0 6 * * MON"   # Mondays at 6am — before the weekly review
scope: global
last_run: null
next_run: null
owner: claude
---

# Sync upstream

Check every upstream source tracked in `9 - Operations/upstream/` for changes since the last pinned commit. Report diffs. Never auto-apply.

## Role

You are the watcher that keeps our borrowed patterns from going stale. Upstream sources evolve; so should we, deliberately. But never silently — every change a human reviews is a change they own.

## Inputs

- Every folder under `9 - Operations/upstream/` that has an `UPSTREAM.md` manifest
- Network access to fetch the current state of each upstream repo (via `gh api` for GitHub sources, curl for others)

## Output

- A dated report at `9 - Operations/upstream/SYNC-REPORT-YYYY-MM-DD.md` listing, per upstream source:
  - Tracked files with changes since last pin
  - A short summary of what changed (generated from the diff)
  - A recommendation: adopt, ignore, or needs-thought
- Updated `last_run` in this workflow's frontmatter
- A row in `9 - Operations/runs/YYYY-MM.md`

**This workflow never modifies the pinned copies.** Adoption is a separate manual step after review.

## Procedure

### 1. Enumerate upstreams

For each subdirectory of `9 - Operations/upstream/` that contains an `UPSTREAM.md`:

- Read the manifest to get:
  - Upstream repo and branch
  - Pinned commit hash
  - List of tracked files with local paths and upstream paths

### 2. Fetch current upstream state

For GitHub sources:
```bash
gh api repos/<owner>/<repo>/commits/<branch> --jq '{sha, date: .commit.author.date, message: .commit.message}'
```

If the current HEAD sha equals the pinned sha, note "no changes" and move on.

Otherwise, for each tracked file, fetch the current version:
```bash
gh api "repos/<owner>/<repo>/contents/<upstream-path>?ref=<current-sha>" --jq '.content' | base64 -d
```

### 3. Diff each file

For each tracked file, compare the current upstream version to the pinned local copy. Use `diff -u` or generate a structured diff summary:

- Lines added / removed
- Sections renamed
- Files that disappeared upstream
- New files in the upstream folder that aren't tracked

### 4. Summarize changes

For each file with changes, write a short (~3-5 bullet) summary of what changed:

- New sections added
- Existing sections rewritten (with a one-line characterization)
- Deleted sections
- Purely cosmetic edits

If the change is purely cosmetic (typos, whitespace), mark as `cosmetic` and deprioritize.

### 5. Recommend

For each changed file, recommend one of:

- **ADOPT** — the change is clearly an improvement, aligns with our design, low-risk. Human should review and merge into our adaptations.
- **CONSIDER** — the change is interesting but requires thought. May conflict with our design or need adaptation.
- **IGNORE** — the change is out of scope for us (e.g., a Postgres-only feature, an OpenClaw-specific tweak, a rename we don't care about).
- **BLOCKED** — the change introduces something incompatible with our architecture (e.g., a new runtime dependency).

Base the recommendation on:
- The adoption level recorded in `UPSTREAM.md` for this file (`yes`, `partial`, `reference`)
- Whether the change adds new features or just reorganizes existing ones
- Whether the change requires infra we've explicitly avoided (Postgres, cloud services, paid APIs)

### 6. Write the report

Create `9 - Operations/upstream/SYNC-REPORT-YYYY-MM-DD.md`:

```markdown
# Upstream sync report — YYYY-MM-DD

## gbrain
- **Pinned:** e9f3c9c (2026-04-10)
- **Current:** abc1234 (2026-04-17)
- **Commits between:** 12

### Changes

#### `docs/GBRAIN_SKILLPACK.md` — ADOPT
- Added Section 18 "Live Sync" with cron registration examples
- Revised Section 17 upgrade flow to handle direct user requests
- Minor: updated version markers to 0.5.0

Recommendation: the Live Sync section is useful — we should add a similar "how to keep the brain current" section to our MASTER PLAN Phase 5 (scheduled processing). Review the section and distill the parts that apply to our markdown-only architecture.

#### `skills/query.SKILL.md` — CONSIDER
- (diff summary)

...

## Summary

- Total files changed: N
- Recommended ADOPT: X
- Recommended CONSIDER: Y
- Recommended IGNORE: Z
- Recommended BLOCKED: 0

Next step: human reviews this report, opens each file with an ADOPT or CONSIDER recommendation, and decides whether to merge changes into our workflows / templates / docs. After a decision, update `UPSTREAM.md` with the new pinned commit and a note on what was (or wasn't) adopted.
```

### 7. Update state

- Update this file's `last_run` frontmatter to current timestamp
- Append a row to `9 - Operations/runs/YYYY-MM.md`

Do NOT update the pinned commit in any `UPSTREAM.md` automatically. That happens only after human review.

## Hard rules

- **Never modify pinned copies.** They're snapshots, not living files.
- **Never modify our own workflows / templates / docs** during a sync run. Report, don't act.
- **Never delete or rename a pinned file** during a sync. If upstream deletes a file we track, note it in the report.
- **Never call or install upstream code** during a sync. Read-only, always.
- **If network fetch fails**, log the error, skip that source, continue with others.
