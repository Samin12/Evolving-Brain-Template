# Attribution

The Evolving Brain borrows ideas, patterns, and sometimes prompt text from several prior-art projects. This file credits them and records exactly what we've adopted. Tracked upstream files live in `9 - Operations/upstream/<source>/` with pinned commit hashes.

## Sources

### garrytan/gbrain

**Repo:** https://github.com/garrytan/gbrain
**License:** MIT — Copyright (c) 2026 Garry Tan
**Upstream doc pins:** `e9f3c9c24d36a8bbef85ea55411cfe3001d342a3` (2026-04-10) in `9 - Operations/upstream/gbrain/`
**Runtime install:** `gbrain 0.5.0` installed via `bun install -g github:garrytan/gbrain` (commit `27eb87f`, 2026-04-10)

**We now run gbrain as our retrieval layer** (not just track its docs). The architecture:

- **Vault (this repo)** is the canonical source of truth. Every markdown file, every entity page, every log entry lives in git.
- **gbrain** indexes the vault into Postgres + pgvector via the user's own Supabase project. Provides hybrid keyword + vector search, link graph traversal, and an MCP server.
- **Sync direction** is vault → gbrain. Writes go to markdown files; `gbrain sync` is called at the end of the inbox processor workflow to push new/changed files into the index. We never write to gbrain as the primary path.
- **If gbrain disappears**, the vault still works — retrieval falls back to grep via the `query` workflow. No data is lost, just some retrieval speed / semantic capability.

**What we borrowed (in addition to running the tool):**
- The "compiled truth on top, append-only timeline on bottom" entity page pattern (adopted in `People/`, `5 - Projects/`, `6 - Areas/` templates)
- The "dream cycle" nightly maintenance concept (adopted as `9 - Operations/workflows/dream cycle.md`)
- The shape of the skillpack — fat markdown prompts describing HOW an agent uses the brain — validated our `9 - Operations/workflows/` approach
- The recommended entity schema: persistent IDs, source attribution, citations (adopted in inbox processor rules and entity templates)
- The `query`, `maintain`, `briefing`, `migrate` workflow patterns (adopted as workflows with our own adaptations)
- The SQLite engine design as the planned upgrade path for Phase 6 search

**What we explicitly did NOT borrow:**
- gbrain's runtime code (TypeScript CLI, MCP server)
- The Postgres + pgvector dependency (explicit design choice to stay markdown-only until scale demands otherwise)
- The OpenClaw/Hermes agent framework coupling
- The hardcoded person/company/deal/idea entity types (we use PARA + organic emergence)

### farzaa's wiki-gen-skill

**Source:** https://gist.github.com/farzaa/c35ac0cfbeb957788650e36aabea836d
**License:** Unspecified gist; we treat it as "borrowed with credit"
**Tracked:** No pinned copy (it's a gist, not a repo — we reference it by link)

**What we borrowed:**
- The philosophy: "You are a writer compiling, not a filing clerk. The question is never 'where do I put this fact?' It is: 'what does this mean, and how does it connect to what you already know?'" — quoted directly in our inbox processing workflow and the `Onboarding/README.md`
- The Wikipedia-style visual target for `9 - Operations/workflows/generate wiki.md`
- The organic directory emergence idea — we bent it slightly to fit PARA, but the spirit is there
- The `/wiki` command pattern — validated our slash-command-as-entry-point approach

### Tiago Forte's PARA method

**Source:** Tiago Forte, "Building a Second Brain" (the book and various articles)
**License:** Ideas, not code — public methodology

**What we borrowed:**
- The PARA naming and structure: Projects, Areas, Resources, Archive
- The principle that everything is either actionable or reference material
- The archive-over-delete convention

### Obsidian

**Source:** https://obsidian.md
**License:** We use it, we don't copy from it

Obsidian is the daily driver for reading and editing the vault. We depend on its file format (markdown + YAML frontmatter + `[[wikilinks]]`) as a convention, but we're not bound to it — any text editor works.

## Bundled Obsidian plugins

The vault ships with three community plugins pre-downloaded and enabled (`.obsidian/plugins/`), so a fresh clone + `bash scripts/setup.sh` gives the user a working environment without hunting through the plugin store. All three are MIT-licensed and redistributed with credit per the MIT terms.

### internetVin Terminal

**Repo:** https://github.com/internetvin/internetvin-terminal
**Plugin ID:** `internetvin-terminal`
**Pinned version:** 1.1.2
**License:** MIT — Copyright (c) 2025 Vin Verma
**What it does:** Embedded terminal for Obsidian with multi-tab support. Lets you run shell commands without leaving Obsidian.

### Agentfiles

**Repo:** https://github.com/railly/agentfiles
**Plugin ID:** `agentfiles`
**Pinned version:** 0.7.2
**License:** MIT — Copyright (c) 2026 Railly Hugo
**What it does:** Browse, create, and edit AI agent files across Claude Code, Cursor, Codex, Windsurf, and 13+ other tools — from inside Obsidian. Pairs well with our `.claude/commands/` and `9 - Operations/workflows/` folders.

### Excalidraw (obsidian-excalidraw-plugin)

**Repo:** https://github.com/zsviczian/obsidian-excalidraw-plugin
**Plugin ID:** `obsidian-excalidraw-plugin`
**Pinned version:** 2.22.0
**License:** MIT — Copyright Zsolt Viczián
**What it does:** Sketch drawings, diagrams, and hand-drawn mind maps inside Obsidian. The "4D Visual PKM" tool.

### skillkit (CLI companion for Agentfiles)

**Repo:** https://github.com/crafter-station/skill-kit
**npm package:** `@crafter/skillkit`
**License:** MIT — same authors as Agentfiles (raillyhugo_, jibaru, cris-fast at crafter-station)
**What it does:** Local-first analytics for AI agent skills. Tracks usage, measures context budget, highlights burn rate, prunes what you don't use. Powers the dashboard view inside the Agentfiles Obsidian plugin.
**How we install it:** `scripts/setup.sh` runs `npm i -g @crafter/skillkit && skillkit scan` automatically during setup. Not bundled in the vault because it's a system-wide CLI, not a file-in-folder plugin. If npm isn't installed, the setup script prints the manual install command and continues — skillkit is required only for the Agentfiles dashboard view, not for the core vault.

## Updating bundled plugins

To bump a plugin version:
1. Edit the tag in `scripts/install_plugins.sh` (the `PLUGINS` array)
2. Run `bash scripts/install_plugins.sh`
3. Verify the new files work in Obsidian
4. Update the pinned version in this file
5. Commit `.obsidian/plugins/<plugin>/` and `ATTRIBUTION.md` in one commit

## Rules for adding new sources

When borrowing from a new source:

1. Read the source's license. Respect it. If it's not permissive (MIT, Apache, BSD, CC-0, public domain), think hard before copying verbatim text.
2. Add a new folder under `9 - Operations/upstream/<source>/` with a `README.md` explaining why and an `UPSTREAM.md` manifest listing tracked files with commit hashes.
3. Add a section to this `ATTRIBUTION.md` with the same fields as above.
4. Update `9 - Operations/upstream/README.md`'s source table.
5. If you're adopting ideas but not copying files verbatim, still add the source here — attribution is about credit, not legal obligation.

## Philosophy

Crediting prior art is not optional. We borrow from people who did good work. We say so. We make it easy for the next person to find the original source and go deeper. When we improve on a borrowed pattern, the improvement gets attributed back to the source that made it possible.
