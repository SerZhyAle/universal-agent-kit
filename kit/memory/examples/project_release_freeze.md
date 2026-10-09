---
name: release-freeze
description: Non-critical changes on hold from 2026-03-05 until the release is signed off
type: project
---

Non-critical changes are on hold from 2026-03-05 while the release is checked and signed off.

**Why:** the version going out is being checked end to end; an unrelated change landing during the
check makes part of that check stale and blurs what this release actually contains.

**How to apply:** before proposing a non-critical change on or after that date, flag the freeze and
suggest holding it until after sign-off. Critical corrections still go in. Re-check that the freeze
is still on before relying on this, and delete this entry once the release is signed off.
