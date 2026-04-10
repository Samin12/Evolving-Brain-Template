---
status: active
schedule: on-demand
scope: global
last_run: null
owner: claude
---

# Migrate

Universal migration prompt: take data from another tool (Obsidian, Notion, Logseq, Roam, Day One, Apple Notes, Heptabase, plain markdown, CSV, JSON) and turn it into `.inbox/onboarding/<source>/` files that the onboarding processor can understand.

Borrowed pattern from [gbrain's migrate skill](https://github.com/garrytan/gbrain) (`9 - Operations/upstream/gbrain/skills/migrate.SKILL.md`). Their version writes directly into the brain structure; ours stops at the inbox so the onboarding processor stays in charge of synthesis.

## Role

You are the translator. Source material arrives in some messy format from another tool. You convert it to markdown-with-frontmatter that matches our `.inbox/` contract. You do not synthesize, you do not deduplicate, you do not edit content — you translate.

## Inputs

- A source path pointing at the exported data from another tool
- A source name (e.g., `obsidian`, `notion`, `day-one`, `apple-notes`)
- Optionally: a date range to restrict what gets migrated

## Output

- Files in `.inbox/onboarding/<source>/` with proper frontmatter
- A migration report at `.inbox/onboarding/<source>/MIGRATION-REPORT.md`

## Supported source formats

### Obsidian vault
- **Input:** a directory containing `.md` files (possibly with `.obsidian/` config)
- **Preserves:** folder structure, frontmatter, `[[wiki links]]`, tags
- **Transforms:** adds `source: obsidian`, `captured_at` (from file mtime), `type: note` to frontmatter
- **Strategy:** copy each `.md` file, update frontmatter, rename to our convention if dates are parseable

### Notion export (Markdown + CSV)
- **Input:** unzipped Notion export folder
- **Preserves:** page text, frontmatter from databases, attachments (copy references)
- **Transforms:** converts Notion's weird `{slug}-{id}` filenames to readable slugs; extracts database rows into one file per row
- **Strategy:** walk the export, convert page-by-page; databases become folders of files

### Day One JSON export
- **Input:** `journal.json` file from Day One export
- **Preserves:** entry text, date, tags, location, weather (as frontmatter)
- **Transforms:** one file per entry, named by date
- **Strategy:** parse JSON, emit one `.md` per entry

### Day One plain-text export
- **Input:** a `.txt` or `.md` file with entries separated by headers like `# Date`
- **Strategy:** split on headers, one file per entry

### Apple Notes (via Exporter, Bear import, or AppleScript)
- **Input:** either a folder of `.md` files (from Exporter) or a raw export
- **Preserves:** note text, title, creation date
- **Transforms:** frontmatter with `source: apple-notes`, strip Apple-specific junk, fix list formatting
- **Strategy:** normalize filenames to `YYYY-MM-DD-HHMMSS-<slug>.md` when dates are available

### Heptabase whiteboard export
- **Input:** the folder produced by Heptabase's "Export as Markdown"
- **Preserves:** card content, card titles, card-to-card links
- **Transforms:** links become `[[wikilinks]]`; if cards are part of a whiteboard, the whiteboard structure becomes frontmatter metadata
- **Strategy:** one file per card

### Logseq graph
- **Input:** a Logseq graph folder (contains `journals/`, `pages/`, `assets/`)
- **Preserves:** page and journal text, block structure (flattened), tags
- **Transforms:** Logseq `[[links]]` map directly; block references become footnotes
- **Strategy:** one file per page and one per journal entry

### Roam Research JSON export
- **Input:** Roam's JSON export
- **Preserves:** page text, block hierarchy, refs
- **Transforms:** flatten block hierarchy into markdown with indentation; refs become `[[links]]`
- **Strategy:** one file per page

### Plain markdown folder
- **Input:** any directory of `.md` files
- **Strategy:** copy as-is, add frontmatter if missing

### CSV / JSON
- **Input:** structured data file where each row / object should become a note
- **Strategy:** ask the user for a field mapping — which column is the title, which is the body, which is the date. Emit one file per row.

## Procedure

### 1. Identify the source format

Ask the user what tool the data is from, or detect from filename patterns if possible:
- `journal.json` with Day One keys → Day One JSON
- Folder with `.obsidian/` subdir → Obsidian
- Folder with `journals/` + `pages/` → Logseq
- `.zip` containing Notion's folder structure → Notion
- Otherwise ask

### 2. Validate the input

Check:
- Is the path real and readable?
- Is it a directory or a single file as expected for the format?
- Approximate size (files and bytes)
- If >1 GB, warn the user and ask if they want to proceed — this is a lot of data and may blow up context windows downstream

### 3. Dry run (default)

Before writing anything:
- Count how many output files would be produced
- Sample 5 random entries and show what they'd become (filename + frontmatter + first 200 chars of body)
- Wait for the user to confirm before proceeding

### 4. Migrate

For each input item, emit one output file to `.inbox/onboarding/<source>/<filename>.md` with:

```yaml
---
source: <source name>
captured_at: <ISO8601 — from the original file or the source tool>
type: <note | reflection | meeting | journal | etc — best guess>
author: <user or source-inferred>
origin: <specific source tool and export version if known>
original_path: <path inside the source export, so we can trace back>
tags: [<any tags from the source>]
---

<body>
```

Rules:
- **Do not edit content.** Copy verbatim except for format conversions (Notion → standard markdown, Roam blocks → flat text).
- **Do not deduplicate.** If the same entry appears in two places, emit both. The onboarding processor handles dedup.
- **Do not skip files** that look empty or junky — include them. It's cheaper to let the processor filter than to lose a useful entry.
- **Do preserve metadata** — every bit of frontmatter in the source should land in our frontmatter.
- **Do normalize dates** to ISO8601 in the `captured_at` field.

### 5. Write the migration report

Create `.inbox/onboarding/<source>/MIGRATION-REPORT.md`:

```markdown
# Migration report — <source>

- Source format: <format>
- Source path: <path>
- Source size: <N files, M bytes>
- Migrated at: <timestamp>

## Stats
- Files emitted: <count>
- Bytes emitted: <bytes>
- Files skipped: <count> (with reasons)
- Warnings: <list>

## Sample of migrated files
- <first 5 filenames with 1-line previews>

## Next step
Run the onboarding processor (`9 - Operations/workflows/onboarding processing.md`)
in `bulk-only` mode to synthesize this migrated data into the vault.
```

### 6. Update state

Update `last_run` and append a row to `9 - Operations/runs/YYYY-MM.md`.

## Hard rules

- **Always do a dry run first** unless the user explicitly passes `--no-dry-run`.
- **Never write outside `.inbox/onboarding/<source>/`** during a migration.
- **Never call the onboarding processor automatically** after a migration. That's a separate decision.
- **Never skip files silently** — any skip gets reported in the migration report with a reason.
- **Never lose the source.** Keep the original export intact. Never move-or-delete the source data, only copy from it.
- **If an error occurs mid-migration**, stop, report what was done, leave the partial output in place (don't roll back — the user can run tidy later).

## What migrate does NOT do

- Does not synthesize or understand the content — that's the onboarding processor
- Does not create entity pages — that's the onboarding processor
- Does not update logs or trackers
- Does not delete source data
