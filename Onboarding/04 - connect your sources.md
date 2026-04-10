# 04 - Connect your sources

One-time setup to wire your capture tools into `.inbox/` so the brain grows on its own after onboarding.

**Principle:** keep using the capture tools you already love. Heptabase, Apple Notes, Day One, voice memos, your meeting notetaker — none of it has to change. We just need each of them to drop a copy of new content into `.inbox/<source>/` on some interval.

The brain does not need real-time sync. Hourly or every-few-hours is plenty. Batch-friendly is cheaper and less noisy.

---

## The contract (short version — full version in `.inbox/README.md`)

A connector has to do three things:

1. Write new markdown files to `.inbox/<source-name>/` following the naming convention `YYYY-MM-DD-HHMMSS-<slug>.md`.
2. Include frontmatter with at minimum: `source`, `captured_at`, `type`, `author`.
3. Never touch `.inbox/processed/`. That's the processor's territory.

That's it. Anything that does those three things is a valid connector.

---

## Connector options (pick what fits)

### Option A: MCP connectors

If the tool you're capturing in has an official or community MCP server, that's the cleanest path. Claude runs the MCP, pulls new items on a schedule, and writes them to `.inbox/`.

Wire it into `9 - Operations/workflows/capture via MCP.md` (we'll write that file once you pick your MCPs).

### Option B: Native export + watch folder

Many tools (Heptabase, Obsidian, Day One) have native markdown export to a folder. Point the export at `.inbox/<source>/`. Set up a cron or a file watcher (macOS: `launchd` or a Hazel rule; Linux: `inotifywait`) to `git add && commit && push` when new files arrive.

### Option C: API pollers

For tools without MCPs or exports (Gmail, Notion, some CRMs), a small poller script on a cron calls the API, fetches new items since the last run, writes them to `.inbox/<source>/`, and records the last-seen timestamp locally.

### Option D: Phone shortcuts

iOS Shortcuts + "Append to GitHub file via API" works for voice memos and ad-hoc captures. Record a voice memo → shortcut transcribes → commits to `.inbox/voice/`.

### Option E: Claude itself, from your phone

When you chat with Claude on your phone and say something worth remembering, Claude calls the `append_to_inbox` MCP tool (part of the brain's own MCP server — see `9 - Operations/workflows/brain MCP server.md`, built in a later phase). The chat becomes a capture source.

---

## Recommended first wiring (in priority order)

1. **Meetings** — whatever you use (Granola, Fathom, Otter, etc.). This is the highest-signal input per capture. Wire it first.
2. **Voice memos** — lowest friction for ad-hoc thoughts. Wire via iOS Shortcut + Whisper + GitHub API.
3. **Your primary note app** — whichever of Heptabase / Apple Notes / Obsidian you actually use for day-to-day thoughts. Wire via native export + watch folder.
4. **Everything else** — add as needed. Most people will find they only need 3-4 sources.

Don't try to wire everything at once. Get one source working end-to-end (capture → .inbox → processor runs → vault updates → commit pushes), then add the next.

---

## Testing a connector

A connector is working if all of these are true:

- [ ] A test capture in the source tool appears in `.inbox/<source>/` within the expected interval.
- [ ] The file has valid frontmatter.
- [ ] The next scheduled processor run picks it up and produces something in the vault.
- [ ] The raw file gets moved to `.inbox/processed/YYYY-MM/<source>/`.
- [ ] The commit pushed to GitHub has a clear summary message.

If any of these fail, debug that step before adding more sources.
