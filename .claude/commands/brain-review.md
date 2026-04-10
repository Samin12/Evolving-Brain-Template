---
description: Run a weekly, monthly, or quarterly review — reads logs, checks North Star, drafts a review note
argument-hint: [weekly|monthly|quarterly]
---

Run the review workflow matching the cadence in `$ARGUMENTS`. Default to `weekly` if no argument.

## Cadence → workflow

- `weekly` → `9 - Operations/workflows/weekly review.md`
- `monthly` → produce `8 - North Star/reviews/YYYY-MM.md` using the monthly template in `8 - North Star/reviews/README.md`
- `quarterly` → produce `8 - North Star/reviews/YYYY-QN.md` using the quarterly template

## Procedure

1. Read the appropriate workflow file and follow its procedure.
2. The output is a draft review note, committed to the appropriate folder.
3. **Never push.** The review is a draft — the human reads it, edits it, and commits/pushes if satisfied.
4. Update the workflow file's `last_run` frontmatter.
5. Append a row to `9 - Operations/runs/YYYY-MM.md`.
6. Report to the user: the path to the draft review note, the headline insights (3-5 bullets), and the single recommended action for the next period.

## Rules

- Do not edit `0 - Identity/` files during a review. If the review surfaces a potential identity shift, flag it in `REFLECTIONS_LOG.md` and in the review note — do not auto-edit.
- Do not edit `NORTH STAR.md` targets during weekly or monthly reviews. Targets only change during quarterly reviews, and only with explicit user confirmation.
- Append a row to `8 - North Star/METRICS_LOG.md` as part of the weekly review (this is in the workflow).
