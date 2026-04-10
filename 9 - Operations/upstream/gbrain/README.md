# upstream/gbrain

Pinned copies of files from [garrytan/gbrain](https://github.com/garrytan/gbrain) — Garry Tan's production personal knowledge brain, MIT licensed.

## Why we track gbrain

gbrain is the closest prior art to what we're building: markdown-in-git as the source of truth, AI agent as the reader/writer, entity pages shaped as dossiers (compiled truth + append-only timeline), a skillpack telling the agent HOW to use the brain. It's been live-tested on a real working brain with 10,000+ markdown files, 3,000+ people, 13 years of calendar data, and 280+ meeting transcripts. That's battle-testing we don't have.

**What we borrow:**

- The entity page pattern (compiled truth on top, append-only timeline on bottom)
- The skill prompts (ingest, query, maintain, briefing, enrich, migrate)
- The recommended schema (persistent IDs, source attribution, citation format)
- The "dream cycle" nightly maintenance concept
- The SQLite engine design (if/when we need a search layer beyond grep)
- The CLAUDE.md agent instructions as a reference for how to write guidance for Claude

**What we do NOT borrow:**

- **Any runtime code.** We don't install gbrain as a package. We don't call its CLI. We don't run its server.
- **The Postgres + pgvector dependency.** gbrain requires Supabase ($25/mo) or self-hosted Postgres. We stay on markdown + git only.
- **The OpenClaw/Hermes framing.** gbrain is opinionated toward specific agent frameworks. Our vault is surface-agnostic.
- **The hardcoded entity types** (person / company / deal / idea). We use a PARA-style structure with `People/`, `5 - Projects/`, `6 - Areas/`, `7 - Resources/`, and let other entity types emerge organically.

## License

gbrain is MIT licensed. Copyright (c) 2026 Garry Tan. We include the copies here under the MIT license terms. See `LICENSE` in the gbrain repo for the full text.

Any file copied into this folder is a verbatim snapshot at a specific commit. Our adaptations (workflows, prompts, templates in the main vault that were inspired by these files) are our own writing, not derivative works of these copies.

## Files tracked

See `UPSTREAM.md` for the manifest with commit hashes and file sizes.

## The SQLite engine discovery

One of the most useful things we found in gbrain: [`docs/SQLITE_ENGINE.md`](./docs/SQLITE_ENGINE.md) is a full design spec for a SQLite backend that was never built. The Postgres/pgvector path is the only one gbrain supports today, but the SQLite design is ready for implementation. If/when we need real search (beyond grep) we have two options:

1. **Implement SQLite engine ourselves** against our vault, following the gbrain spec. Keeps us independent.
2. **Contribute the SQLite engine to gbrain upstream** as a community PR. Gets us their retrieval layer without the Postgres dependency, and benefits everyone.

This is a pleasant surprise. The upgrade path for search is clearer than it was.
