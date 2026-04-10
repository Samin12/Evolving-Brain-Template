#!/usr/bin/env bash
# Evolving Brain — setup script
#
# Run from the vault root after cloning:
#
#   ./scripts/setup.sh
#
# Or paste this one-liner in Claude Code / any terminal:
#
#   bash scripts/setup.sh
#
# What it does:
#   1. Checks required tools are installed (git, curl, Obsidian on macOS)
#   2. Verifies the bundled Obsidian plugins are present
#   3. Copies Vault/.env.example → Vault/.env if missing
#   4. Opens the vault in Obsidian
#   5. Prints the "Trust author and enable plugins" step the user must click once

set -euo pipefail

VAULT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$VAULT_ROOT"

echo "=== Evolving Brain setup ==="
echo "Vault: $VAULT_ROOT"
echo ""

# ---------- 1. Tool checks ----------
check_tool() {
  local tool=$1
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "  ✗ $tool not found — please install it and re-run"
    return 1
  else
    echo "  ✓ $tool"
  fi
}

echo "1. Checking required tools..."
check_tool git
check_tool curl

# Obsidian check (macOS-specific; Linux/Windows users should verify manually)
if [[ "$(uname)" == "Darwin" ]]; then
  if [[ -d "/Applications/Obsidian.app" ]]; then
    echo "  ✓ Obsidian (macOS)"
  else
    echo "  ⚠ Obsidian.app not found in /Applications/"
    echo "    Download from https://obsidian.md — then re-run setup"
    exit 1
  fi
else
  echo "  ⚠ Non-macOS detected. Make sure Obsidian is installed: https://obsidian.md"
fi

echo ""

# ---------- 2. Plugin check ----------
echo "2. Verifying bundled plugins..."
REQUIRED_PLUGINS=(
  "internetvin-terminal"
  "agentfiles"
  "obsidian-excalidraw-plugin"
)

MISSING_PLUGINS=0
for plugin in "${REQUIRED_PLUGINS[@]}"; do
  if [[ -f ".obsidian/plugins/$plugin/main.js" && -f ".obsidian/plugins/$plugin/manifest.json" ]]; then
    VERSION=$(grep -o '"version": "[^"]*"' ".obsidian/plugins/$plugin/manifest.json" | cut -d'"' -f4)
    echo "  ✓ $plugin ($VERSION)"
  else
    echo "  ✗ $plugin — missing main.js or manifest.json"
    MISSING_PLUGINS=$((MISSING_PLUGINS + 1))
  fi
done

if [[ $MISSING_PLUGINS -gt 0 ]]; then
  echo ""
  echo "  $MISSING_PLUGINS plugin(s) missing. Attempting to re-download..."
  bash "$VAULT_ROOT/scripts/install_plugins.sh"
fi

echo ""

# ---------- 3. Vault/.env ----------
echo "3. Setting up Vault/.env..."
if [[ -f "Vault/.env" ]]; then
  echo "  ✓ Vault/.env already exists (not overwriting)"
elif [[ -f "Vault/.env.example" ]]; then
  cp "Vault/.env.example" "Vault/.env"
  echo "  ✓ Copied Vault/.env.example → Vault/.env"
  echo "    Edit Vault/.env to add your real secrets before running any workflow that needs them."
else
  echo "  ⚠ Vault/.env.example not found — skipping"
fi

echo ""

# ---------- 4. Skillkit (powers the Agentfiles dashboard) ----------
echo "4. Installing skillkit (Agentfiles dashboard dependency)..."
if command -v npm >/dev/null 2>&1; then
  if command -v skillkit >/dev/null 2>&1; then
    SKILLKIT_VERSION=$(skillkit --version 2>/dev/null || echo "unknown")
    echo "  ✓ skillkit already installed ($SKILLKIT_VERSION)"
  else
    echo "  → Installing @crafter/skillkit globally via npm..."
    if npm install -g @crafter/skillkit >/dev/null 2>&1; then
      echo "  ✓ skillkit installed"
    else
      echo "  ⚠ skillkit install failed — try manually: npm i -g @crafter/skillkit"
      echo "    (not blocking — everything else still works, just the Agentfiles dashboard won't)"
    fi
  fi

  if command -v skillkit >/dev/null 2>&1; then
    echo "  → Running skillkit scan to index your local agent skills..."
    if skillkit scan >/dev/null 2>&1; then
      echo "  ✓ Initial scan complete"
    else
      echo "  ⚠ skillkit scan didn't complete cleanly — run it manually: skillkit scan"
    fi
  fi
else
  echo "  ⚠ npm not found — skipping skillkit install"
  echo "    Install Node.js from https://nodejs.org, then run: npm i -g @crafter/skillkit && skillkit scan"
  echo "    (not blocking — Obsidian and the other plugins still work; only the Agentfiles dashboard view needs skillkit)"
fi

echo ""

# ---------- 5. gbrain (retrieval layer for semantic search) ----------
echo "5. Installing gbrain (semantic retrieval layer)..."

# Prefer bun for the install since gbrain is published as a bun-friendly
# git package. Fall back to npm if bun isn't available.
install_gbrain() {
  if command -v bun >/dev/null 2>&1; then
    echo "  → Installing gbrain globally via bun..."
    bun install -g github:garrytan/gbrain >/dev/null 2>&1
  elif command -v npm >/dev/null 2>&1; then
    echo "  → Installing gbrain globally via npm..."
    npm install -g github:garrytan/gbrain >/dev/null 2>&1
  else
    return 1
  fi
}

# Make sure ~/.bun/bin is on PATH for this shell so a just-installed
# gbrain binary is findable.
export PATH="$HOME/.bun/bin:$PATH"

if command -v gbrain >/dev/null 2>&1; then
  GBRAIN_VERSION=$(gbrain --version 2>/dev/null || echo "unknown")
  echo "  ✓ gbrain already installed ($GBRAIN_VERSION)"
else
  if install_gbrain; then
    export PATH="$HOME/.bun/bin:$PATH"
    if command -v gbrain >/dev/null 2>&1; then
      GBRAIN_VERSION=$(gbrain --version 2>/dev/null || echo "unknown")
      echo "  ✓ gbrain installed ($GBRAIN_VERSION)"
    else
      echo "  ⚠ gbrain installed but not on PATH. Add ~/.bun/bin to your shell PATH."
    fi
  else
    echo "  ⚠ Neither bun nor npm found — skipping gbrain install"
    echo "    Install bun from https://bun.sh, then re-run setup"
    echo "    (not blocking — the vault works without semantic search, just fall back to grep)"
  fi
fi

# Try to initialize gbrain if credentials are set in Vault/.env and not placeholders
if command -v gbrain >/dev/null 2>&1; then
  if [[ -f "Vault/.env" ]]; then
    # Source env into a subshell so we don't leak variables to the calling shell
    (
      set -a
      # shellcheck disable=SC1091
      source "Vault/.env"
      set +a

      if [[ -z "${OPENAI_API_KEY:-}" ]]; then
        echo "  ⚠ OPENAI_API_KEY not set in Vault/.env — skipping gbrain init"
        echo "    gbrain needs OpenAI for embedding generation. Add your key and re-run."
        exit 0
      fi

      if [[ -z "${SUPABASE_POOLER_URL:-}" || "$SUPABASE_POOLER_URL" == *REPLACE_ME* ]]; then
        echo "  ⚠ SUPABASE_POOLER_URL not set (or still has REPLACE_ME placeholder)"
        echo "    To get the right value:"
        echo "      1. Open your Supabase project dashboard"
        echo "      2. Click 'Connect' (top-right)"
        echo "      3. Choose the 'Session pooler' tab (NOT Direct connection)"
        echo "      4. Copy the postgresql:// URL (port 6543)"
        echo "      5. Paste into Vault/.env as SUPABASE_POOLER_URL=..."
        echo "      6. Re-run this setup script"
        echo "    Skipping gbrain init until this is set."
        exit 0
      fi

      # Check if already initialized (config file exists)
      GBRAIN_CONFIG="$HOME/.config/gbrain/config.json"
      if [[ -f "$GBRAIN_CONFIG" ]]; then
        echo "  ✓ gbrain already initialized (config at $GBRAIN_CONFIG)"
        echo "  → Running gbrain doctor..."
        gbrain doctor --json 2>&1 | head -5 || true
      else
        echo "  → Initializing gbrain against your Supabase..."
        if gbrain init --non-interactive --url "$SUPABASE_POOLER_URL"; then
          echo "  ✓ gbrain initialized"
          echo "  → Running first sync of the vault..."
          if gbrain sync --repo "$VAULT_ROOT" 2>&1 | tail -5; then
            echo "  ✓ First sync complete — vault is now searchable via gbrain"
          else
            echo "  ⚠ First sync had issues. Run manually: gbrain sync --repo \"$VAULT_ROOT\""
          fi
        else
          echo "  ⚠ gbrain init failed. Check that SUPABASE_POOLER_URL is a Session pooler"
          echo "    string (port 6543), not Direct connection or a PAT. Re-run when fixed."
        fi
      fi
    )
  else
    echo "  ⚠ Vault/.env not found — gbrain init will run on next setup when credentials are in place"
  fi
fi

echo ""

# ---------- 6. Open in Obsidian ----------
echo "6. Opening the vault in Obsidian..."
if [[ "$(uname)" == "Darwin" ]]; then
  # Use Obsidian's URI scheme to open this specific vault
  # Obsidian registers itself to handle obsidian:// URIs
  VAULT_NAME=$(basename "$VAULT_ROOT")
  VAULT_URI="obsidian://open?path=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$VAULT_ROOT")"
  open "$VAULT_URI" || open -a Obsidian "$VAULT_ROOT"
  echo "  ✓ Opened (if Obsidian didn't open, run: open -a Obsidian \"$VAULT_ROOT\")"
else
  echo "  ⚠ Non-macOS: open Obsidian manually and use File → Open vault → $VAULT_ROOT"
fi

echo ""

# ---------- 7. Post-setup instructions ----------
cat <<'EOF'
=== Setup done ===

Next steps in Obsidian:

  1. FIRST TIME ONLY: Obsidian will ask "Trust author and enable plugins?"
     — click YES. This activates the bundled plugins:
       • internetvin-terminal — embedded terminal (Cmd+P → "Terminal")
       • agentfiles           — browse AI agent files
       • excalidraw           — sketch drawings

  2. If the plugins don't activate automatically, go to:
     Settings → Community plugins → make sure Restricted mode is OFF

  3. Start the onboarding flow. In Claude Code, run:

       /brain-onboard

     Or if you want to just discover what's on your machine first:

       /brain-discover

  4. Read the master plan at a glance:

       cat "MASTER PLAN.md"

That's it. Welcome to your Evolving Brain.
EOF
