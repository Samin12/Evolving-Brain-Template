# 03 - Bulk import guide

How to get your existing notes, journals, and knowledge out of wherever they live and into `.inbox/onboarding/` for the onboarding processor to digest.

**Scope rule:** prefer the last 12-24 months. Older stuff rarely changes how the processor understands you today and it bloats the processing cost. Do an older pass later if it turns out to matter.

---

## What to dump

Anything that reflects how you think, what you're working on, or what happened to you. Examples:

- Journal entries (Day One, Obsidian daily notes, Notion, Apple Notes)
- Heptabase cards
- Meeting notes
- Long-form emails you wrote (sent folder, filtered to substantive ones)
- Substantial Slack threads, filtered to a "save to brain" tag if you have one
- Voice memo transcripts
- Tweets / toots / threads you wrote
- Drafts, half-written blog posts, abandoned essays
- Reading highlights (Readwise export, Kindle highlights)

## What NOT to dump

- Receipts, newsletters you never read, screenshots of memes, every-day Slack banter.
- Things written *at* you (inbound emails, articles, tweets by others) unless you want the processor to know about them. The brain is about you; don't drown it in the firehose.
- Anything you would be uncomfortable with Claude reading. If it's too sensitive for the vault, it stays out.

---

## How to dump

Drop everything into `.inbox/onboarding/<source>/`. Use one subfolder per source so the processor can tell them apart.

```
.inbox/onboarding/
├── apple-notes/
├── heptabase/
├── day-one/
├── obsidian/
├── readwise/
├── sent-emails/
├── voice-memos/
└── manual/           # anything you just type in directly
```

### Format

Markdown preferred. Frontmatter strongly preferred (see `.inbox/README.md` for the contract). If a source can only export HTML or JSON, drop the raw export in and the processor will handle it.

### Source-specific tips

- **Apple Notes** → use an AppleScript or a third-party tool like Exporter or Bear's import to get markdown. One file per note. Preserve dates in filenames.
- **Heptabase** → use their "Export as Markdown" on a whiteboard. Drop the resulting folder in.
- **Day One** → JSON export works. Or, if you want cleaner processing, the plain-text export option with one entry per file.
- **Obsidian** → literally copy the vault folder. Keep the folder structure; the processor uses it as a hint.
- **Readwise** → their "Export as Markdown" produces one file per book with highlights. Drop them in `.inbox/onboarding/readwise/`.
- **Sent emails** → most people don't need this. If you do, filter Gmail for emails longer than some word count, export as .eml, then convert to markdown with a tool like `mbox2md`.
- **Voice memos** → transcribe first (Whisper, MacWhisper, Apple's built-in transcription). Put transcripts in `.inbox/onboarding/voice-memos/`.

---

## After dumping

1. Confirm the files landed in `.inbox/onboarding/` and nowhere else. (The onboarding processor and the ongoing processor behave differently — don't cross the streams.)
2. Go fill out `01 - identity questions.md` and `02 - aspirations questions.md` if you haven't already.
3. Run the onboarding processor: `9 - Operations/workflows/onboarding processing.md`. It will read both the answers and the bulk dump together, so both parts are necessary.
4. After the processor finishes, review the generated Identity and Aspirations files carefully before approving. This is the one moment in the entire system where a lot of content gets written at once — it deserves your attention.
