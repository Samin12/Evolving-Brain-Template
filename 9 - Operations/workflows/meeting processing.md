---
status: active
schedule: on-capture      # triggered by inbox processing, not on a timer
scope: global
last_run: null
owner: claude
---

# Meeting processing

Run this after a meeting file lands in `4 - Meetings/`.

## Steps
1. Summarize the meeting in 3-5 bullets at the top of the file.
2. Pull out commitments made by me → `ACTIONS_LOG.md`.
3. Pull out decisions → `DECISIONS_LOG.md`.
4. Pull out anything learned about the other person, org, or domain → `LEARNING_LOG.md`.
5. Link the meeting file to any relevant project in `5 - Projects/` or area in `6 - Areas/`.
