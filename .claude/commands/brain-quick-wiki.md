---
description: Generate the Wikipedia-style static site from the vault — the quick-win visualization
---

Run `9 - Operations/workflows/generate wiki.md` against the current state of the vault and report the result.

## Procedure

1. Read `9 - Operations/workflows/generate wiki.md` for the full prompt and follow it.
2. If `scripts/wiki_build.py` doesn't exist, write it per the workflow instructions (Jinja2 template, Python-markdown, python-frontmatter, < 200 lines).
3. Run the script. Capture stdout/stderr.
4. Verify `site/index.html` was created.
5. Report:
   - Number of pages generated, grouped by category
   - Any files skipped due to `publishable: false` or sensitivity rules
   - The absolute path to `site/index.html`
   - A command the user can run to open it (`open site/index.html` on macOS)
6. Update the `last_run` frontmatter in `9 - Operations/workflows/generate wiki.md` to now.
7. Append a row to the current month's file in `9 - Operations/runs/`.

## After generation

Ask the user if they want to:
- Leave it as a local build (default — `site/` is gitignored)
- Publish it to GitHub Pages on a private repo
- Polish the look — add search, infoboxes, a graph view, or swap to Quartz 4

Don't do any of these without being asked.

## Rules

- Never include files from `Vault/`, `.inbox/`, or any file with `publishable: false` frontmatter.
- By default, exclude all `0 - Identity/` files and the sensitive Live Logs (EMOTIONS, DECISIONS, REFLECTIONS) unless each is marked `publishable: true`.
- Never commit `site/` without asking.
- If the script errors, fix the script — don't fall back to copying markdown as-is.
