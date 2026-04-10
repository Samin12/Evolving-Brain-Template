# ASSISTANT_ACTIONS_LOG

> Actions Claude took on my behalf. Parallel stream to `ACTIONS_LOG.md` (which is me). When I want to know "what has Claude been doing for me lately," this is the file.

## Rules for Claude

- Append one entry per meaningful action you completed for me. Not every tool call — only the action as I would describe it.
- "Meaningful" = something I would want to know happened, something I might need to undo, something that produced a deliverable.
- Do not log reads or searches. Log writes, sends, creates, deletes, and external calls.
- Always include the outcome, not just the intent.

## Entry template

```markdown
- **Date:** 2026-04-10
- **Action:** Drafted Q2 planning email to [[Evolving Brain Template]] contributors
- **Context:** the user asked for a summary email after the Friday planning call
- **Outcome:** Draft saved to `5 - Projects/Evolving Brain Template/drafts/2026-04-10 q2 email.md` — awaiting approval, not sent
- **Undo:** delete the draft file
- **Related:** [[2026-04-10 planning meeting]]
---
```

## Log
