---
status: active
schedule: manual
scope: global
last_run: null
owner: claude
---

# Generate wiki

Build a Wikipedia-style static site from the vault. Quick-win visualization: run this after onboarding (even in bulk-only mode) to give the user something they can click through and feel proud of.

Inspired by [Farzaa's wiki-gen-skill](https://gist.github.com/farzaa/c35ac0cfbeb957788650e36aabea836d). The target aesthetic is literal Wikipedia — serif font, blue links, infobox in the top-right of entity pages, backlinks section at the bottom, minimal chrome.

## Inputs

- Every markdown file in the vault EXCEPT:
  - `.inbox/` (raw captures — not for the wiki)
  - `.inbox/processed/`
  - `Vault/` (credentials)
  - Files with frontmatter `publishable: false` (sensitive content)
  - By default, all of `0 - Identity/` and `2 - Live Logs/EMOTIONS_LOG.md` are excluded as sensitive. Opt in per file by adding `publishable: true` to frontmatter.

## Output

- `site/` folder at the repo root containing generated HTML
- `site/index.html` — the home page with a list of categories and recent updates
- `site/<category>/<slug>.html` — one page per entity or log file
- `site/assets/style.css` — Wikipedia-clone CSS
- `site/graph.html` — an SVG graph of wiki-links (optional, v2)

## Procedure

### 1. Decide the stack

Default: a minimal Python script that uses `markdown` + `python-frontmatter` + a Jinja2 template. No database, no deps beyond pip-installable.

If the vault has > 500 files, or the user has asked for a nicer result, use Quartz 4 instead (install per their docs, point content at the vault, build).

For the quick win on first run, always start with the minimal Python script.

### 2. Write the script (first run only)

Create `scripts/wiki_build.py` if it doesn't exist. The script should:

1. Walk the vault, reading every `.md` file not excluded.
2. Parse frontmatter. Skip if `publishable: false`.
3. For each file, convert markdown to HTML. Resolve `[[wiki links]]` to relative href links.
4. Group by category (top-level folder → category).
5. Render each file with the template at `scripts/wiki_template.html` — Wikipedia-style: sans-serif title, serif body, blue links, left sidebar with category list, right-side infobox (if frontmatter has infobox fields), backlinks at the bottom.
6. Render an index page listing categories and the most recently-modified N files.
7. Write output to `site/`.

Keep the script small (< 200 lines). It is a scaffold the user can improve.

Create `scripts/wiki_template.html` with the Wikipedia aesthetic. Reference CSS variables so colors and fonts are easy to tweak.

### 3. Run the script

```bash
python scripts/wiki_build.py
```

Report success + the path to `site/index.html`. Tell the user to open it in a browser.

### 4. Commit (optional)

Do not commit `site/` by default — it's a build artifact. Add to `.gitignore` if not already. If the user explicitly wants to publish via GitHub Pages, create a separate workflow that builds on push and publishes to the `gh-pages` branch.

### 5. Update last_run

Update this file's `last_run` frontmatter to the current timestamp, and append a row to `9 - Operations/runs/YYYY-MM.md`.

## What to do when it doesn't look like Wikipedia

First pass will be basic. That's fine. Tell the user: "This is the bones. To make it look more like Wikipedia, I can: add a proper infobox template, style the backlinks section, add a random-page button, add a search box (MiniSearch), or swap to Quartz 4 for a polished Obsidian-native build. Which do you want?"

Don't polish without being asked. The quick win is that it exists and renders.

## Sensitive content rules

- **Never** include `0 - Identity/SOUL.md`, `0 - Identity/DECISION MAKING PRINCIPLES.md`, or `0 - Identity/INTELLECTUAL BLUEPRINT.md` in the site unless they each have `publishable: true` in frontmatter.
- **Never** include `2 - Live Logs/EMOTIONS_LOG.md`, `DECISIONS_LOG.md`, or `REFLECTIONS_LOG.md`.
- **Never** include anything under `Vault/`.
- **Never** include `.env` or any file matching `*secret*`, `*password*`, `*token*`, `*.key`.
- When in doubt, exclude.
