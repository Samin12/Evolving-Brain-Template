# Upstream

Pinned copies of files we've borrowed ideas, patterns, or prompts from. Each upstream source has its own folder here with an `UPSTREAM.md` manifest listing which files are tracked and at what commit.

## Why this exists

- **Attribution.** Every pattern we adopt from another project has a traceable source.
- **Diffable updates.** When an upstream source evolves, we can diff against our pinned copy and decide whether to pull the changes in.
- **No runtime dependency.** We never import, install, or call the upstream source. We just read its markdown and learn from it. Our vault works even if the upstream disappears tomorrow.
- **No surprise behavior changes.** Upstream can ship anything it wants. We only adopt changes after a human reviews the diff.

## How it works

1. **Track** — when we adopt a file from an upstream source, we copy the current version into `upstream/<source>/` and record the source path + commit hash in that source's `UPSTREAM.md`.
2. **Sync** — `9 - Operations/workflows/sync upstream.md` fetches the latest version of each tracked file from upstream and diffs it against our pinned copy. It generates a report, never auto-applies.
3. **Adopt** — a human reads the diff, decides whether the change is worth pulling in, and either:
   - Updates the relevant workflow / skill / doc in the main vault to match the new upstream thinking, then updates the pinned copy and the commit hash
   - Ignores the change and updates the pinned copy + commit hash with a note explaining why we're not adopting
4. **Rollback** — because everything is in git, reverting a bad adoption is one `git revert` away.

## Running a sync

```
/brain-sync              # check all upstream sources for updates
/brain-sync gbrain       # check one specific source
```

Or manually: read `9 - Operations/workflows/sync upstream.md` and follow it.

## Adding a new upstream source

1. Create `upstream/<source-name>/` with:
   - `README.md` — why we track this source, what kinds of files we borrow from it
   - `UPSTREAM.md` — the manifest (see `upstream/gbrain/UPSTREAM.md` for format)
2. Pin the first batch of files you want to track.
3. Run the sync to verify it works.

## What does NOT belong here

- **Code we call at runtime.** If we're calling a package, that's a dependency, not an upstream source.
- **Third-party libraries.** Upstream sources are for *ideas*, not imports.
- **Random snippets.** If it's worth tracking, it's worth committing to the manifest with a hash.
- **Our own writing.** The vault proper is the canonical location for our stuff. Upstream is strictly borrowed material.

## Current upstreams

| Source | Purpose | First pinned | Files tracked |
|---|---|---|---|
| [gbrain](./gbrain) | Personal knowledge brain patterns, entity schema, skillpack | 2026-04-10 | 11 |
