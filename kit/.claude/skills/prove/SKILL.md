---
name: prove
description: "Use to run the thing and observe what actually happens, reporting PASS, DEFECT, COULD NOT VERIFY, or NOT APPLICABLE with evidence. Triggers: 'prove it works', 'does it actually work', 'run it and see', a behaviour claim that needs run-and-observe proof, any kind of project - an app, a document, a dataset, a procedure."
argument-hint: "[what to check | ticket-id | --build | --dry-run]"
---

# Prove - Run-and-Observe Sanity Check

> Named `/prove`, not `/verify`, on purpose: Claude Code ships its own `/verify` (build and drive
> an app), and a project skill with the same name would replace it. This one is the stack-neutral
> four-verdict check; keep both.

> **GLOBAL DIRECTIVES (anti-bureaucracy):**
> 1. Dry, plain prose, no filler.
> 2. Surface only what matters: PASS, DEFECT, COULD NOT VERIFY, or NOT APPLICABLE + evidence. Do not edit specs or status.
> 3. Terse report: end with one line - verdict + evidence path.

Lightweight check that a change **actually works when exercised**, not just that the cheap check
passed. Produce (optional), run, walk a minimal scenario, capture output, then report one of the four
verdicts with
evidence. Read-only on specs and plans. Artifacts go to `<SCRATCH_DIR>/`.

This is the in-between tool: heavier than reading the diff, lighter than a full QA pass.
Use it after `/quick`, `/fix`, or `/spec-dev` to catch a trivial breakage early.

## Usage

```text
/prove                                   # default smoke: start the target (<RUN_CMD> where there is one), basic happy path, scan logs for errors
/prove <free text describing what to check>
/prove <ticket-id>                       # read the ticket's acceptance criteria as scenario hints (do not edit the ticket)
/prove --build                           # rebuild before running (default: skip build)
/prove --dry-run                         # author the scenario only, no execution
```

Adapt the *how* to your project: a web app → drive a browser or hit endpoints; a CLI → run
it with representative args; a service → start it and probe; a mobile app → launch on a
device/emulator; a document → render it and read the result as a stranger would; a dataset or
report → run the pipeline on a sample and reconcile the numbers against their source; a procedure →
have someone follow it from the text alone. The kit defines the *method*, not the driver.

## Process

**1 - Parse arguments.** A ticket-id-shaped token → read its acceptance criteria as hints
(read-only). Otherwise treat the text as the scenario. Empty → default smoke.

**2 - Pre-flight.** Confirm the run target is reachable (server up, device online, binary
present). If not, report `COULD NOT VERIFY` with the blocker and stop - do not fake a pass.

**3 - Produce the thing (only when `--build`).** Run `<BUILD_CMD>` - or whatever your project's
produce step is: a render, an export, a pipeline run. On failure: capture the tail of the output to
`<SCRATCH_DIR>/prove_<TS>.md`, report `DEFECT`, and abort. Do not proceed.

**4 - Author the scenario.** Write `<SCRATCH_DIR>/prove_<TS>.md` with a header (target,
version, environment) and an ordered 1-5 step scenario. Each step: `goal`, `action`,
`expected observable result`, optional `expected log line`. Sources, in priority order:
user free-text → ticket acceptance criteria → default smoke (start, exercise the main
path, assert no error/crash).

If `--dry-run`, stop here and report `NOT APPLICABLE - dry run requested; no scenario was executed`, plus
the path.

**5 - Capture output.** Start log/stdout capture before the run; record the start time.

**6 - Execute the scenario.** For each step: perform the action, capture evidence
(screenshot/response/stdout), verify the expected result, append a row to the run-log
table. On a crash/fatal error: capture the stack, record `DEFECT`, stop the run.

**7 - Analyse output.** Scan captured logs for error-level lines and exceptions. For a
ticket awaiting manual test, additionally grep for its verification tag (`<ID>:`) - each
hit means that code path was exercised. Append a findings section: counts per level, top
errors with references.

**8 - Report.** End with one line naming the target and exactly one verdict:

```text
prove: <target>, PASS N/N, log errors N, crashes K. Scenario: <SCRATCH_DIR>/prove_<TS>.md
prove: <target>, DEFECT - <failed expectation>. Scenario: <SCRATCH_DIR>/prove_<TS>.md
prove: <target>, COULD NOT VERIFY - <blocker>. Scenario: <SCRATCH_DIR>/prove_<TS>.md
prove: <target>, NOT APPLICABLE - <configuration reason>. Scenario: <SCRATCH_DIR>/prove_<TS>.md
```

Use `DEFECT` only after inspecting the target and finding a failed expectation. Use `COULD NOT VERIFY`
when the target or instrument was out of reach. Use `NOT APPLICABLE` only when the requested configuration
deliberately has no executable scenario; it is not a pass. Optional next step: PASS → "OK to commit." Any
DEFECT → one-sentence root-cause guess + route to `/fix` or `/spec-fix`. How a caller reads each
verdict, and what each maps to in `/spec-check`, is one table in `docs/VALIDATION.md` ("One
vocabulary"). For a ticket waiting on a human, a PASS here is evidence for the human to tick a
`## Manual checks` line - this skill still never ticks it.

## Constraints

- **Read-only on specs/plans/status.** Never flip a ticket status from here.
- **No commits.** `git status`/`git diff` may be inspected; committing is the user's call.
- **Outputs land only in `<SCRATCH_DIR>/`.** Never write to the repo root.
- **Never read a huge log fully into context** - tail or grep it (e.g. `tail -n 200` /
  `Get-Content -Tail 200`, or filter by level) and quote line numbers.
- **Re-resolve UI elements before each interaction** - never hardcode coordinates.
