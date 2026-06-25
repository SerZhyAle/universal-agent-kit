---
name: release-freeze
description: Non-critical merges paused from 2026-03-05 for the release cut
type: project
---

Non-critical merges are frozen starting 2026-03-05 while the team cuts a release branch.

**Why:** the release is being stabilized; landing unrelated changes during the cut risks
destabilizing the branch and muddying the release diff.

**How to apply:** before proposing to merge non-critical work scheduled on or after that date,
flag the freeze and suggest holding or targeting the post-release branch. Critical fixes still
go in. Re-check whether the freeze is still active before relying on this - it is short-lived.
