# 9 - Operations

The brain's runtime layer. Everything Claude *runs* on your behalf — workflows, connectors, skills — plus the state about what's active, what's archived, what ran when.

This is the "ops dashboard" of the vault. Open this folder when you want to know:

- What workflows are currently scheduled?
- Which connectors / MCPs are wired up right now?
- What skills does Claude have access to for this vault?
- What actually ran in the last day / week / month?
- What's scheduled to run next?

## Contents

| File / folder | What it is |
|---|---|
| `workflows/` | The workflow prompts Claude runs, plus per-file frontmatter with status, schedule, and last-run. |
| `workflows/README.md` | **The workflow registry** — aggregated table of all workflows and their state. Read this first. |
| `connectors/README.md` | **The connector registry** — every MCP server, API poller, or watch folder wired into `.inbox/`. |
| `skills/README.md` | **The skill registry** — Claude skills the vault depends on (e.g. stop-slop, frontend-design). |
| `schedule.md` | Calendar-style view of upcoming scheduled runs. |
| `runs/` | Append-only log of past runs, grouped by month. |

## Conventions

- **Active vs archived.** Every workflow / connector / skill has a `status` field in its frontmatter: `active`, `paused`, or `archived`. Paused = temporarily off but still listed. Archived = no longer in use, moved to the `archived/` subfolder under its category.
- **Global vs project-scoped.** The `scope` field is either `global` or the name of a specific project under `5 - Projects/`. Project-specific workflows can also live at `5 - Projects/<project>/workflows/` — they still get registered here with the project scope.
- **Registry is the source of truth for state; individual files are the source of truth for definition.** The workflow prompt lives in its own file. Its frontmatter is updated after each run. The `workflows/README.md` table is a generated aggregate view.
- **Never delete run history.** `runs/` is append-only. Failed runs are kept so we can debug patterns.

## Who updates this

- **Claude updates `last_run`, `next_run`, and `runs/` entries** after executing a workflow. Part of the workflow's own responsibilities.
- **Claude updates `workflows/README.md`** when a workflow is added, archived, or changes schedule.
- **Humans update `connectors/README.md`** when they wire up a new MCP or connector. Claude can suggest edits but shouldn't silently add connectors the human didn't configure.
- **Humans update `skills/README.md`** when they install a new Claude skill they want this vault to use.
