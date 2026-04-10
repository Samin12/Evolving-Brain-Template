# Vault

The credentials store for the brain. Secrets live in `Vault/.env` (gitignored). A human-readable catalog lives in `Vault/key-inventory.md` (committed, no values).

## Philosophy

- **One big bolt.** All secrets the brain uses live in one place. Workflows, connectors, and scripts load from here, not from scattered `.env` files.
- **Committed catalog, gitignored values.** The *names* of your keys and what they're for are documented and version-controlled. The *values* are not.
- **Per-project filtering at runtime.** A project doesn't get every secret — it declares which keys it needs, and the runtime loads that subset. Declaration is in the project's own folder, not here.
- **No hardcoding.** Workflows reference secrets by name (e.g. `OPENAI_API_KEY`), never inline.

## Files

| File | Committed? | Purpose |
|---|---|---|
| `README.md` | yes | This file. |
| `.env.example` | yes | Template showing the shape of `.env`. Safe to commit — no values. |
| `.env` | **NO** | The real values. Gitignored. Lives only on your machine and trusted runtime environments. |
| `key-inventory.md` | yes | Human-readable catalog: what keys exist, what they're for, which projects use them. No values. |

## Setting up `Vault/.env` for the first time

1. Copy the template: `cp Vault/.env.example Vault/.env`
2. Fill in the real values.
3. Confirm it's gitignored: `git check-ignore Vault/.env` should print the path.
4. Never `git add Vault/.env` — if you ever see it in `git status`, stop and fix `.gitignore` before doing anything else.

## Loading secrets in a workflow

When a workflow or connector needs a secret:

1. Check `Vault/key-inventory.md` to confirm the key exists and is for this purpose.
2. Load from the environment (the runtime should `source Vault/.env` before invoking the workflow).
3. Reference the key by name in code.
4. If the key doesn't exist yet, add it to `.env`, `.env.example`, and `key-inventory.md` in the same commit.

## Project-specific keys

If a project needs a unique key that isn't shared:

- Still store the value in the central `Vault/.env`.
- In `key-inventory.md`, mark the key's `projects:` field with the project name(s).
- The project's own `5 - Projects/<project>/README.md` can list which keys it declares a dependency on.

## Deleting a key

1. Remove the line from `.env` and `.env.example`.
2. Remove the row from `key-inventory.md`.
3. Grep the vault for any remaining references to the key name and clean them up.
4. Rotate the key at the source (GitHub, OpenAI, etc.) since it may have been exposed.

## What NOT to put here

- **Not personal journal entries.** Those go in `2 - Live Logs/` or `3 - Daily Journal/`.
- **Not API documentation.** Those go in `7 - Resources/`.
- **Not architecture docs.** Those go in the project folder or `MASTER PLAN.md`.

This folder is strictly credentials.
