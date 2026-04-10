---
description: Scan the user's machine for markdown-heavy folders and propose them as import sources for onboarding
argument-hint: [path]
---

Scan the user's filesystem for directories that look like they contain a knowledge base worth importing. Report what you find, let the user pick which ones to migrate.

Inspired by gbrain's discovery flow (see `9 - Operations/upstream/gbrain/skills/setup.SKILL.md`). Simplified for our markdown-only model.

## Arguments

- No argument → scan the default set of locations
- `<path>` → scan that specific path only

## Default scan locations

- `~/Documents/`
- `~/git/`, `~/src/`, `~/code/`, `~/projects/`, `~/dev/`, `~/work/` (whichever exist)
- `~/Desktop/`
- `~/Obsidian/` (common Obsidian vault location)
- `~/Library/Mobile Documents/iCloud~md~obsidian/` (iCloud-synced Obsidian vaults on macOS)
- `~/Dropbox/Apps/remotely-save/` (Obsidian + Dropbox)

**Do NOT scan:**
- `~/.Trash`, `~/Library` (except the Obsidian iCloud path), `/tmp`, `/var`, `/System`, `/Applications`
- This repo itself (the brain being onboarded)
- Anything inside `node_modules`, `.git`, `venv`, `__pycache__`, `.next`, `.cache`, `target`

## Procedure

### 1. Walk the scan locations

For each location that exists, find subdirectories (max depth 3) that contain markdown files. For each candidate directory, gather:
- Total size (human-readable)
- Count of `.md` files (recursive, excluding the ignore list above)
- Count of non-`.md` files (binary / attachments)
- Whether it's a git repo (presence of `.git/`)
- Whether it's an Obsidian vault (presence of `.obsidian/`)
- Whether it's a Logseq graph (presence of `journals/` and `pages/`)
- Whether it's a Notion export (filename patterns like `*-<hash>/`)
- Most recent modification time (from the newest `.md` file)

Skip any directory with fewer than 5 `.md` files — too small to be interesting.

### 2. Classify each candidate

Based on the gathered signals:

- **Obsidian vault** → `.obsidian/` present
- **Logseq graph** → `journals/` + `pages/` subfolders
- **Notion export** → Notion-style hashed filenames
- **Plain markdown repo** → git repo, not obviously any of the above
- **Loose markdown** → not a git repo, just a folder of `.md` files

### 3. Report

Format (concise, scannable):

```
=== Brain Discovery ===

Found N candidate markdown sources:

[1] ~/Documents/obsidian-vault
    Obsidian vault, 1,203 .md files, 180 MB
    Last modified: 2026-04-09
    → Migration: ready (obsidian format supported)

[2] ~/git/brain
    Plain markdown repo (git), 342 .md files, 2.3 GB, 87 binary files
    Last modified: 2026-04-10
    → Migration: ready (plain markdown supported)

[3] ~/Documents/notion-export-2025
    Notion export, 847 .md files, 520 MB
    Last modified: 2025-11-14
    → Migration: ready (notion format supported)

[4] ~/Desktop/random-notes
    Loose markdown (no git), 12 .md files, 340 KB
    Last modified: 2026-03-20
    → Migration: ready (plain markdown supported)

=== Discovery Complete ===
```

### 4. Offer next steps

Ask the user which sources they want to migrate. Options per candidate:

- **Migrate now** — run `9 - Operations/workflows/migrate.md` with the source path and format, dry-run first
- **Skip** — don't migrate, don't ask about it again (remember the skip in the report?)
- **Come back later** — defer, include in a future scan

If the user picks one or more "migrate now", run the migrate workflow on each in sequence, with dry-run confirmations.

## Performance rules

- **Depth limit: 3.** Don't recurse forever into nested projects.
- **Short-circuit large directories.** If a directory exceeds 10 GB, stop traversing and just note its size with a warning.
- **Skip `node_modules` et al hard.** They always contain `.md` files (READMEs) but none of them are interesting.
- **Use `find -type f -name "*.md"` with exclusions**, not a manual recursive walk, for speed.

## Privacy rules

- **Never read file contents during discovery.** Only metadata (names, sizes, counts, modification times). Content reading happens in the migrate workflow after the user picks what to migrate.
- **Never follow symlinks outside the home directory** — avoid surprise traversal.
- **Never scan `/Users/<someone-else>/`** if there are multiple user accounts on the machine.

## What discover does NOT do

- Does not read or import file contents (that's migrate)
- Does not modify anything outside the brain's own working directory
- Does not phone home or send anything externally
- Does not assume the user wants to migrate everything — it lists, the user picks
