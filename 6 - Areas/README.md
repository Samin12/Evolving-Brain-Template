# 6 - Areas

PARA-style areas: ongoing domains of responsibility with no end date (health, finances, relationships, craft, team management, etc.). One file per area, upgraded to a folder when complexity demands.

Areas differ from Projects in two ways: they have no end date, and they have a standard you're maintaining rather than an outcome you're pursuing.

## The dossier pattern

Each area page follows the **compiled-truth + append-only timeline** structure (see `People/README.md` for the full philosophy):

- **Top: Compiled truth.** Current standard, current status against that standard, the metrics you watch, the decisions you've made that still apply.
- **Bottom: Timeline.** Append-only updates: reviews, decisions, notable events, changes in approach.

## Template

```markdown
---
id: area-health-2026
type: area
status: active              # active | paused | archived
owner: self
created: 2026-01-01
updated: 2026-04-10
tags: [health, physical]
---

# Health

## Compiled truth

**Standard I'm maintaining:** stay healthy enough to work hard for 10 more years without burning out. Weight stable, strength progressing, sleep 7+ hours, VO2 max trending up not down.

**Current state (2026-04-10):**
- Weight: stable at 172 (target: 168-175, green)
- Strength: squat 225x5, bench 155x5, deadlift 275x5 (progressing monthly)
- Sleep: averaging 7:20, wake time 6:30 (target met)
- Cardio: 3x/week running, VO2 max estimated 48 (last Apple Watch reading 2026-04-08)

**Metrics I watch:** weight weekly, strength PRs monthly, sleep nightly (Whoop), cardio weekly.

**Standing decisions:**
- No alcohol on weeknights (since 2026-01-01)
- Gym 4x/week minimum, no exceptions for travel weeks
- Annual physical in November with Dr. Park
- Fasting window 8 PM - 10 AM most days

**Open threads:** shoulder mobility still limiting overhead press — see PT 2026-04-22.

**Linked projects:**
- [[5 - Projects/Marathon training]] (seasonal, spring)
- [[6 - Areas/Nutrition]] (sibling area)

## Timeline

- **2026-04-09** Squat PR: 235x3. First time above 225 since 2024. → [[ACTIONS_LOG]]
- **2026-04-03** Saw PT about shoulder. Prescribed band work + 6 weeks limit on overhead. → `6 - Areas/Health/pt-notes-2026-04-03.md`
- **2026-03-15** Monthly review. Sleep improved, strength flat. Decided to add a deload week every 5 weeks. → [[DECISIONS_LOG]]
- **2026-02-01** Restarted tracking after 6 months of drift. Weight was up to 180. → [[REFLECTIONS_LOG]]
- **2026-01-01** Annual reset. New standards for sleep + alcohol. → [[0 - Identity/DECISION MAKING PRINCIPLES]]
```

## When an area becomes a project

Sometimes an area has a bounded initiative inside it — "get to marathon pace by June", "pay off the car loan by Q3". That's a project. Create it in `5 - Projects/`, link it from the area page in the `Linked projects` section, and manage it on its own timeline. When the project ends, the area continues.

## When to archive

`status: archived` when the area is no longer a domain of responsibility. Examples: "Team management" when you leave a management role, "Kids bedtime routine" when the kids outgrow it. Move to `Archive/6 - Areas/`, preserve the file intact.

## Persistent IDs

Every area has a stable `id` in frontmatter: `area-<slug>-<year>`. Links by ID don't break on rename.
