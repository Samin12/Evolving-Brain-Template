# 5 - Projects

PARA-style projects: things with a defined outcome and an end date. One file (or folder) per project.

See `1 - Aspirations/ACTIVE PROJECTS.md` for the index of what's in flight.

## The dossier pattern

Each project page follows the **compiled-truth + append-only timeline** structure (see `People/README.md` for the full philosophy — borrowed from [gbrain's recommended schema](../9%20-%20Operations/upstream/gbrain/docs/GBRAIN_RECOMMENDED_SCHEMA.md)):

- **Top: Compiled truth.** Current state, scope, goals, blockers, confidence. Rewritable when state changes.
- **Bottom: Timeline.** Append-only updates with dates and sources. Never rewritten.

## File or folder?

- **Simple project** (few pages of notes, few people involved) → one file: `5 - Projects/<project-name>.md`
- **Complex project** (drafts, attachments, sub-workflows) → folder with an `index.md`: `5 - Projects/<project-name>/index.md`, with subfolders like `drafts/`, `workflows/`, `research/`

Default to the file form. Upgrade to a folder when you hit > 5 attached files.

## Template

```markdown
---
id: project-q2-launch-2026
type: project
status: active              # active | paused | completed | archived
scope: business             # business | personal | collab
owners: [self]
collaborators: [[[People/Alex Chen]]]
created: 2026-02-01
updated: 2026-04-10
due: 2026-06-30
confidence: 70              # 0-100, your honest read right now
tags: [launch, q2]
---

# Q2 launch

## Compiled truth

**Goal:** ship the v2 platform to all customers by end of Q2. Success = 95% of active customers migrated without incident, NPS stays flat or improves.

**Scope:** data migration, UI redesign, billing flow update. Deferred: mobile app parity (moved to Q3).

**Current state:** Design approved 2026-03-15. Backend migration 60% done. Frontend rewrite in progress, on track for 2026-05-15 feature freeze. Billing flow blocked on legal review (see Blockers).

**Blockers:**
- Legal review of new billing terms (2 weeks overdue, Liz has it)
- Still need to decide on the deprecation timeline for v1 API

**Confidence:** 70%. Dropped from 85% on 2026-04-03 after [[People/Alex Chen]] flagged scope creep. If legal slips another week, drop to 50%.

**North Star check:** this project moves automation % (up, lots of manual billing work gets automated in v2) and revenue per person (flat in Q2, up in Q3). Step-away hours probably drop during migration.

**Key files:**
- [[5 - Projects/Q2 launch/design-doc]]
- [[5 - Projects/Q2 launch/drafts/customer-email]]
- [[5 - Projects/Q2 launch/workflows/pre-launch-check]]

## Timeline

- **2026-04-09** Slack thread with Alex: scope creep concern (third time). Agreed to a scope freeze meeting Monday. → [[People/Alex Chen]]
- **2026-04-03** Q2 check-in with Alex. Confidence dropped from 85% → 70%. Revised timeline requested by EOW. → [[4 - Meetings/2026-04-03 - Alex Q2 check-in]]
- **2026-03-29** Backend migration hit 60% complete. Ahead of schedule. → [[2 - Live Logs/ACTIONS_LOG]]
- **2026-03-15** Design doc approved. Signed off by me, Alex, and [[People/Jordan Park]]. → `5 - Projects/Q2 launch/design-doc.md`
- **2026-02-14** Legal review started on new billing terms. → [[ACTIONS_LOG]]
- **2026-02-01** Project kickoff. Initial scope, goal, and team. → [[DECISIONS_LOG]]
```

## Rules

### Compiled-truth section
- Keep it to the current state, not the history
- Update whenever a timeline entry materially changes the state
- The "Confidence" and "Blockers" fields should reflect your honest read today, not wishful thinking

### Timeline
- Append-only, newest first
- Every entry links to its source (meeting, log entry, capture)
- Never edit past entries; add correction entries instead

### When to archive
- `status: archived` when the project is done, paused indefinitely, or explicitly killed
- Move the file to `Archive/5 - Projects/` (preserve the folder structure)
- Keep the file intact — archived isn't deleted

### Persistent IDs
Every project has a stable `id` in frontmatter: `project-<slug>-<year>`. Links by ID don't break on rename.
