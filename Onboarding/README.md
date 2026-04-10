# Onboarding

Everything a brand-new brain needs to go from empty vault to "Claude knows me." This folder is docs + question templates. It is not where your data lives — data lives in the PARA folders (`0 - Identity/`, `1 - Aspirations/`, `2 - Live Logs/`, etc.) after processing.

Run through these files in order. Budget: 2-4 hours for the human parts, then let the processor do the rest.

## Order of operations

1. **`01 - identity questions.md`** — answer inline. ~30 min. These seed `0 - Identity/`.
2. **`02 - aspirations questions.md`** — answer inline. ~30 min. These seed `1 - Aspirations/` including your North Star baselines.
3. **`03 - bulk import guide.md`** — dump your existing notes (Heptabase, Apple Notes, Day One, Obsidian, etc.) into `.inbox/onboarding/`. ~1-2 hours depending on how much you have.
4. **`04 - connect your sources.md`** — wire up the connectors / MCPs that will feed `.inbox/` going forward. One-time setup per source.
5. **Run the onboarding processor** — `9 - Operations/workflows/onboarding processing.md`. Claude reads your answers and the bulk dump, generates first-draft Identity + Aspirations files, creates entity pages for people and projects it finds, and appends to Live Logs. You review, edit, approve.
6. **Run the ongoing processor on a cron** — `9 - Operations/workflows/inbox processing.md`. From here, the brain grows on its own as new captures arrive.

## Philosophy

Borrowed from [Farzaa's wiki skill](https://gist.github.com/farzaa/c35ac0cfbeb957788650e36aabea836d):

> You are a writer compiling, not a filing clerk. The question is never "where do I put this fact?" It is: "what does this mean, and how does it connect to what I already know?"

The processor should synthesize, not file. A journal entry about frustration at work isn't just logged to `EMOTIONS_LOG.md` — it's connected to the project that caused it, the person involved, and any pattern it reinforces. Over time, entity pages get richer, logs get denser, and the graph of links between them becomes the real brain.

## What NOT to do during onboarding

- **Do not** answer the identity questions by writing what you think you should be. Write what's actually true, even if it's messy. The processor will clean up the prose; it can't fix a dishonest starting point.
- **Do not** try to dump everything you've ever written. Dump what's from the last 12-24 months. Older stuff can go in a separate pass later if it turns out to matter.
- **Do not** pre-sort the bulk dump into PARA folders yourself. That's what the processor is for. If you hand-sort, you'll anchor the processor to your existing mental model and waste the one chance for a fresh synthesis.
