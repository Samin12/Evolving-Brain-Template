# .inbox

The landing zone for everything flowing into the brain.

Every connector, MCP, script, or voice note drops files here. The processor reads them, extracts signal, updates the right files in the vault, and moves the raw file to `.inbox/processed/YYYY-MM/`.

**Rule 1:** nothing in `.inbox/` is canonical. The vault is canonical. Files here are raw inputs waiting to be understood.
**Rule 2:** processed files are never deleted — they get moved, not removed. If a processing run was wrong, we can re-run against the original.

---

## The contract

Any connector writing to `.inbox/` must follow this format. If it does, the processor will handle the rest.

### File naming

```
.inbox/<source>/YYYY-MM-DD-HHMMSS-<slug>.md
```

- `<source>`: the connector name — `apple-notes`, `heptabase`, `voice`, `meetings`, `claude-chat`, `email`, `manual`, etc. Lowercase, kebab-case.
- Timestamp: when the thing was captured (not when it was written to disk).
- `<slug>`: short, human-readable hint. Processor will do the real understanding.

Example: `.inbox/voice/2026-04-10-093015-car-ride-thought.md`

### File contents

Markdown with optional YAML frontmatter. Frontmatter is strongly preferred — it tells the processor things it can't infer.

```markdown
---
source: voice
captured_at: 2026-04-10T09:30:15-04:00
type: note             # note | voice | meeting | chat | email | bookmark | task
author: samin          # samin | claude | other-name
origin: iPhone Voice Memos
tags: [driving, idea]
---

Raw content goes here. No structure required. Can be a transcript, a
paragraph, a bullet list, a stream of consciousness, whatever the
source produced.
```

If frontmatter is missing, the processor will guess defaults from the filename and folder.

### Subfolders

Create one subfolder per source. The processor walks recursively but uses the folder as a hint for the `source` field.

```
.inbox/
├── apple-notes/
├── heptabase/
├── voice/
├── meetings/
├── claude-chat/
├── email/
├── manual/           # for stuff you type directly
├── onboarding/       # ONE-TIME bulk dump during onboarding (see Onboarding/)
└── processed/        # never write here — the processor owns this
    └── YYYY-MM/
```

---

## What the processor does

See `9 - Operations/workflows/inbox processing.md` for the full prompt. Short version:

1. Walks `.inbox/` recursively, skipping `processed/`.
2. For each file, decides: is this an action, decision, emotion, learning, reflection, meeting note, project update, person mention, or reference material?
3. Appends structured entries to the appropriate `2 - Live Logs/` file OR updates entity pages in `5 - Projects/`, `6 - Areas/`, `People/`, etc.
4. Never overwrites anything. Append-only to logs. Merge-or-add on entity pages.
5. Adds `[[wiki links]]` between entities when a connection is detected.
6. Moves the raw file to `.inbox/processed/YYYY-MM/` preserving its subfolder.
7. Commits with a summary: `inbox: N files → M log entries, P entity updates`.

## What the processor does NOT do

- It does not edit `0 - Identity/` files. Identity changes only happen on explicit human review (see `9 - Operations/workflows/weekly review.md`).
- It does not edit `1 - Aspirations/GOALS.md` or `NORTH STAR.md`. Targets only change on explicit human review.
- It does not delete anything.
- It does not "clean up" old logs. Logs are append-only and sacred.
