# METRICS_LOG

> Weekly snapshot of the three North Star metrics. Append-only. One row per week.

See `NORTH STAR.md` for the definition of each metric and how to measure it.

## Table

| Week ending | Step-away hours (median/day) | Automation + Augmentation % | Revenue / person (TTM) | Notes |
|---|---|---|---|---|
|  |  |  |  |  |

## How to fill this in

1. **Step-away hours:** median over the last 7 days of "longest uninterrupted stretch in a normal work day". Round to nearest 0.5.
2. **Automation %:** list the top ~20 tasks you actually did this week, tag each A / G / M, compute (A + G) / total. Round to nearest 5%.
3. **Revenue / person:** trailing-12-month revenue ÷ current FTE count. Update monthly; carry the last known value forward on off-weeks and mark with `(carry)` in the notes column.
4. **Notes:** one short sentence. What moved this week and why, or what the number is hiding.

## Rules

- Never overwrite a past row. If you got a number wrong, add a correction note in the row below.
- Do not delete rows. Bad weeks are the most useful data.
- If you skip a week, leave the row blank with the week-ending date — skipped weeks are also signal.
