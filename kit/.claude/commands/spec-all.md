# /spec-all — full pipeline, idea to verified

Orchestrate the whole spec pipeline end to end: research → strategic spec → tactical plan →
execution → audit. Use it when you have a feature-sized idea and want one command to drive it
through every stage with the right gates, instead of invoking each skill by hand.

This skill does not re-implement the others — it *calls* them in order and stops at the human
gates. The work happens in `/research`, `/spec`, `/spec-tech`, `/spec-dev`, `/spec-check`.

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

Each arrow is a gate. Stop at a **[human]** gate and wait; pass a **[auto]** gate yourself when
its check is green.

1. **`/research`** — gather evidence on the current state: the files, symbols, constraints, and
   external references involved. Persist the findings. `[auto]` once the landscape is clear.
2. **`/ui-clarify`** — only if the change is user-facing and any placement/wording/fallback
   decision is unresolved. `[human]` — unresolved UI ambiguity blocks the build.
3. **`/spec`** — write the strategic *what/why* (no file paths, no signatures). `[human]`
   gate: the spec moves `Draft → Approved` only on your sign-off. A disagreement here costs a
   sentence, not an implementation.
4. **`/spec-tech`** — turn the approved spec into a phased, verifiable plan, each step ending in
   a static check, ordered so no phase consumes what a later phase produces. `[human]` gate:
   review the phase graph before execution (`Approved → Tactical`).
5. **`/spec-dev`** — execute one step at a time, running each step's check before marking it
   done, hard-stopping on the first ambiguity or failure. `[auto]` per step; drives
   `Tactical → In Progress → Implemented` (or `BlockNeedUserTest` if manual testing is part of
   acceptance).
6. **`/spec-check`** — audit the build against the spec; set the final status from reality:
   `Verified`, or `Partial` / `Broken` with the failing items listed. `[auto]`.

If acceptance includes a hands-on check, status lands at `BlockNeedUserTest` after step 5;
run `/verify` (or your device/manual test) and then `/spec-check` to reach `Verified`.

## Rules

- **Honor the gates.** Do not silently auto-approve the strategic spec or the phase graph —
  those are the two human checkpoints that make the pipeline worth running.
- **Resume from reality.** Given an `<ID>`, read its current status and re-enter the pipeline at
  the right stage — never restart from research if the plan is already approved.
- **Stay cheap when the task is small.** The size gate above exists so a small change does not
  drag a five-stage pipeline behind it.
- **One ticket, one file.** All stages read and write the same `<PLAN_DIR>/<ID>_<slug>.md` (and
  its tactical folder); status is the first `**Status:**` line and is always true because the
  code makes it so.
