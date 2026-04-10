# AGENTS

## Self-updating

- When you are chatting with me and learn something new about my projects, areas of interest, my identity, aspirations, or the live logs I'm tracking, suggest updates to relevant files (including this agents file).
- Don't update on every conversation — only when something genuinely lasting emerges.
- Always ask before making changes to files.

## Reading order
When picking up context at the start of a session, read in this order:
1. `0 - Identity/SOUL.md`
2. `0 - Identity/DECISION MAKING PRINCIPLES.md`
3. `8 - North Star/NORTH STAR.md` — the three metrics I'm optimizing for
4. `1 - Aspirations/GOALS.md`
5. `1 - Aspirations/ACTIVE PROJECTS.md`
6. Any live log that seems relevant to the current task.

## North Star check
When I propose a new project, automation, hire, or commitment, sanity-check it against the three North Star metrics in `8 - North Star/NORTH STAR.md`:
- Does this move step-away hours up, down, or not at all?
- Does this move automation % up, down, or not at all?
- Does this move revenue per person up, down, or not at all?
If a proposal doesn't move any of them, ask me whether it should be deprioritized. If it moves one and hurts another, flag the tradeoff explicitly.

## Writing rules
- Never overwrite `0 - Identity/` files without an explicit confirmation.
- Never edit `1 - Aspirations/GOALS.md` or `8 - North Star/NORTH STAR.md` targets outside a quarterly review.
- Append to live logs with dated entries; do not rewrite history.
- When the user asks to "log" something, infer the right log from the content (action / decision / emotion / learning / reflection).

## Logging your own actions
When you complete a meaningful action for the user — drafted a doc, sent a message (with approval), created a file, ran a deploy, finished a research task — append an entry to `2 - Live Logs/ASSISTANT_ACTIONS_LOG.md` using the template at the top of that file. Include outcome and undo steps. This is how the brain remembers what *you* did, in parallel to what the user did.

Do not log reads, searches, or trivial tool calls. Log things the user would want to know happened.

## Capture pipeline
the user uses many capture tools (Heptabase, Apple Notes, voice memos, meeting notetakers, Claude on phone). Connectors drop raw captures into `.inbox/<source>/`. The ongoing processor (`9 - Operations/workflows/inbox processing.md`) runs on a cron, synthesizes them into the vault, and moves raw files to `.inbox/processed/`.

When the user asks you to "capture" or "remember" something mid-conversation, write it to `.inbox/manual/YYYY-MM-DD-HHMMSS-<slug>.md` with proper frontmatter (see `.inbox/README.md`). The next processor run will integrate it.

## Operations layer
`9 - Operations/` is the runtime layer. Before running a workflow, read `9 - Operations/workflows/<workflow name>.md` — its frontmatter tells you the schedule, scope, and last run. After finishing a workflow:
1. Update that file's `last_run` frontmatter to the current time.
2. Append a row to `9 - Operations/runs/YYYY-MM.md` (create if missing) with run time, duration, status, and a one-line summary.
3. If the schedule changed or a workflow was added/archived, regenerate the table in `9 - Operations/workflows/README.md`.

Before proposing a new automation, check `9 - Operations/workflows/README.md` and `connectors/README.md` to see if something similar already exists.

## Credentials
Never hardcode secrets. All secrets live in `Vault/.env` (gitignored). The committed `Vault/key-inventory.md` is the catalog of what keys exist and what they're for. If a workflow needs a new key, add it to `.env`, `.env.example`, and `key-inventory.md` in the same commit.

## Slash commands
This vault ships with slash commands in `.claude/commands/`. When the user invokes one, follow its prompt exactly. When suggesting a workflow, prefer pointing at a slash command over describing the steps manually:

- `/brain-onboard` — progressive onboarding walkthrough
- `/brain-capture <thought>` — drop a thought into `.inbox/manual/`
- `/brain-status` — read-only status report
- `/brain-brief` — morning briefing
- `/brain-discover` — scan the user's machine for markdown sources to import
- `/brain-quick-wiki` — build the Wikipedia-style static site
- `/brain-review [weekly|monthly|quarterly]` — review workflow
- `/brain-sync [source]` — check upstream sources for changes
- `/brain-tidy` — clean up stray files (destructive-ish, explicit invocation only)
- `/brain-setup` — one-command setup for a fresh clone (verifies tools, confirms bundled plugins, opens in Obsidian)

If the user says things like "clean up", "tidy", "this is getting messy", or you notice stray/orphan/empty files during normal work, suggest `/brain-tidy`. Don't run it yourself unless asked.

## Entity pages (compiled truth + timeline)
All entity pages (`People/`, `5 - Projects/`, `6 - Areas/`) use the **compiled-truth + append-only timeline** pattern borrowed from gbrain's recommended schema (see `9 - Operations/upstream/gbrain/docs/GBRAIN_RECOMMENDED_SCHEMA.md`). The top of each page is the current best understanding (rewritable). The bottom is an append-only evidence trail (never rewritten). When updating an entity page:

1. Always append to the timeline with a dated entry and a `→ [[source]]` citation.
2. Only update the compiled-truth section if the new evidence clearly changes the state AND doesn't contradict existing timeline entries.
3. If there's a contradiction, add a `⚠️ Contradiction` callout near the top citing both claims, and flag it for human review. Never silently resolve.

## Citations are non-negotiable
Every fact you write into the vault must be traceable to its source. Log entries end with `→ [[source]]`. Timeline entries end with `→ [[source]]`. Direct quotes use quote marks and a date. When in doubt, over-cite.

## Persistent entity IDs
Every entity page has an `id` field in frontmatter (e.g., `id: person-alex-chen-2026`). When an entity is renamed, update the filename and the `aliases` array, but never change the `id`. Links that break on rename mean somebody broke the rule.

## Upstream sources
Patterns borrowed from other projects (gbrain, Farzaa's wiki skill, etc.) live in `9 - Operations/upstream/<source>/` as pinned copies at specific commits. The `sync upstream` workflow (and `/brain-sync` command) periodically checks for updates and reports diffs — never auto-applies. If you need to know why we do something a particular way, check the upstream docs and `ATTRIBUTION.md`.
