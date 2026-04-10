---
description: One-command setup for a fresh clone — verifies tools, confirms bundled Obsidian plugins, creates Vault/.env, opens the vault in Obsidian
---

Run the full setup flow for a brand-new clone of this vault. This is what a new user runs the first time after `git clone`.

## What to do

1. **Run the setup script.** From the vault root, execute `bash scripts/setup.sh`. This handles:
   - Verifying git, curl, Obsidian are installed
   - Checking the bundled plugins are present (`internetvin-terminal`, `agentfiles`, `obsidian-excalidraw-plugin`)
   - Re-downloading any missing plugins from their GitHub releases (via `scripts/install_plugins.sh`)
   - Copying `Vault/.env.example` → `Vault/.env` if it doesn't exist
   - Opening the vault in Obsidian via the `obsidian://` URL scheme

2. **Report what happened.** Print the script's output (at least the checklist) so the user can see what passed and what didn't.

3. **Walk the user through the post-setup Obsidian steps:**
   - Obsidian will prompt "Trust author and enable plugins?" — they click YES
   - The three plugins will activate: Terminal, Agentfiles, Excalidraw
   - If plugins don't show up: Settings → Community plugins → turn off Restricted mode, then enable each

4. **Offer the next move:** once setup is done, they should run `/brain-onboard` (or `/brain-discover` if they want to scan their machine for data first). Do NOT auto-run onboarding — let them choose when.

## If setup fails

- **Obsidian not installed:** link https://obsidian.md and tell them to re-run `/brain-setup` after installing.
- **curl / git missing:** platform-specific instructions (Homebrew on macOS, apt on Debian, etc).
- **Plugin download fails:** check network, re-run `bash scripts/install_plugins.sh` manually. If still failing, tell them to open Obsidian, go to Community plugins, and install the three by hand:
  - Terminal by `internetvin` — the "internetVin Terminal" one
  - Agentfiles by `railly-hugo`
  - Excalidraw by `zsviczian`
- **`Vault/.env` creation fails:** tell them to `cp Vault/.env.example Vault/.env` manually.

## Rules

- **Never** write to `Vault/.env` with real secret values — only copy the template.
- **Never** skip the "Trust author and enable plugins" step in the user-facing explanation. That's the most common source of confusion.
- **Never** open any file in Obsidian beyond the vault root.
- **Don't run the onboarding processor** from this command. Setup and onboarding are separate steps.

## Why the plugins are bundled instead of auto-installed

Obsidian's community plugins are normally installed through its UI, one at a time. For a "clone-and-go" experience, we ship the plugin release files directly in `.obsidian/plugins/` — so the moment the user opens the vault and clicks "Trust author", they get a working setup with no manual plugin hunting.

The plugins we bundle are all MIT licensed and pinned to a specific version. Upgrades happen via `scripts/install_plugins.sh` (edit the version tag, re-run) or via Obsidian's built-in plugin updater once the user has them loaded.
