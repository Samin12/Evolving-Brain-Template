---
description: Scan the vault for misplaced, orphan, empty, or messy files and clean them up with user confirmation at each batch
argument-hint: [path] | --dry-run | --aggressive
---

The user wants you to tidy the vault. Stray files accumulate at the root, `Untitled*` files get created by accidental Obsidian clicks, inbox files get stuck, naming conventions drift. Your job is to find them, classify them, and clean up safely.

**The golden rule:** you never lose data. Everything that isn't clearly empty goes somewhere — either the right folder, `.inbox/manual/` for the inbox processor to handle later, or flagged for human review. You never delete content without showing the user what it is first.

## Arguments

- `$ARGUMENTS` may contain a path (scope scan to that subfolder), `--dry-run` (report only, don't act), `--aggressive` (also scan `0 - Identity/`, `Vault/`, and `.inbox/processed/`, which are normally off-limits).
- Default: scan the whole vault except the off-limits folders. Interactive, commits at the end.

## Procedure

### 1. Scan phase (read-only)

Walk the vault. For each file, classify into exactly one bucket:

**EMPTY** — 0 bytes, or only whitespace, or only YAML frontmatter with no body. Also matches `Untitled*.base` files that have no database definitions in them.

**ORPHAN AT ROOT** — a file sitting at the vault root that isn't in the approved root list:
- Approved root files: `README.md`, `AGENTS.md`, `MASTER PLAN.md`, `Coaching philosophy.md`, `LICENSE`, `.gitignore`
- Approved root folders: `0 - Identity`, `1 - Aspirations`, `2 - Live Logs`, `3 - Daily Journal`, `4 - Meetings`, `5 - Projects`, `6 - Areas`, `7 - Resources`, `8 - North Star`, `9 - Operations`, `People`, `Onboarding`, `Vault`, `Archive`, `.inbox`, `.claude`, `.obsidian`, `scripts`, `site`

**WRONG FOLDER** — a file whose filename, frontmatter, or content makes it obvious it belongs elsewhere. Examples:
- `meeting-notes-*.md` in `5 - Projects/` → belongs in `4 - Meetings/`
- A file with `type: action` frontmatter outside `2 - Live Logs/`
- A person-entity page outside `People/`

**NAMING VIOLATION** — file is in the right folder but its name violates the folder's convention:
- `.inbox/<source>/` files that don't match `YYYY-MM-DD-HHMMSS-<slug>.md`
- `4 - Meetings/` files that don't start with a date
- `3 - Daily Journal/` files that aren't named `YYYY-MM-DD.md`

**DUPLICATE** — same filename as another file in a different folder, or near-identical first 500 bytes as another file.

**STALE INBOX** — file in `.inbox/<source>/` (not `processed/`) with mtime older than 30 days. The processor probably failed on it.

**OK** — correctly placed, correctly named, has content. Not in the report.

### 2. Report phase

Present findings grouped by action, not by folder. Keep it scannable:

```
Tidy report for <path>

Safe to delete (empty files):
  <count> files, <total bytes> bytes
  - Untitled.base (0 B)
  - Untitled 1.base (0 B)
  - Untitled 2.base (0 B)
  - 2 - Live Logs/notes.md (only frontmatter, no body)

Safe to move (obvious destinations):
  <count> files
  - 2026-04-08-client-call.md (root) → 4 - Meetings/2026-04-08-client-call.md
  - action items.md (5 - Projects/) → .inbox/manual/2026-04-10-123045-action-items.md

Needs your review (content, no clear home):
  <count> files
  - thoughts.md (root, 340 bytes) — starts with "Had an idea about..."
  - fridays.md (root, 12KB) — long notes file, unclear category

Warnings (no action proposed):
  - Duplicate: inbox/voice/2026-04-09-idea.md and inbox/manual/2026-04-09-idea.md
  - Stale: .inbox/heptabase/2026-03-01-note.md (40 days old)
  - Naming: 4 - Meetings/random.md (no date prefix)

Total: N files flagged, M bytes total
```

**If `--dry-run`, stop here. Print the report and exit without any changes.**

### 3. Confirmation phase (interactive)

For each group:

- **Safe to delete** — ask once: "Delete all N empty files? [y/N]"
- **Safe to move** — ask once per batch: "Move all N files as shown? [y/N]". If the user says no, offer to review individually.
- **Needs review** — ask one by one, showing the first ~200 chars of content. Options per file:
  - **Delete** — only if the user explicitly confirms after seeing content
  - **Move to <path>** — if the user specifies
  - **Route to inbox** — move to `.inbox/manual/YYYY-MM-DD-HHMMSS-<slug>.md` with frontmatter, let the inbox processor handle it next run
  - **Skip** — leave it alone
- **Warnings** — do not act. Print them and move on. These need human judgment.

### 4. Act phase

Execute the approved actions. Rules:

- **Always use `git mv`** for moves, never raw `mv`. Preserves history.
- **Always use `git rm`** for deletes. Reversible via `git restore`.
- **Never overwrite** an existing file. If a move target exists, append `-2`, `-3`, etc. until unique.
- **Never act on `0 - Identity/`, `Vault/`, or `.inbox/processed/`** unless `--aggressive` was passed.
- **When routing to `.inbox/manual/`**, add frontmatter:
  ```yaml
  ---
  source: manual
  captured_at: <file mtime as ISO8601>
  type: note
  author: user
  origin: tidy-routed from <original path>
  ---
  ```
- **Never push.** Leave commits local so the user can review and push themselves.

### 5. Commit phase

One commit per tidy run. Message format:

```
tidy: N deletes, M moves, P routed to inbox

Deleted:
  - Untitled.base (empty)
  - Untitled 1.base (empty)
  - ...

Moved:
  - 2026-04-08-client-call.md → 4 - Meetings/
  - ...

Routed to inbox:
  - thoughts.md → .inbox/manual/2026-04-10-123045-thoughts.md
  - ...
```

### 6. Summary to the user

After the commit, print a short summary:
- What was done (counts)
- What was skipped (counts)
- Warnings that still need human decision
- A reminder to push if they want the changes on origin
- Suggest running `/brain-quick-wiki` if the wiki is stale after the tidy

## Hard rules

- **Never touch `0 - Identity/`, `Vault/`, `.inbox/processed/`** unless `--aggressive`.
- **Never delete a file with >100 bytes of non-frontmatter content** without showing the content and getting explicit confirmation.
- **Never push automatically.** Commit yes, push no.
- **Never classify a file in two buckets.** First match wins; the precedence is: EMPTY > ORPHAN AT ROOT > WRONG FOLDER > NAMING VIOLATION > DUPLICATE > STALE INBOX > OK.
- **If the vault isn't a git repo**, refuse and tell the user why. Tidy without git is too risky.
- **If there are uncommitted changes before tidy starts**, warn the user and ask if they want to commit first so the tidy commit stays clean.

## What tidy does NOT do

- Does not synthesize content — that's the inbox processor's job. Tidy just moves files into the right bucket.
- Does not update registries, logs, or entity pages — it only moves/deletes files.
- Does not run the inbox processor automatically after moving things. The user decides when to process.
- Does not delete anything in `Archive/` — archived content stays archived.
