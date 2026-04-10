#!/usr/bin/env bash
# Evolving Brain — plugin re-installer
#
# Downloads the three required Obsidian plugins from their GitHub releases
# and places them in .obsidian/plugins/. Used by setup.sh as a fallback
# when the bundled plugin files are missing or corrupt.
#
# To add a new required plugin: add a line to the PLUGINS array below.

set -euo pipefail

VAULT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$VAULT_ROOT"

# Format: "plugin-id|owner/repo|tag"
PLUGINS=(
  "internetvin-terminal|internetvin/internetvin-terminal|1.1.2"
  "agentfiles|railly/agentfiles|0.7.2"
  "obsidian-excalidraw-plugin|zsviczian/obsidian-excalidraw-plugin|2.22.0"
)

echo "=== Installing Obsidian plugins ==="

for entry in "${PLUGINS[@]}"; do
  IFS='|' read -r id repo tag <<< "$entry"
  dest=".obsidian/plugins/$id"
  mkdir -p "$dest"

  echo ""
  echo "→ $id ($tag) from $repo"

  for asset in main.js manifest.json styles.css; do
    url="https://github.com/$repo/releases/download/$tag/$asset"
    if curl -fsSL "$url" -o "$dest/$asset"; then
      size=$(wc -c < "$dest/$asset" | tr -d ' ')
      echo "  ✓ $asset ($size bytes)"
    else
      if [[ "$asset" == "styles.css" ]]; then
        echo "  ⚠ $asset missing from release (ok, some plugins have no styles)"
      else
        echo "  ✗ $asset — download failed"
        exit 1
      fi
    fi
  done
done

echo ""
echo "=== Plugins installed ==="
echo "Restart Obsidian to load them, or run: Cmd+P → 'Reload app without saving'"
