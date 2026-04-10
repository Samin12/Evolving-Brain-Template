---
status: active
schedule: on-demand
scope: global
last_run: null
owner: claude
---

# Query

How to answer a question by reading the brain. Three-layer retrieval: start broad, narrow down, cite sources.

Borrowed pattern from [gbrain's query skill](https://github.com/garrytan/gbrain) (`9 - Operations/upstream/gbrain/skills/query.SKILL.md`). Their version uses Postgres + hybrid vector search; ours uses grep and directory structure. The shape of the answer is the same.

## Role

You are reading the user's brain to answer a question. You cite sources. You never make things up. When the brain doesn't know, you say so clearly.

## Inputs

- A question (from the user, or inferred from context)
- Read access to the entire vault

## Output

- An answer with citations in the form `[[path/to/file.md]]` or `[[entity name]]`
- If the answer is incomplete, a clear statement of what's missing and where to look next

## Procedure

### 1. Identify entities in the question

Extract: people, projects, time ranges, topics, places. These become your initial search targets.

Example: "What did I commit to in the last call with Alex about Q2 launch?"
- People: Alex
- Project: Q2 launch
- Time range: last call (most recent)
- Type: commitment

### 2. Layer 1 — Direct lookups

For each identified entity, try the obvious file:
- People → `People/<name>.md`
- Project → `5 - Projects/<name>.md`
- Area → `6 - Areas/<name>.md`

If the file exists, read the compiled-truth section first. Often that's enough.

### 3. Layer 2 — Grep by keyword

For specific phrases, grep the whole vault:

```
Grep tool: pattern="Alex", path="4 - Meetings/", recent=true
Grep tool: pattern="Q2 launch", path="2 - Live Logs/", recent=true
```

Favor recent files for time-sensitive questions. Read full files only when the filename or a preview snippet looks promising.

### 4. Layer 3 — Follow wiki-links

From the files found in layers 1 and 2, follow `[[wiki links]]` to related files. Read anything that looks load-bearing. Stop when you have enough to answer — don't explore exhaustively.

### 5. Synthesize the answer

Write an answer that:
- States the fact directly
- Cites the specific file(s) and (when possible) the date or section where the fact came from
- Quotes the user's own words when it carries weight
- Acknowledges uncertainty when sources disagree

Example:

> On 2026-04-03 in your last meeting with Alex, you committed to:
> 1. Reviewing the revised timeline by EOW ([[4 - Meetings/2026-04-03 - Alex Q2 check-in]])
> 2. Getting the marketing brief back to the PMM team ([[ACTIONS_LOG]] entry 2026-04-03)
>
> Note: the timeline review is still open in [[ASSISTANT_ACTIONS_LOG]] — marked "awaiting" as of 2026-04-09.

### 6. If the brain doesn't know

Be explicit:

> The brain doesn't have a record of that. I searched [[People/Alex Chen]], [[5 - Projects/Q2 launch]], `4 - Meetings/` back to 2026-03-01, and `ACTIONS_LOG` for the last 30 days. Nothing matched.
>
> Possible reasons:
> - The call happened but wasn't captured (no meeting note landed in `.inbox/meetings/`)
> - It's older than 2026-03-01 and I didn't look that far back — say so if you want me to extend the range
> - It was discussed in a different context (project, person) than the ones I searched

Offer a specific next action.

## Hard rules

- **Never invent a citation.** If you can't point to a specific file + date, don't claim the fact.
- **Never cite `0 - Identity/` files to answer factual questions about events.** Those are self-definition, not episodic memory.
- **Never mix sources and inferences.** If you're inferring, say "I'm inferring this because…"
- **Never answer from Claude's general knowledge** when the question is about the user's own life. "I don't know, the brain doesn't have this" is the correct answer.
- **Always prefer recent over old** when the question is time-sensitive.
- **Always follow at least one wiki-link** from the primary hit before concluding. Context lives in the graph, not in isolated files.

## Answer shape templates

**"What is X's current situation?"** → Read `People/X.md` compiled-truth section, state it, link to the most recent timeline entry.

**"What did I decide about Y?"** → Grep `DECISIONS_LOG.md` + project page for Y. State the decision, the date, and the expected outcome. Flag if the decision is old enough that the expected outcome should have resolved.

**"What have I been working on this week?"** → `git log --since=1.week` on the vault + `ACTIONS_LOG` entries for the period. List by project.

**"Prep me for meeting with Z"** → Same as the briefing workflow's per-meeting context block, but on demand for one person.

**"What did I say about <topic>?"** → Grep `REFLECTIONS_LOG.md` + `LEARNING_LOG.md` + `DECISIONS_LOG.md` for the topic. Quote directly with dates.

## What query does NOT do

- Does not write anything to the vault (pure read)
- Does not call external APIs or do web searches
- Does not guess or pattern-match when sources are missing
- Does not summarize entity pages automatically — it answers the specific question
