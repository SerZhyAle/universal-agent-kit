---
name: pr-granularity
description: Prefers one bundled PR for a cohesive refactor over many tiny PRs
type: feedback
---

For a single cohesive refactor, deliver it as one bundled pull request, not a chain of tiny ones.

**Why:** confirmed after I split a refactor into five PRs and the person said it was just churn —
the pieces were not independently reviewable or shippable, so the split added overhead without
value. This is a validated preference, not a one-off.

**How to apply:** when a change is one logical unit (a rename across files, an extraction, a
single feature), keep it in one PR. Still split when parts are genuinely independent, land at
different times, or carry different risk.
