# People

One file per person who matters to you. Not a contact list — a living dossier of your relationship with them.

## The dossier pattern

Every person page follows the **compiled-truth + append-only timeline** structure, borrowed from [gbrain's recommended schema](../9%20-%20Operations/upstream/gbrain/docs/GBRAIN_RECOMMENDED_SCHEMA.md):

- **Top: Compiled truth.** Your current best understanding of this person. Rewritable. When the truth changes, you rewrite the top. The top is always consistent with the most recent evidence.
- **Bottom: Timeline.** Append-only evidence trail. Every interaction, decision, quote, or observation gets a dated entry. Timeline entries are NEVER rewritten, only added to.

This shape means: the top is always readable as "who is this person today", and the bottom preserves the full history of how you got there. Contradictions between top and bottom surface as audit candidates — either the top needs updating, or the bottom reveals a drift you should think about.

## File shape

Filename: `People/<firstname-lastname>.md` (kebab-case, or `Firstname Lastname.md` — pick one convention per vault and stick to it; the maintain workflow will flag drift).

## Template

```markdown
---
id: person-alex-chen-2026
type: person
created: 2026-04-10
updated: 2026-04-10
aliases: [Alex, Alex C.]
---

# Alex Chen

## Compiled truth

Current PM at Acme on the Platform team. Introduced by [[People/Jordan Park]] at the Q4 offsite 2025. Detail-oriented, prefers async written updates, pushes back on scope expansion (usually rightly). Lives in Brooklyn, two kids, runs on weekends.

**What matters to them:** shipping quality over shipping fast, being trusted with autonomy, not being micromanaged.

**Relationship:** collaborator on [[5 - Projects/Q2 launch]]. We work well when I give clear goals and leave execution to them.

**Open threads:** waiting on revised timeline for Q2 launch (asked 2026-04-03). Considering bringing them into [[5 - Projects/Database migration]] if bandwidth opens up.

**Communication:** Slack for async, email for formal, 1:1 Zoom every other Friday.

## Timeline

- **2026-04-09** Posted in Slack about scope creep on Q2 launch. Third time this quarter. Pattern worth noting — he's not wrong. → [[2 - Live Logs/REFLECTIONS_LOG]]
- **2026-04-03** Q2 launch check-in call. Flagged 70% confidence, asked for scope cut. I committed to reviewing revised timeline by EOW. → [[4 - Meetings/2026-04-03 - Alex Q2 check-in]]
- **2026-03-18** Emailed me the design doc for platform migration. Clean, thorough, 8 pages. → `7 - Resources/platform-migration-design.md`
- **2026-02-14** First solo meeting. Coffee at Stumptown. Discussed his frustration with former PM lead. → [[4 - Meetings/2026-02-14 - Alex intro]]
- **2026-01-20** Jordan introduced us over email. → [[People/Jordan Park]]
```

## Key rules for the processor and the dream cycle

### When writing the compiled-truth section (TOP)

- Keep it concise — aim for ~15-30 lines of prose. If it grows past 40, compress.
- State facts directly. No filler, no LinkedIn-speak, no pretend-confidence.
- Mark inferences as inferences: "seems to prefer X", not "prefers X", when you're guessing.
- Update the top when the bottom proves it wrong. This is the whole point of the pattern.
- Never invent context the timeline doesn't support.

### When writing a timeline entry (BOTTOM)

- **Date in bold at the start.** ISO8601 format.
- **One bullet per entry.** Keep it to 1-3 sentences.
- **Always link the source** — the meeting file, the log entry, the capture — so a reader can trace the claim.
- **Quote directly** when the person said something that matters. Use quote marks. Attribute by date.
- **Never edit past entries.** If you were wrong about something, add a correction entry below, don't rewrite the history.
- **Timeline is reverse-chronological** (newest first) for readability.

### When the processor detects a contradiction

If the top says X and a new timeline entry says not-X:
1. Add the timeline entry (append-only, always)
2. Do NOT silently update the compiled-truth section
3. Add a `⚠️ Contradiction` callout near the top with both claims and their sources
4. Flag it in the nightly dream cycle report for human review

The human decides which claim wins.

### When creating a new person page

Only create when the person appears in at least 2 captures (one-off mentions don't become entity pages). Populate only what's supported by the captures — no invented details. Give them a persistent `id` in frontmatter so renames don't break links.

### Persistent IDs

Every person page has a stable `id` in frontmatter of the form `person-<slug>-<year>`. If the person changes name (marriage, rename), update the file name and the `aliases` array, but keep the `id` unchanged. Links by `id` never break.
