---
description: Quickly capture a thought, note, or idea into .inbox/manual/ — will be processed on next inbox run
argument-hint: [the thing to capture]
---

The user wants to capture something into the brain without opening any other app. Treat `$ARGUMENTS` as the raw content they want to capture. If `$ARGUMENTS` is empty, ask them what to capture.

## Procedure

1. Generate a timestamped filename: `.inbox/manual/YYYY-MM-DD-HHMMSS-<short-slug>.md` where the slug is 3-5 words inferred from the content.
2. Create the file with proper frontmatter per `.inbox/README.md`:
   ```yaml
   ---
   source: manual
   captured_at: <ISO8601 timestamp>
   type: <best guess: note | reflection | action | learning | decision | reference>
   author: <user's name if known, else "user">
   origin: brain-capture command
   tags: []
   ---
   ```
3. Write the body as-is. Don't clean it up. Don't "improve" it. The whole point of capture is to preserve the raw thought.
4. Confirm to the user: the filename, the path, and that it'll be processed on the next inbox run (or that they can run `/brain-inbox` to process immediately).
5. Do NOT run the processor. Capture is capture. Processing is processing.

## Classification hints

- Starts with "I decided to..." or "we're going with..." → `type: decision`
- Contains feelings, body sensations, mood words → `type: reflection`
- Contains "I learned..." or "turns out..." → `type: learning`
- Contains a task or todo → `type: action`
- A URL + highlight → `type: reference`
- Otherwise → `type: note`

## Rules

- Never refuse a capture because it seems unimportant. Noise is fine — the processor filters.
- Never ask follow-up questions before capturing. Capture first, then ask if they want to enrich.
- Never modify existing captures.
- If the content contains anything that looks like a secret (API key pattern, password), refuse and tell the user why.
