# Master plan

The full architecture and phased build plan for the Evolving Brain. Version-controlled so changes are visible in git history.

## The problem this solves

Existing "AI memory" tools (claude-mem, AgentRecall, mem0) remember what an AI agent did across coding sessions. That's agent-session memory. Useful, but not what I'm trying to build.

I want **personal second-brain memory**: a system that ingests raw life data from every app I already use (Heptabase, Apple Notes, voice memos, meetings, Claude mobile chats), synthesizes it into a living wiki of me, lets Claude read it from any surface, and proactively surfaces patterns I'd otherwise miss.

Also: Claude should be able to log its own actions on my behalf, so when I ask "what have you been doing for me?" it can answer.

## Architecture (one-line summary)

Markdown vault in private GitHub → `.inbox/` landing zone → scheduled processor → synthesized Live Logs + entity pages → MCP server exposes the vault to any Claude surface → Obsidian (local) and a Wikipedia-clone site (published) for visualization.

## Why markdown + git and not a database

- Obsidian works out of the box, including the graph view.
- Git gives me free history, diffs, rollback, and version control for the processor's edits.
- Any MCP or Claude surface can read markdown without a driver.
- I keep my data on disk, under my account, in a private repo. No vendor lock-in.
- Processing is stateless — any Claude instance with repo access can run the processor.

## Two memory layers, one store

1. **Life memory** (the user writes, the processor synthesizes): captures from Heptabase, Apple Notes, etc. Flows into `2 - Live Logs/ACTIONS_LOG.md` and entity pages.
2. **Assistant memory** (Claude writes): actions Claude took on the user's behalf. Flows into `2 - Live Logs/ASSISTANT_ACTIONS_LOG.md`.

Both are append-only markdown. Both are readable by any Claude surface via the same MCP tools. No separate database.

## Phases

### Phase 0 — Vault scaffold ✅
Already done. 8-folder PARA structure (Identity, Aspirations, Live Logs, Daily Journal, Meetings, Projects, Areas, Resources) + North Star + Workflows + AGENTS.md. Pushed to private GitHub.

### Phase 1 — Capture contract + onboarding + ops + upstream sync ✅
- `.inbox/` landing zone with a documented contract (`.inbox/README.md`)
- `Onboarding/` folder with question templates (01 identity, 02 aspirations) and guides (03 bulk import, 04 connect sources)
- `9 - Operations/workflows/inbox processing.md` — ongoing processor prompt
- `9 - Operations/workflows/onboarding processing.md` — one-time bulk processor prompt (two modes: bulk-only and full)
- `9 - Operations/workflows/generate wiki.md` — the quick-win static-site generator
- `9 - Operations/` ops layer: `workflows/README.md` registry, `connectors/README.md` registry, `skills/README.md` registry, `schedule.md` calendar view, `runs/` append-only run log
- `Vault/` credentials store: `.env.example` template, `key-inventory.md` catalog, `.env` gitignored
- `.claude/commands/` slash commands: `brain-onboard`, `brain-capture`, `brain-status`, `brain-quick-wiki`, `brain-review`
- `People/` folder for person entity pages
- `2 - Live Logs/ASSISTANT_ACTIONS_LOG.md` for Claude's own actions
- `.gitignore` hardened to block `.env` anywhere in the repo
- Updated `AGENTS.md` with assistant-action rule, capture pipeline awareness, operations layer responsibilities, and credentials rules
- **Upstream sync mechanism** (`9 - Operations/upstream/`) — pinned copies of files from prior-art projects (gbrain, Farzaa's wiki skill, etc.) with a `sync upstream` workflow and `/brain-sync` slash command for checking upstream for updates and surfacing diffs for human review
- **gbrain patterns adopted** — compiled-truth + append-only timeline entity pages, citations/source attribution as a non-negotiable rule, persistent entity IDs that survive renames. See `ATTRIBUTION.md` for the full credit list.
- **New workflows borrowed from gbrain**: `dream cycle.md` (nightly maintenance), `briefing.md` (morning digest), `query.md` (how to read the brain), `maintain.md` (weekly health check), `migrate.md` (universal import), `sync upstream.md`
- **New slash commands**: `/brain-brief`, `/brain-discover` (scans the machine for markdown sources), `/brain-sync`
- **Entity templates upgraded** — `People/`, `5 - Projects/`, `6 - Areas/` all now use the compiled-truth + timeline dossier pattern with persistent IDs

### Phase 2 — Template repo ✅
- Public `Evolving-Brain-Template` repo with the same structure but no personal content
- Onboarding-focused README
- MIT license
- Clear "fork this, run onboarding, done" path

### Phase 3 — First onboarding run (the user)
- Fill out `Onboarding/01` and `02` inline
- Dump existing Heptabase / Apple Notes / Day One exports into `.inbox/onboarding/`
- Run `9 - Operations/workflows/onboarding processing.md` via Claude
- Review the generated `Onboarding/REVIEW REPORT.md`
- Edit generated Identity and Aspirations files
- Push

### Phase 4 — First connector wired end-to-end
- Pick one source (recommendation: meeting notetaker — highest signal)
- Wire it to drop files into `.inbox/meetings/` matching the contract
- Run `9 - Operations/workflows/inbox processing.md` manually to verify the end-to-end path works
- Fix any contract issues before wiring more connectors

### Phase 5 — Scheduled processing
- Move the manual processor run to a scheduled job
- First pick: GitHub Actions on a cron (free, private, simple)
- Alternative: Trigger.dev (MCP already available) if Actions proves too noisy
- Cadence: every 3 hours
- Failure mode: processor opens a GitHub Issue on the repo if it errors

### Phase 6 — MCP server for "Claude reads me from anywhere" (partial ✅ via gbrain)

**Status update 2026-04-10:** We adopted gbrain as the retrieval layer instead of building our own MCP server from scratch. The user already pays for Supabase, which was the main blocker. See `ATTRIBUTION.md` for architecture details.

- `gbrain 0.5.0` installed globally via bun (`bun install -g github:garrytan/gbrain`)
- Vault stays canonical; gbrain indexes into the user's Supabase Postgres + pgvector
- Inbox processor now calls `gbrain sync` at the end of each run (graceful fallback if gbrain isn't initialized)
- gbrain's built-in MCP server handles the "Claude reads me from anywhere" requirement
- Local-only query fallback via grep still works if gbrain is unavailable

**What's still to do for full Phase 6 completion:**
- Run `gbrain init` against the user's actual Supabase Session Pooler URL (blocked on the user providing the right credential type)
- Run `gbrain import` to index the current vault
- Wire gbrain's MCP into Claude Desktop + Claude Code MCP configs
- Test that mobile Claude can query via the gbrain MCP through a relay if needed

**Original Phase 6 plan (kept for reference):**

### Phase 6 (original, superseded by gbrain adoption)
A thin MCP server exposing:
- `search_vault(query)` — semantic + keyword search over all markdown
- `read_entity(path)` — read a specific file
- `append_to_inbox(source, content)` — let Claude on phone drop a capture
- `get_context(topic)` — return the N most relevant files for a topic
- `get_north_star()` — return current metrics and targets
- `list_projects(status)` — return active/paused/archived projects
- `log_assistant_action(entry)` — append to ASSISTANT_ACTIONS_LOG.md

Runs locally for desktop Claude. For mobile Claude, the GitHub connector is the path (Claude reads the repo directly) and `append_to_inbox` goes through a small hosted relay or iOS Shortcut.

### Phase 7 — Visualization layer
Two views of the same data.

**Obsidian (local, private, primary):** open the vault folder in Obsidian. Graph view and backlinks work for free. Daily driver for reading and editing.

**Wikipedia-clone site (published, optional):** inspired by [Farzaa's wiki skill](https://gist.github.com/farzaa/c35ac0cfbeb957788650e36aabea836d). Build a static site that looks like Wikipedia from the markdown vault. Publish to private GitHub Pages or Vercel with basic-auth. Tool candidates: Quartz 4 (Obsidian-native), Astro (custom), or a minimal Next.js app. Must support a `publishable: true` frontmatter flag so sensitive files (SOUL, emotions, decisions) never ship to the site by default.

### Phase 8 — Proactive reviews
- Scheduled weekly review: Claude runs `9 - Operations/workflows/weekly review.md` every Monday morning, commits a draft review note to `8 - North Star/reviews/` for the user to read
- Scheduled monthly + quarterly review: same pattern, longer cadence
- If a North Star metric drifts outside a tolerance, Claude opens a GitHub Issue summoning attention
- If the weekly review surfaces a potential identity shift, flag it in `REFLECTIONS_LOG.md` for human review — never auto-edit Identity

### Phase 9 — Template repo onboarding document
- Write a human-friendly README for the public template that walks someone new through the whole flow
- Include a short screencast or GIF showing the onboarding processor in action
- Add troubleshooting section for common connector issues
- Make it good enough that a friend can fork it on a Saturday and be running by Sunday

---

## What this plan explicitly is NOT

- **Not a database.** No Postgres, no ChromaDB, no pinecone. Markdown only. If semantic search becomes essential later, add embeddings as a build artifact in the MCP server, not as a primary store.
- **Not a real-time sync system.** Cron every 3 hours is enough. Real-time is expensive and noisy.
- **Not a replacement for Heptabase / Apple Notes / whatever.** Capture tools stay. This is synthesis + retrieval on top.
- **Not coupled to Claude Code specifically.** The vault works with any Claude surface (desktop, mobile, code, API). Pick your tool per task.
- **Not a public "build in public" repo.** Private by default. The template repo is the public face.

## Inspiration + prior art

- **[Farzaa's wiki-gen-skill](https://gist.github.com/farzaa/c35ac0cfbeb957788650e36aabea836d)** — the "writer compiling, not filing clerk" philosophy and the Wikipedia-clone visual target.
- **[AgentRecall](https://github.com/Goldentrii/AgentRecall)** — borrowed ideas: capped awareness files, cross-project insight surfacing, MCP as the interface.
- **[claude-mem](https://github.com/thedotmack/claude-mem)** — studied for the hooks + worker pattern, not adopted (wrong problem).
- **PARA method (Tiago Forte)** — the 5-7 top-level folder scheme.
- **Obsidian graph view** — the local visualization that comes for free with the vault format.
