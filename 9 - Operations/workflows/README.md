# Workflows registry

Every workflow Claude can run in this vault, with its current state.

This table is an **aggregated view**. The source of truth for each workflow is the frontmatter of its own file. When Claude finishes a run, it updates the file's frontmatter and regenerates this table.

## Active

| Workflow | Schedule | Scope | Last run | Next run | File |
|---|---|---|---|---|---|
| Inbox processing | every 3h (`0 */3 * * *`) | global | — | — | [[inbox processing]] |
| Onboarding processing | one-time (2 modes: bulk-only, full) | global | — | — | [[onboarding processing]] |
| Dream cycle | nightly 03:00 (`0 3 * * *`) | global | — | — | [[dream cycle]] |
| Briefing | mornings 07:00 (`0 7 * * *`) | global | — | — | [[briefing]] |
| Weekly review | Mondays 09:00 (`0 9 * * MON`) | global | — | — | [[weekly review]] |
| Sync upstream | Mondays 06:00 (`0 6 * * MON`) | global | — | — | [[sync upstream]] |
| Maintain | Sundays 04:00 (`0 4 * * SUN`) | global | — | — | [[maintain]] |
| Journal processing | manual | global | — | — | [[journal processing]] |
| Meeting processing | on-capture (triggered by inbox) | global | — | — | [[meeting processing]] |
| Query | on-demand | global | — | — | [[query]] |
| Migrate | on-demand | global | — | — | [[migrate]] |
| Generate wiki | manual | global | — | — | [[generate wiki]] |

## Paused

_None._

## Archived

_None._ Archived workflows live in `9 - Operations/workflows/archived/` and do not run.

---

## The workflow categories

Workflows fall into four categories:

1. **Capture + synthesis** — `inbox processing`, `journal processing`, `meeting processing`, `onboarding processing`, `migrate`. Get external signal into the vault as structured content.
2. **Maintenance** — `dream cycle` (nightly), `maintain` (weekly), `sync upstream` (weekly), `generate wiki` (on demand). Keep the vault healthy and in sync.
3. **Review + reflection** — `weekly review`, `briefing`. Look backward (review) or forward (briefing) to surface what matters.
4. **Read** — `query`. Answer a specific question from the vault.

## Adding a new workflow

1. Create a new `.md` file in this folder (or in `5 - Projects/<project>/workflows/` for project-scoped).
2. Add frontmatter: `status`, `schedule`, `scope`, `last_run`, `next_run`, `owner`.
3. Write the prompt Claude will follow when the workflow runs.
4. Add a row to the Active table above.

## Archiving a workflow

1. Move the file to `archived/`.
2. Set `status: archived` in frontmatter.
3. Remove the row from Active and add a single-line entry under Archived with the archive date.

## Schedule format

Use cron syntax for scheduled workflows. Human annotations in a comment after the cron string are encouraged. Non-scheduled: `manual`, `one-time`, `on-demand`, `on-capture`, or `on-event:<event-name>`.
