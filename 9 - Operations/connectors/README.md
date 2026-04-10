# Connectors registry

Every connector that feeds `.inbox/` or talks to an external system on behalf of the brain. MCPs, API pollers, watch folders, iOS Shortcuts — all of it goes here.

A connector is "wired" when: it exists, it's authenticated, and it's either running on a schedule or on demand without manual intervention.

## Active

| Connector | Type | Source | Target | Schedule | Scope | Credentials | File |
|---|---|---|---|---|---|---|---|
| _None yet_ | | | | | | | |

## Paused

_None._

## Archived

_None._

---

## What counts as a connector

- **MCP server** — a Model Context Protocol server exposing tools Claude can call (e.g. GitHub MCP, Linear MCP, Heptabase MCP if it exists).
- **API poller** — a script or service that calls a REST/GraphQL API on a schedule and drops results into `.inbox/<source>/`.
- **Watch folder** — an OS-level mechanism (launchd, Hazel, inotify) that moves/copies files from somewhere on disk into `.inbox/<source>/`.
- **iOS Shortcut** — an Apple Shortcut that captures something (voice memo, share sheet, dictation) and commits it to `.inbox/` via the GitHub API.
- **Email rule** — a Gmail filter + forward + IMAP-to-file script that lands tagged emails in `.inbox/email/`.

## Adding a new connector

1. Wire it up externally (install the MCP, write the script, configure the shortcut, etc.).
2. Add a file: `9 - Operations/connectors/<name>.md` describing:
   - What it does
   - Where it runs (local machine, GitHub Actions, hosted)
   - What secrets it needs (referenced by name from `Vault/key-inventory.md`, never values)
   - What it writes to `.inbox/<source>/`
   - How to disable it
3. Add a row to the Active table above.
4. Do a test capture end-to-end and confirm the file lands, the processor picks it up, and the vault updates.

## Per-project connectors

A connector can be project-scoped. Example: a GitHub MCP wired specifically to the `evolving-brain` repo so Claude only sees issues/PRs for that project when working in it. In that case:

- `scope` field in the connector file is the project name, not `global`
- The connector file lives at `5 - Projects/<project>/connectors/<name>.md` (mirror structure)
- It still gets a row in the Active table here with the project name in the Scope column

## Credentials

Connectors never hard-code secrets. Every credential a connector needs is listed in `Vault/key-inventory.md` by name and loaded from `Vault/.env` (gitignored) or the OS keychain at runtime. If you're about to paste a token into a connector file, stop.
