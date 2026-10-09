# Tactical INDEX.md template - used by /spec-tech

```markdown
# Tactical plan: <ID> - <slug>

**Strategic spec:** [`../<ID>_<slug>.md`](../<ID>_<slug>.md)
**Research inputs:** [`research/<NN>__<topic>.md`](research/<NN>__<topic>.md) <or "none">
**Tier:** <label> · **Priority:** <0..100>
**Status:** Not started
**Phases:** 0 / N done
**Last updated:** <YYYY-MM-DD>

> **Scope:** tactical, `<ARTIFACT_LANGUAGE>`, implementer handoff (a person or an agent). Every step has a verification predicate.
> Rationale lives in the strategic spec.

## Phase overview
| # | Phase | Depends on | Status | Steps | File |
|---|-------|-----------|--------|------:|------|
| 01 | <slug> | - | ⬜ Not started | 0/N | [PHASE_01__<slug>.md](PHASE_01__<slug>.md) |
| NN | docs-cleanup | all | ⬜ Not started | 0/N | [PHASE_NN__docs-cleanup.md](PHASE_NN__docs-cleanup.md) |

Legend: ⬜ Not started · 🚧 In Progress · ✅ Done · ⛔ Blocked · ⏭️ Skipped

## Pre-implementation blockers
<Every §6 item with Status: Open becomes a checkbox. Phase 01 must not start while any is
unchecked.>
- [ ] **Research:** <title> - required before Phase <NN>.

## Completion gate
- [ ] All phases ✅ Done.
- [ ] User-facing docs updated only if strategic §8 mandates it.
- [ ] The ticket's one changelog entry lists every modified file (skip where the project keeps no change log).
- [ ] `/spec-check <ID>` returns Verified.

## How to track progress
1. Before a phase: flip its row to 🚧, update `Phases: X/N`.
2. During: flip a step to `[~]` when started, `[x]` when its Verification passes - never on
   intent.
3. On phase done: confirm every step `[x]`, confirm Done Criteria, flip row to ✅, bump.
4. If blocked: flip to ⛔, log it; if the whole spec is blocked, set a `Block*` status.
5. This file's own `Status:` is the plan's progress - `Not started`, `🚧 In progress`, `✅ Done`
   or `⛔ Blocked`, written by `/spec-dev` - never the ticket's status, which lives in the spec.

## Plan revisions
- <YYYY-MM-DD> - initial tactical plan authored by /spec-tech.
```
