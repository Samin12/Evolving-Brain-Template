# Skills registry

Capabilities the brain expects to have available. Two kinds:

1. **Obsidian plugins** — bundled with the vault in `.obsidian/plugins/` and enabled via `.obsidian/community-plugins.json`. Installed automatically when a new user runs `bash scripts/setup.sh` (or `/brain-setup` in Claude Code).
2. **Claude skills** — installed at the Claude Code level (`~/.claude/skills/`), not in the vault. This registry tracks which ones this brain benefits from so you know what to install on a new machine.

## Bundled Obsidian plugins (Active)

| Plugin | What it does | Version | Source | Required |
|---|---|---|---|---|
| `internetvin-terminal` | Embedded terminal with multi-tab support inside Obsidian | 1.1.2 | [internetvin/internetvin-terminal](https://github.com/internetvin/internetvin-terminal) | yes |
| `agentfiles` | Browse / edit AI agent files (Claude Code, Cursor, Codex, Windsurf, …) from Obsidian. Dashboard view requires skillkit (auto-installed by `setup.sh`). | 0.7.2 | [railly/agentfiles](https://github.com/railly/agentfiles) | yes |
| `obsidian-excalidraw-plugin` | Sketch drawings, diagrams, hand-drawn mind maps | 2.22.0 | [zsviczian/obsidian-excalidraw-plugin](https://github.com/zsviczian/obsidian-excalidraw-plugin) | yes |

All three are MIT-licensed and redistributed with credit per `ATTRIBUTION.md`.

See `scripts/install_plugins.sh` for how to update them. See `scripts/setup.sh` for how a new user gets them working.

## Suggested (not bundled) Obsidian plugins

You can install these via Obsidian's community plugin browser when you want them. Not required.

| Plugin | Why | Install via |
|---|---|---|
| Dataview | Query the vault like a database — once you have >10 entity pages with frontmatter, Dataview becomes the read layer on top | Community plugins browser |
| Templater | Executing templates with date math, frontmatter injection, and scripting | Community plugins browser |
| Git (by Vinzent) | Commit, push, and pull from inside Obsidian instead of the terminal | Community plugins browser |

## CLI companions (Active)

Tools installed globally via package managers, separate from Obsidian and Claude Code.

| Tool | What it does | Install | Required | Source |
|---|---|---|---|---|
| `gbrain` | Semantic retrieval layer for the vault. Indexes markdown into Postgres + pgvector (via Supabase). Provides hybrid keyword + vector search, link graph traversal, and an MCP server so Claude can query the brain from any surface. | `bun install -g github:garrytan/gbrain` + `gbrain init --url "$SUPABASE_POOLER_URL"` — both handled by `scripts/setup.sh` step 5 | yes (required for semantic search; vault works without it via grep fallback) | [garrytan/gbrain](https://github.com/garrytan/gbrain) |
| `@crafter/skillkit` | Local-first analytics for AI agent skills (usage, burn rate, context budget, prune unused). Powers the Agentfiles dashboard. | `npm i -g @crafter/skillkit && skillkit scan` — handled by `scripts/setup.sh` step 4 | yes (for the Agentfiles dashboard view) | [crafter-station/skill-kit](https://github.com/crafter-station/skill-kit) |

## Claude Code skills (Active)

| Skill | What it does | Required | Source |
|---|---|---|---|
| _None yet_ | | | |

## Paused

_None._

## Archived

_None._

---

## How to add a new bundled plugin

1. Find the GitHub repo and the latest release tag.
2. Confirm the license permits redistribution (MIT, Apache 2.0, BSD, etc. — avoid GPL without thought).
3. Add a new line to `scripts/install_plugins.sh` in the `PLUGINS` array: `"plugin-id|owner/repo|version-tag"`.
4. Run `bash scripts/install_plugins.sh` to fetch the release assets.
5. Add the plugin ID to `.obsidian/community-plugins.json`.
6. Add a row to the Bundled table above.
7. Add an entry to `ATTRIBUTION.md`.
8. Commit `.obsidian/plugins/<new-plugin>/`, the three registry updates, and the attribution change in a single commit.

## Why the skills registry matters

When a user clones this vault on a new machine, the registry is their checklist. Claude reads the registry on first load and knows: "this vault expects Terminal, Agentfiles, and Excalidraw to be active, plus these optional plugins." If any are missing, Claude can suggest reinstalling. The registry is documentation, truth source for setup scripts, and a sanity check rolled into one.
