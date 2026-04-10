---
status: active
schedule: manual
scope: global
last_run: null
owner: claude
---

# Journal processing

Run this when you want to turn raw daily journal entries into structured signal.

## Inputs
- Recent files in `3 - Daily Journal/`

## Steps
1. Read the last N days of journal entries.
2. Extract new actions → append to `2 - Live Logs/ACTIONS_LOG.md`.
3. Extract decisions (with context and expected outcome) → `DECISIONS_LOG.md`.
4. Extract emotional beats and triggers → `EMOTIONS_LOG.md`.
5. Extract anything learned → `LEARNING_LOG.md`.
6. Extract longer reflections → `REFLECTIONS_LOG.md`.
7. Flag anything that looks like a shift in identity, goals, or habits for human review — do not auto-update Identity or Aspirations.
