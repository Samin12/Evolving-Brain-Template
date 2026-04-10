# gbrain upstream manifest

Pinned copies of files from [garrytan/gbrain](https://github.com/garrytan/gbrain).

- **Upstream repo:** `garrytan/gbrain`
- **Upstream branch:** `master`
- **Pinned commit:** `e9f3c9c24d36a8bbef85ea55411cfe3001d342a3`
- **Pinned date:** 2026-04-10
- **License:** MIT
- **Last sync run:** _never_

## Tracked files

| Local path | Upstream path | Purpose | Adopted into our vault? |
|---|---|---|---|
| `CLAUDE.md` | `CLAUDE.md` | Agent instructions reference | Partial — informed our `AGENTS.md` |
| `docs/GBRAIN_SKILLPACK.md` | `docs/GBRAIN_SKILLPACK.md` | Full reference architecture for agent-brain loop | Partial — informed our workflows and philosophy |
| `docs/GBRAIN_RECOMMENDED_SCHEMA.md` | `docs/GBRAIN_RECOMMENDED_SCHEMA.md` | Entity page schema (compiled truth + timeline, IDs, citations) | Yes — adopted in `People/`, `5 - Projects/`, `6 - Areas/` templates |
| `docs/SQLITE_ENGINE.md` | `docs/SQLITE_ENGINE.md` | Design spec for unbuilt SQLite backend | Reference only — upgrade path for Phase 6 |
| `docs/ENGINES.md` | `docs/ENGINES.md` | Pluggable engine interface design | Reference only |
| `skills/ingest.SKILL.md` | `skills/ingest/SKILL.md` | How the agent ingests new content | Partial — informed our `inbox processing.md` |
| `skills/query.SKILL.md` | `skills/query/SKILL.md` | 3-layer search + synthesis pattern | Partial — informed our `query.md` workflow |
| `skills/maintain.SKILL.md` | `skills/maintain/SKILL.md` | Brain health checks: contradictions, stale info, orphans | Partial — informed our `maintain.md` workflow |
| `skills/briefing.SKILL.md` | `skills/briefing/SKILL.md` | Daily briefing compilation | Partial — informed our `briefing.md` workflow |
| `skills/enrich.SKILL.md` | `skills/enrich/SKILL.md` | External API enrichment (Crustdata, Exa) | Reference only — out of scope for now |
| `skills/migrate.SKILL.md` | `skills/migrate/SKILL.md` | Universal migration from other tools | Partial — informed our `migrate.md` workflow |

## Sync procedure

See `9 - Operations/workflows/sync upstream.md`. Short version: fetch the latest version of each tracked file at upstream HEAD, diff against the pinned copy, report changes, wait for human to adopt or dismiss, then update the pinned commit hash.

## Adoption levels

- **Yes** — we've directly written the gbrain pattern into our vault files. Diffs upstream should trigger a review of our adaptations.
- **Partial** — we've borrowed ideas but our implementation differs. Diffs upstream are informational; adopting requires redesign.
- **Reference only** — we track the file but haven't adopted anything from it yet. Diffs are informational.

## History

| Date | Action | Details |
|---|---|---|
| 2026-04-10 | First pin | Initial 11 files at `e9f3c9c` |
