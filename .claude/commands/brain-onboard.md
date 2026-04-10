---
description: Run the Evolving Brain onboarding flow — dump data, generate the wiki, answer questions, wire connectors
---

You are running the Evolving Brain onboarding flow for the user. Your goal is to get them from "fresh clone" to "working brain with a visualizable wiki" in the shortest path, then progressively level up.

## Principles

- **Quick win first.** The single most motivating thing is seeing their own data in a wiki. Do that before asking the harder questions.
- **Progressive difficulty.** Dump data → generate wiki → answer identity questions → wire first connector → schedule processor. Never jump ahead.
- **Always check their work before moving on.** If they say "done", verify it's actually done before invoking a processor.
- **Be honest about what's hard.** Wiring connectors is the hardest step. Don't sell it as easy.

## Step 0 — Detect state

Read these files to figure out where the user is:

- `Onboarding/01 - identity questions.md` — are any `>` prompts filled in?
- `Onboarding/02 - aspirations questions.md` — same check
- `.inbox/onboarding/` — are there any files under it?
- `0 - Identity/SOUL.md` — does it still have the template `##` sections unfilled?
- `site/` — has the wiki been generated before?
- `9 - Operations/connectors/README.md` — any active connectors?

Based on what you find, pick the right next step. Don't re-run steps that are already done.

## Step 1 — Dump initial data (the quickest quick win)

Goal: get raw data into `.inbox/onboarding/` so we have something to visualize.

Ask the user which of these they have ready to hand over:

- iMessage / SMS export (Mac: there are tools like iMessageExporter)
- Email export (Gmail Takeout, Apple Mail export)
- ChatGPT conversation history (Settings → Data controls → Export data)
- Claude conversation history (Settings → Account → Export data)
- Apple Notes (export as markdown via Exporter, Bear import, or AppleScript)
- Obsidian vault (copy the folder)
- Day One journal (JSON or plain-text export)
- Heptabase (export whiteboard as markdown)
- Voice memos (transcribe with Whisper or macOS dictation first)
- Bookmarks / read-later (Raindrop, Readwise, Pocket export)
- Anything else they type directly into a file

For each source they name:

1. Create `.inbox/onboarding/<source-name>/` if it doesn't exist.
2. Tell them the exact folder path to drop files into.
3. Give them source-specific export tips if the guide in `Onboarding/03 - bulk import guide.md` has them.
4. Wait for confirmation that they've dumped the files.
5. Verify the files are actually there before moving on.

**Be generous with this step.** Encourage them to dump everything they're comfortable with. If they're unsure about something, lean toward including it — the processor can handle noise.

Once they've dumped everything they want in this round, proceed to Step 2.

## Step 2 — Run the bulk-only onboarding processor

Run the workflow at `9 - Operations/workflows/onboarding processing.md` in `bulk-only` mode. This skips Identity/Aspirations generation and just processes the bulk dump into Live Logs and entity pages.

When it finishes:

1. Read `Onboarding/REVIEW REPORT.md` it produced.
2. Tell the user how many entity pages, log entries, and person pages were created.
3. Show them a sample of 3-5 interesting entity pages the processor produced — pick ones that have rich content, not stubs.
4. Flag anything in the review report they should look at.

## Step 3 — Generate the wiki (the actual quick win)

Run `9 - Operations/workflows/generate wiki.md` to build the static site.

When it finishes:

1. Tell them the path to `site/index.html`.
2. Open it if you can (or give them a command to open it).
3. Point out 2-3 pages worth clicking through first.
4. Remind them the first render is bare-bones — they can ask for polish (infoboxes, search, swap to Quartz) later.

**This is the moment to celebrate.** They went from empty vault to a clickable wiki of their own thinking in under an hour. Acknowledge it.

## Step 4 — Offer the next move

Ask the user which they want to do next:

- **Level up the wiki** — make it prettier, add search, add a graph view, swap to Quartz 4
- **Answer identity questions** — fill in `Onboarding/01` and `02` so the processor can generate first-draft Identity and Aspirations files
- **Wire the first connector** — pick one source (recommend: meeting notetaker) and wire it to drop files into `.inbox/<source>/` automatically going forward
- **Schedule the processor** — turn on the cron so the brain starts updating itself

Whatever they pick, that becomes your next focus. Don't try to do all of them in one session.

## Step 5 — If they picked identity questions

Walk them through `Onboarding/01 - identity questions.md` and `02 - aspirations questions.md`. Options:

- **Conversational mode** — you ask the questions in chat, they answer, you write their answers into the file. Best for people who don't want to open a text editor.
- **File mode** — they open the files and fill them in themselves. Best for thoughtful, deliberate writers.

Let them pick. After they're done, re-run `onboarding processing.md` in `full` mode (it will detect the answers are present and upgrade from bulk-only).

## Step 6 — If they picked wiring a connector

Open `Onboarding/04 - connect your sources.md` and walk through one source end-to-end:

1. Pick the source (recommend: meeting notetaker)
2. Figure out how it exports (native markdown export? API? webhook?)
3. Design the connector — which option from the menu (MCP, watch folder, API poller, shortcut)
4. Wire it up step by step
5. Trigger a test capture
6. Verify the file lands in `.inbox/<source>/`
7. Run `9 - Operations/workflows/inbox processing.md` manually
8. Verify the vault updated
9. Add a row to `9 - Operations/connectors/README.md`

## Step 7 — If they picked scheduling

Walk through setting up GitHub Actions (or Trigger.dev, or launchd) to run the inbox processor on a cron. The workflow prompt at `9 - Operations/workflows/inbox processing.md` is the source of truth — the scheduler just needs to run Claude with that prompt on schedule.

After it's scheduled, confirm the first scheduled run worked by checking `9 - Operations/runs/YYYY-MM.md` for a new entry.

## Hard rules

- Never write to `0 - Identity/` files unless the user explicitly chose the "full onboarding" path and answered the identity questions.
- Never commit values to `Vault/.env`. Ever.
- Never publish the wiki to a public location without explicit confirmation AND a check that sensitive files are excluded.
- Never skip the review step for a processor run — always read the review report before celebrating.
- If the user seems overwhelmed, stop. Acknowledge it, point at what they've already done, and suggest resuming later.
