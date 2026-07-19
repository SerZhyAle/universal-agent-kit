---
description: "Use to run the whole pipeline end to end - research, strategic spec, tactical plan, execution, audit - for one feature. Triggers: 'spec-all', 'take this from idea to done', a feature you want driven start to finish."
---

# /spec-all - full pipeline, idea to verified

Orchestrate the whole spec pipeline end to end: research → strategic spec → tactical plan →
execution → audit. Use it when you have a feature-sized idea and want one command to drive it
through every stage with the right gates, instead of invoking each skill by hand.

This skill does not re-implement the others - it *calls* them in order, pausing only at the real
decision points in the gate table of `docs/SPEC_LIFECYCLE.md`. The work happens in `/research`,
`/spec`, `/spec-tech`, `/spec-dev`, `/spec-check`, `/spec-fix`.

## Usage

```text
/spec-all <one-line description of the idea>
/spec-all <ID>            # resume an existing ticket from wherever its status sits
```

## First: size the task

Run the complexity gate from `docs/SPEC_LIFECYCLE.md` before spending any ceremony.

- A typo or one-constant change → `/quick`. Stop; do not open a ticket.
- A narrow, well-understood bug → `/fix`. Stop.
- **PRIMITIVE** (≤3 files, no new public types, no schema/DI/route changes, deterministic):
  write a three-section spec (Problem / Approach / Done criteria) and implement directly.
- **COMPLEX** (anything else): run the full pipeline below.

State which path you chose and why in one line, then proceed.

## The pipeline (COMPLEX path)

The stages auto-chain - each invokes the next - and the run pauses only at a real decision, per
the gate table in `docs/SPEC_LIFECYCLE.md`. This is momentum by default, not a sign-off at every
stage.

1. **`/research`** - gather evidence: the files, symbols, constraints, and external references
   involved. Persist the findings. Chains on once the landscape is clear.
2. **`/ui-clarify`** - only if the change is user-facing and a placement/wording/fallback decision
   is unresolved. This one *is* a stop: unresolved UI ambiguity blocks the build.
3. **`/spec`** - write the strategic *what/why* (no file paths, no signatures), record the
   `Approved` flip, and chain to `/spec-tech`. Stops only if a required research item is still
   Open. (Want to eyeball the spec first? Run `/spec` alone and read it before continuing.)
4. **`/spec-tech`** - turn the spec into a phased, verifiable plan, each step ending in a static
   check, ordered so no phase consumes what a later phase produces. Chains to `/spec-dev` unless an
   unchecked pre-implementation blocker remains.
5. **`/spec-dev`** - execute one step at a time, running each step's check before marking it done,
   hard-stopping on the first ambiguity or failure. Drives `Tactical → In Progress → Implemented`
   (or `BlockNeedUserTest` when manual testing is part of acceptance).
6. **`/spec-check`** - audit the build against reality and set the final status: `Verified`, or
   `Partial` / `Broken` (auto-chaining to `/spec-fix`), or `BlockNeedUserTest` when a manual signal
   is still open.

If acceptance includes a hands-on check, status lands at `BlockNeedUserTest` after step 5; run
`/verify` (or your manual test), then `/spec-check` to reach `Verified`.

## Rules

- **Auto-chain, stop at real decisions.** The default is momentum: flow stage to stage, pausing
  only at the encoded stop conditions (an unresolved UI decision, an open required question, an
  unchecked blocker, an ambiguity). Don't manufacture extra sign-off gates, and don't skip a real
  one. To review between stages, run the skills individually or pass `--dry-run`.
- **Resume from reality.** Given an `<ID>`, read its current status and re-enter the pipeline at
  the right stage - never restart from research if the plan is already approved.
- **Stay cheap when the task is small.** The size gate above exists so a small change does not
  drag a five-stage pipeline behind it.
- **One ticket, one file.** All stages read and write the same `<PLAN_DIR>/<ID>_<slug>.md` (and
  its tactical folder); status is the first `**Status:**` line and is always true because the
  code makes it so.
