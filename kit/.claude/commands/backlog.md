# Backlog - Drain the Backlog Unattended

> **GLOBAL DIRECTIVES (anti-bureaucracy):**
> 1. Dry technical prose, no filler.
> 2. Advance everything the agent can move alone; never prompt the human mid-loop.
> 3. One end-of-run report: what advanced, what is blocked on a human, and why.

A zero-input driver that works the whole backlog. It picks the highest-priority *eligible*
ticket, runs the full pipeline on it, and loops - until nothing is left that the agent can move
without a human. This sits *above* the per-ticket pipeline: `/spec-all` drives **one** ticket;
`/backlog` repeatedly *selects* a ticket and hands it to `/spec-all` (or the individual `/spec*`
skills). It introduces no new status model - it consumes the existing per-ticket `Priority` field
and the block-state taxonomy of `docs/SPEC_LIFECYCLE.md`.

## Usage

```text
/backlog            # select, advance, loop until only human-gated work remains
/backlog --dry-run  # list what it WOULD select and advance, change nothing
```

## When NOT to use

- You want a *specific* ticket moved → `/spec-all <ID>`.
- You have a single new idea, not a queue → `/spec`.
- The whole queue is already blocked on humans → there is nothing to drain; read the last report.

## Process

**Step 1 - Build the eligible set.** Read every ticket under `<PLAN_DIR>/`. A ticket is
*eligible* when the agent can advance it alone: its status is a live pipeline stage (`Draft`,
`Approved`, `Tactical`, `In Progress`, `Implemented`, `Partial`, `Broken`) and it is not in this
run's skip-cache. Drop the human-gated states (`BlockQuestions`, `BlockNeedUserTest`,
`BlockExternal`) into the report bucket. `BlockByOtherTask` is eligible **iff** its blocker has
since reached `Verified`; otherwise it too is deferred.

**Step 2 - Select.** From the eligible set pick the highest `Priority`; break ties by the
furthest-along status (closer to `Verified` first, so work finishes before new work starts), then
by `<ID>`. State the choice in one line: `<ID> (Priority <P>, <status>) - <why now>`.

**Step 3 - Advance one ticket.** Hand it to `/spec-all <ID>`, which re-enters the pipeline at the
right stage per the gate table in `docs/SPEC_LIFECYCLE.md`. The per-ticket stop conditions still
hold - an unresolved UI decision, an open required question, an unchecked blocker, an ambiguity.
When such a stop fires, do **not** prompt: record the resulting `Block*` state and move on.

**Step 4 - Update the skip-cache.** If the ticket reached a human-gated `Block*` state, or could
not be advanced at all this run, add its `<ID>` to the run's skip-cache so Step 2 never re-selects
it. This is the invariant that stops the loop from spinning on an un-advanceable item. A ticket
that *did* progress (even one stage) is not cached - it stays eligible for a later iteration.

**Step 5 - Loop.** Return to Step 1. The eligible set shrinks each pass: tickets either reach a
terminal `Verified` or land in the skip-cache. Stop when the eligible set is empty.

**Step 6 - Report (the only output a human reads).** One block, no mid-loop interruptions:
- **Advanced** - per ticket: `<ID>`, start status → end status, one line of what moved it.
- **Needs you** - every human-gated ticket collected across the run, grouped by reason:
  `BlockQuestions` (the decision needed), `BlockNeedUserTest` (the hands-on check owed),
  `BlockExternal` (what it waits on). One actionable line each.
- **Stuck** - anything that could not advance for a non-human reason, with the failing check.

`--dry-run` runs Steps 1–2 in a loop against a *simulated* skip-cache and prints the selection
order it would take, then the would-be report buckets - touching no ticket file and invoking no
`/spec*` skill.
