---
description: "Use to capture an out-of-scope finding as a Draft stub and immediately return to the current task - never chase it now. Triggers: 'park this', an unrelated problem surfaced mid-task, an idea to note without derailing."
---

# Park - Capture an Out-of-Scope Finding

> **GLOBAL DIRECTIVES (anti-bureaucracy):**
> 1. Dry technical prose, no filler.
> 2. Capture, don't chase. One minimal stub, then back to the active task.
> 3. Terse report: one line - `parked: <id>`.

The lightest-weight capture skill: you hit a problem that is real but **not yours right
now**. Record a minimal stub so the finding is not lost, report it in one line, and return
to the original task. `/park` never fixes anything and never switches the active task.

## Usage

```text
/park <one-line symptom> [where found]
```

- `/park retry loop in sync_client never backs off - found while auditing the cache layer`
- `/park settings screen leaks a coroutine on rotation - spotted during the export review`

Trigger it at **any** stage - research, implementation, audit, review, test, log
analysis - the moment a finding is (a) out of scope for the active task, (b) more than a
one-line inline fix, and (c) needs its own investigation.

## When NOT to use

- The issue is a trivial out-of-scope fix (one token, one obvious line) → fix it inline,
  don't park.
- It is a cosmetic nitpick with no behaviour cost → drop it entirely.
- It is in scope for the active task → just do the work.
- You are in a **read-only role** that cannot record items (audit/review with no write
  access) → list the candidates back to your caller instead of parking them yourself.

## Process

**Step 1 - Confirm it's out of scope.** If the finding belongs to the active task, handle
it there. If it is a one-line inline fix, apply it. If it is cosmetic, drop it. Only a real,
out-of-scope, needs-its-own-investigation finding is parked.

**Step 2 - Dedup first.** Search existing parked items / the tracker in `<PLAN_DIR>/` by
symptom (grep / your code index). If a match exists, reference it instead of duplicating -
report `parked: <existing-id> (already tracked)` and stop. A batch review that surfaces
several findings yields **one stub per distinct problem**, not one per mention.

**Step 3 - Record a minimal stub.** Where the stub lives is project-defined - a backlog
dir, the issue tracker, or a `PARKED.md` under `<PLAN_DIR>/`. Write the least that makes it
re-findable:
- a stable `<ID>`,
- `**Status:** Draft` and a default `**Priority:**` (e.g. 40) - so the stub is a live,
  selectable ticket that `/backlog` will pick up and `/spec` can later flesh out, not a
  status-less note the drain loop can never see,
- a one-line symptom,
- where it was found (file/flow, and the task you were on).

No investigation, no root cause, no fix sketch - that is for whoever picks it up later. The
`Draft` seed carries just the symptom; the pipeline expands it when the ticket is selected.

**Step 4 - Report and return.** One line: `parked: <id>`. Then **immediately resume the
original task**. Never switch the active task to chase a parked finding.
