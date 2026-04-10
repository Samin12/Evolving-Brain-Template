# Evolving Brain — Template

A template for building your own AI-native second brain / Life OS. Fork it, make your fork private, run the setup, and let it grow.

> This is the **public template**. Do not fill in your actual identity, goals, or journal entries here. Fork it first, go private, then onboard.

## One-command setup (after you fork and clone)

```bash
git clone https://github.com/<your-username>/<your-fork>.git evolving-brain
cd evolving-brain
bash scripts/setup.sh
```

That script verifies your tools, checks the bundled Obsidian plugins, creates `Vault/.env` from the template, and opens the vault in Obsidian. When Obsidian prompts "Trust author and enable plugins?", click YES.

You get three plugins pre-installed and enabled:
- **internetVin Terminal** — embedded terminal in Obsidian
- **Agentfiles** — browse and edit AI agent skill / command files from inside Obsidian
- **Excalidraw** — sketch diagrams and hand-drawn mind maps

All three are MIT-licensed and bundled directly in `.obsidian/plugins/` so a clone gives you a working environment with zero plugin hunting.

Then, inside Claude Code, run `/brain-onboard` (or `/brain-discover` to scan your machine for markdown sources first).

## What this is

A markdown vault designed to be the source of truth for a personal AI assistant that actually remembers you. Capture tools (Heptabase, Apple Notes, voice memos, meeting notetakers, Claude on your phone) drop raw content into an `.inbox/`. A processor runs on a schedule, synthesizes it into living logs and entity pages, and commits back. A nightly dream cycle enriches entities, fixes broken links, and surfaces contradictions while you sleep. Any Claude surface can read the vault via a thin MCP server.

The core insights:

> You are a writer compiling, not a filing clerk. The question is never "where do I put this fact?" It is: "what does this mean, and how does it connect to what you already know?"
> — [Farzaa's wiki-gen-skill](https://gist.github.com/farzaa/c35ac0cfbeb957788650e36aabea836d)

> Every page is a dossier. Compiled truth on top (your current best understanding, rewritten when evidence changes). Append-only timeline on the bottom (the evidence trail that never gets edited).
> — Inspired by [garrytan/gbrain](https://github.com/garrytan/gbrain)

See `ATTRIBUTION.md` for the full credit list.

## The three-folder core

- `0 - Identity` — **who you are** (core, stable, changes rarely)
- `1 - Aspirations` — **who you are becoming** (goals, habits, projects, open problems)
- `2 - Live Logs` — **the raw signal of your life** (actions, decisions, emotions, learning, reflections, plus Claude's own action log)

Everything else (`3 - Daily Journal` through `9 - Operations`, `People`, `Onboarding`, `Vault`, `Archive`, `scripts`) is scaffolding that feeds into or operates on the three core folders above.

## How to use this template (step by step)

### 1. Fork + go private

```bash
gh repo fork <this-repo> --clone=false
gh repo edit <your-username>/<your-fork> --visibility private
gh repo clone <your-username>/<your-fork>
cd <your-fork>
```

Do not skip the private step. The moment you fill in `SOUL.md`, this becomes the most personal data you own.

### 2. Run one-command setup

```bash
bash scripts/setup.sh
```

See the top of this README for what it does.

### 3. Run the onboarding slash command in Claude Code

`/brain-onboard` walks you through:

1. **Discover data sources** — optionally run `/brain-discover` first to scan your machine for markdown-heavy folders.
2. **Dump data** — drop exports from your existing tools into `.inbox/onboarding/<source>/`.
3. **Generate the wiki** — `/brain-quick-wiki` builds a Wikipedia-style static site.
4. **Answer identity questions** — fill in `Onboarding/01` and `02` when you're ready.
5. **Wire a connector** — pick one source (recommend: meeting notetaker).
6. **Schedule the processor** — GitHub Actions on a cron is the simplest path.

### 4. Daily use

- Capture on the fly: `/brain-capture "the thing I want to remember"`
- Morning briefing: `/brain-brief`
- Check state: `/brain-status`
- Weekly review: `/brain-review weekly`
- Regenerate wiki: `/brain-quick-wiki`
- Clean up stray files: `/brain-tidy`
- Check upstream sources: `/brain-sync`

## Runtime visibility (`9 - Operations/`)

One of the things this template gets right that other "AI second brain" setups miss: a single place to see what's running.

- `9 - Operations/workflows/README.md` — registry of every workflow, status, schedule, scope, last run.
- `9 - Operations/connectors/README.md` — every MCP / poller / watch folder feeding `.inbox/`.
- `9 - Operations/skills/README.md` — bundled Obsidian plugins + Claude skills the vault depends on.
- `9 - Operations/schedule.md` — calendar-style view.
- `9 - Operations/runs/` — append-only run log per month.
- `9 - Operations/upstream/` — pinned copies of files from prior-art projects (gbrain, etc.) with a `/brain-sync` mechanism for pulling in upstream improvements.

## Credentials (`Vault/`)

- `Vault/.env` — the big bolt. Gitignored.
- `Vault/.env.example` — committed template.
- `Vault/key-inventory.md` — human-readable catalog. No values.

Workflows never hardcode secrets.

## Entity pages (the dossier pattern)

Every `People/`, `5 - Projects/`, `6 - Areas/` page follows the **compiled-truth + append-only timeline** structure borrowed from gbrain's recommended schema. Top is current best understanding (rewritable). Bottom is append-only evidence trail (never rewritten). When new evidence contradicts the top, the processor flags it — it never silently resolves. Human always decides.

## Folder map

| Folder | Purpose |
|---|---|
| `0 - Identity` | SOUL, decision-making principles, intellectual blueprint |
| `1 - Aspirations` | 12 favorite problems, active projects, goals, habits |
| `2 - Live Logs` | Actions, decisions, emotions, learning, reflections, + Claude's own action log |
| `3 - Daily Journal` | Raw daily entries |
| `4 - Meetings` | Meeting notes |
| `5 - Projects` | PARA projects (defined outcome, end date) |
| `6 - Areas` | PARA areas (ongoing responsibilities) |
| `7 - Resources` | PARA resources (reference material by topic) |
| `8 - North Star` | The leverage metrics you're optimizing for, tracked weekly |
| `9 - Operations` | Runtime layer — workflows, connectors, skills, schedule, run history, pinned upstream sources |
| `People` | One page per person who matters |
| `Onboarding` | One-time setup questions and bulk-import guide |
| `Vault` | Central credentials store |
| `.inbox` | Landing zone for raw captures (not canonical) |
| `.obsidian/plugins` | Bundled Obsidian plugins (terminal, agentfiles, excalidraw) |
| `.claude/commands` | Slash commands — `/brain-setup`, `/brain-onboard`, `/brain-capture`, `/brain-status`, `/brain-brief`, `/brain-discover`, `/brain-quick-wiki`, `/brain-review`, `/brain-sync`, `/brain-tidy` |
| `scripts` | `setup.sh`, `install_plugins.sh`, and other shell helpers |
| `Archive` | Anything no longer active |
| `AGENTS.md` | Instructions for AI agents working in this vault |
| `Coaching philosophy.md` | Your operating philosophy for growth and change |
| `MASTER PLAN.md` | Full architecture and phased build plan |
| `ATTRIBUTION.md` | Credits to prior art |

## Status

This template ships with Phases 0 and 1 complete. Phases 2-9 are your job after forking. See `MASTER PLAN.md` for the full build plan.

## License

MIT. See `LICENSE`.
