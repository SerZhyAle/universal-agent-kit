# Validation Ladder & Post-Change Discipline - "done" means evidence

A step is not done when you *intended* it to work. It is done when a check passed **in this
run**. The gap between those two is where most regressions live. This document is the rule that
closes it: every change ends with the weakest piece of evidence strong enough to prove it, and
not a heavier one.

## The ladder

Match the evidence to the kind of change. Climbing higher than necessary wastes time; climbing
lower than necessary ships a defect.

The rungs below are named for code because that is where they are sharpest, not because the ladder
needs a compiler. If your artifacts are documents, datasets, contracts or procedures, read your own
column in `PROJECT_SHAPES.md`: the rungs are the same shape - a cheap mechanical answer, then a
narrow one, then an expensive one, then a human - and the rule that picks between them is
unchanged.

- **Doc / text only** → grep the file for the content you claim you wrote. If the words are
  there, the change is real.
- **Script** → run it; it exits `0` (or produces the expected artifact). A script you wrote and
  did not run is a guess.
- **Config / build files** → the target build passes. Config that "looks right" but breaks the
  build is the most common self-inflicted wound.
- **A structured artifact** - a dataset, a sheet, a register, a form, a contract - → the structural
  check first (it parses, every required field is present, every cross-reference resolves), then
  the reconciliation (the total here equals the total there, the cited source says what it is
  cited for). Both are mechanical, both are seconds, and skipping them is how a confident wrong
  number reaches a reader.
- **Code** → the *narrowest meaningful* check:
  - a compile / type-check for a pure symbol or signature change,
  - a targeted test for changed logic,
  - a full build or run only when packaging, resources, or end-to-end behaviour actually need
    proof.
  Do not run the whole suite to validate a one-line rename; do not claim a behaviour fix with
  only a compile.
- **User-visible behaviour** → run it and observe. Compiling is not behaving. Observe it in every
  input mode the product declares - touch, keyboard, pointer, controller, a screen reader - and in
  every layout class it claims (narrow, wide, rotated), or record a mode as not applicable. A flow
  that works by touch has proved nothing about the keyboard: each control must be reachable, in a
  predictable order, and say what it does to assistive technology.

The rule of thumb: **grep < run-script < compile < targeted test < full build < run-and-observe.**
Pick the lowest rung that actually proves *this* change, and stop there.

### The top rung is often a human, and a human check has not happened yet

The last rung frequently cannot be climbed by the agent at all - it needs real hardware, a real
account, a real pair of eyes. Say what that scores, because the intuitive answer is wrong: an audit
that finds **no failures** but leaves an unobserved manual line does **not** score "verified", it
scores "needs a human test". Nothing is broken; something is merely unlooked-at, and those are
different verdicts. So count the unticked manual items and let a single one of them hold the closing
status back - only the human pass converts it. This is not a formality: one ticket was declared done
carrying one unticked device line, and an hour on real hardware showed **one of its five acceptance
criteria failing outright**. The kit wires this as the `BlockNeedUserTest` status and the "no open
MANUAL item" rule in `/spec-check`; `SPEC_LIFECYCLE.md` owns the mechanics.

**The human status is for what only a human can see.** A ticket names its rung of the ladder up
front, and a change a build or a targeted test settles closes there, with no human pass. Parking a
static fix behind `BlockNeedUserTest` spends the scarcest reviewer on what a machine already proved,
and teaches them the queue is noise. What truly needs a human is batched into one pass after the work
that produced it, not drained ticket by ticket.

### A check has four answers, and folding the last two together is how it starts lying

The fixed set is **PASS**, **DEFECT**, **COULD NOT VERIFY**, and **NOT APPLICABLE**. DEFECT means the
check inspected the subject and found a failed expectation. COULD NOT VERIFY means the subject or
instrument was out of reach, so nothing was measured. NOT APPLICABLE means the selected configuration
deliberately has no scenario to execute; it is not a pass. A check with no way to say the last two will
report one of the first two instead, and from then on its output is fiction with a green tick on it.

Two rules follow, both measured on one release sweep (2026-09-20):

- **Validate the instrument before you trust its reading.** A reading that is physically impossible
  means the instrument is broken, not that the subject failed. One geometry check took an impossible
  measurement at face value and called **5 of 5** screens defective; a walk over a navigation tree
  reported **18 of 28** rows unreachable. Both were false. A checker in that state does not merely
  miss defects - it **manufactures blockers that do not exist**, and the cost lands twice: once on
  whoever chases them, once on the credibility of every later red from the same check.
- **A false finding is as expensive as a miss, and louder.** "A real defect would have been one row
  among eighteen false ones" is the failure stated exactly. The check kept running, kept reporting,
  and had become unreadable. Precision is not a nicety on any check whose output a human must
  triage.

And a *could not verify* is never waived into a pass. A sweep that cannot reach its subject has
measured nothing; signing that off converts an unknown into a recorded pass, which is the one
conversion the whole exercise exists to prevent. Observed: a smoke check returned
`VERDICT FAIL .. no-device/infra`, the gate filed it as a waiver-eligible coverage gap, and the
waiver was signed - so a **tooling fault and a genuinely absent subject produced the same bucket**.
Separate them at the source; an infrastructure fault is not a known limitation.

**Force every answer once, and prove the red with a positive control.** A gate's failure branches are
the code that runs least and matters most: a typo in a could-not-verify branch survives until the day
that branch is needed. Give each gate a fixture that drives every answer it can give against a
throwaway input, plus a known-bad input - the pre-fix build, a dropped row - that must turn it red. A
gate never seen going red is not known to be able to.

### One vocabulary, three places that speak it

The run-and-observe skill reports four verdicts, the audit records six per check, and the executor
acts on the result. They are one vocabulary, and every skill that reads another's verdict reads it
through this table rather than through its own guess:

| Meaning | `/prove` says | `/spec-check` records | A caller does |
| --- | --- | --- | --- |
| inspected, as expected | `PASS` | `PASS` | proceed |
| inspected, a non-blocking mismatch | - | `WARN` | proceed to `Partial`; `--strict` treats it as `FAIL` |
| inspected, an expectation failed | `DEFECT` | `FAIL` | hard stop |
| the subject or instrument was out of reach | `COULD NOT VERIFY` | `UNCHECKABLE` | hard stop, exactly as for a defect - and never a mechanical fix |
| no scenario exists in this configuration | `NOT APPLICABLE` | `EXEMPT` | proceed, and record why |
| only a human can observe it | - | `MANUAL` | `BlockNeedUserTest` until the human ticks it |

A skill that handles only `PASS` and "everything else" has quietly folded the third and fourth rows
into the second, which is the lie the section above is about.

## Record expected vs actual

For every check you run, write down what you expected and what you got:

```
expected: exit 0, "3 files written"
actual:   exit 0, "3 files written"   → PASS
```

This is not bureaucracy. Predicting the result *before* reading it is what catches the check
that exited `0` while printing the wrong thing - the failure that a glance at "it ran" would
have missed. A check whose `actual` you did not read did not happen.

`FAIL` on any check means the step is not done: record the blocker and stop. Never auto-revert
and never paper over a failure by moving on - a human decides from the evidence.

**Never re-run a red check until it goes green.** A retry removes the report of the flake, not the
flake: a check that fails one run in five passes more than 99% of the time behind three retries. A
known flaky or known-broken check gets a row in a known-red ledger - owner, ticket - and stays visible
in every report, so an old red cannot hide a new regression behind it.

## Red flags: you are about to claim without proof

The ladder only helps if you actually climb it. The failure mode is subtle: you *narrate* a result
instead of *reading* one. Certain words are the tell that you are about to assert a status you have
not verified this run - treat them as a hard stop, not a hedge:

> "should work", "probably passes", "seems fixed", "looks right", "I think it compiles"

Each of those means the proving command has not been run and read yet. Stop, run it, read the exit
code and the specific verdict line, then state the result in the past tense with the evidence. A
claim you softened with "should" is a claim you already knew you could not back - the softening is
the confession. Self-reports carry the same trap: a subagent's "build passed" is its narration, not
your evidence; re-run and read it yourself.

## Post-change discipline

A change is not just its diff. Before calling a step complete, run the housekeeping the project
needs so it is never "remembered later":

- **Changelog / dev log** - if the project keeps one, the ticket has **one** entry, and each step
  adds its files to it. An entry per step or per phase buries the change; no change log at all is a
  legitimate choice, and a check for an entry is then not applicable.
- **User-facing docs** - update them for any new user-visible capability, in every surface and
  every **authored** locale. Do this *before* marking the step done, not in a cleanup pass that
  never comes. Keep the full list of ship-together surfaces (README, site page, each locale, each
  listing) in one manifest and touch them in the same change - the surface missing from the list is
  the one that silently goes stale. `/surfaces` runs this list: it prints the surface table before
  any edit and greps the change's key noun across every touched surface.
  **Surfaces must move together; the rest of the declared locale set need not.** Where the project
  has a release boundary, nothing reaches a user between releases, so the locales nobody on the team
  authors by hand fan out in one bulk pass at that boundary - one pass clears every new key of a
  release, while translating per change buys a full fan-out per key with no shipping benefit (in one
  product: ten further translations per key on top of the three authored ones). Put the **refusal**
  in the pre-release gate, and let the change's own closure only *name* what is still missing rather
  than block on it. A continuously published product - a site, a rolling library - has no boundary to
  batch to, and there the whole fan-out stays part of the one edit.
- **Code index** - regenerate it if you changed code (see `RESEARCH_INDEX.md`); a stale index
  misdirects the next search.
- **Ticket status** - move the spec's status to match reality (see `SPEC_LIFECYCLE.md`).

Bundle these into one routine (a script, a hook, a checklist) so they ride along with the change
instead of depending on memory.

## Composition - one fail-closed "done"

"Done" is best expressed as one fail-closed command. Bundle the checks that apply to the change
kind behind a single "done" entry point; any one failing gate aborts the whole run non-zero, so
"finished" mechanically means "all applicable gates passed" rather than trusting yourself to
remember each. Keep the kind-to-checks mapping in one place so it cannot silently rot, and scope
each gate by kind *and* touched path so "done" stays cheap - a gate that always runs everything
gets slow, then gets skipped, which defeats fail-closed. Where the runtime can refuse to end a turn
until a command passes (Claude Code's `Stop` hook, `docs/HOOKS.md`), that is the natural place to
wire the "done" command: the claim of completion and the check of it become one event.

**The closure RUNS the rung; it does not merely ask for it.** When a change set carries an artifact
class whose only proof is a link, render, or compile step that nothing else in the routine performs,
the "done" command must run that step, selected by artifact class. Otherwise the matching rung of
the ladder above is a *request*, and a request is an ungated rule - which `AUTHORING.md` measures at
1-8% compliance. The observed failure: nothing in one project's closure routine linked its
resources, and its compile-only check compiled code without linking any, so a broken user-facing
layout closed **green** and its ticket reached "install this and test it" without the thing to be
installed ever having been built.

**A closure that prints a fix command and then fails is a ritual.** When the repair is deterministic
and local - regenerate a derived file, register a new one - the per-change closure performs it and
reports it as repaired, naming the file it rewrote, instead of going red with a command for somebody
to paste. The release path stays a pure check: there, the same drift is a finding.

## Before an irreversible step, the verdict is an input - not a report filed next to it

A release, a publication, a filing, a payment, a send: the class of step that cannot be undone by
editing a file. Everything above is about proving a change; this is about the one moment where being
wrong is permanent, and it fails in three specific ways. All three were measured on one project
(2026-09-20), and none of them involved anybody breaking a rule.

- **The absence of a verdict is not a pass.** "A red blocks the ship" says nothing about a sweep
  that never ran, so a project can hold the rule perfectly and ship unverified for months - nothing
  went red, because nothing ran. Close it by making the irreversible step itself **refuse without a
  verdict artifact that names what it judged**. Naming matters as much as producing: a verdict from
  the previous round is exactly what a hurried step reaches for.
- **Wire the gate into the command that ships, not into a command beside it.** One project had the
  whole apparatus - a documented gate emitting one of its declared verdicts, working - owned
  by its *pre-release sweep*, while releases were cut by a separate runbook that never mentioned it.
  Grep of that runbook for the gate's own name: **zero matches**. Skipping the sweep therefore
  skipped the gate silently, and two consecutive releases went out with no written verdict at all.
  Whenever a check and the irreversible act it guards live in two different commands, the check is
  optional in practice however the docs read.
- **Nothing the step generates may be committed after it. Generate, commit, then ship.** Listing
  text, release notes, a cleanup of markers the version retires - all of it is part of what you
  shipped, so it belongs in history before the act that freezes it. Put it after and it becomes work
  with no deadline behind it. Observed: the commit the tag pointed at landed at **17:33**, the store
  changelogs at **17:45**, and that one late commit was carrying the orphaned text of **three
  earlier releases** nobody had noticed.

One more, because it is where the surface rules break first: **a hurried fix-release is exactly the
pressure that splits one surface set across two commits.** In the same project the English notes and
all three READMEs went in one commit and the other two locales followed **eight minutes later** - the
"every surface, every authored locale, one edit" rule broken not by disagreement but by haste. That
is evidence the rule wants a gate on the shipping path, not another paragraph telling people to be
careful.

**A gate that has not run since the last irreversible step is itself unverified.** One smoke check
had rotted so far that three independent defects sat in it at once, found by the release that needed
it rather than before it. Anything the ship depends on runs on a cadence that does not wait for the
ship - in CI, in a periodic sweep, or on a schedule - or its first run in months happens at the worst
possible moment.

## A green can lie

A pass/fail signal can come from the wrong command. When commands are chained, piped, or
backgrounded, the aggregate exit status often reflects a trailing or wrapper step, not the build
or test you care about - a passing wrapper masks a failing core. Read the specific verdict line of
the operation that matters, or have it emit its own result. A green that lies is worse than no
check at all.

**A green that does not name its subject proves nothing.** A verdict is evidence only about what the
check inspected, so the check prints it - the module, variant, file set or document - where nobody can
miss it, and a completion claim quotes that line with the exit code. A check of the neighbouring module
exits 0 on a change it never looked at, and gets quoted as proof all the same.

**A gate's reach is a claim, so prove it.** A gate that reads only the main source root is silent
about every other variant, module or folder while its record says "covered". Have the gate declare what
it reads, check that list against the real tree, and give each new matcher a fixture for every shape it
claims to recognise - one input that must match and one that must not.

The worst shape this takes is a **backgrounded gate**. A command that could never run - a missing
interpreter, a refused lock - still exits through its launch line, so the wrapper reports success and
a failed build or a failed gate masquerades as passing. The false green is then the thing that gets
read and reported. Anything you background must write its verdict where a reader can find it - a
marker file with a closed set of outcome values - and never in its exit code. Related, and cheaper:
where a name can simply be **made to work** rather than guarded, make it work. No pre-call guard can
fix and retry a failed command; it can only refuse it before it starts.

**Delete the previous output before the run.** A result file left by the last run looks exactly like
this run's result. Remove it first, so a run that dies before writing reads as *could not verify*,
never as the last run's pass.

**A gate that checks only shape is satisfied by boilerplate.** A field that must be non-empty gets the
same sentence every time, and every copy passes. Reject duplicated evidence and placeholder text, make
each recorded fix cite its own command and exit code, and record an owner's exception in the owner's
own words with the date and where they said it - never as text the agent wrote on their behalf.

## Closing a change on a dirty tree

Most real work happens with other changes in flight. Scope the "done" gate to the *change*, not
the whole tree:

- **Per-change closure runs the diff-scoped gates** - the checks for the files this change touched
  - so a sibling's unfinished work does not fail your close, and yours does not pass on their
  green.
- **CI / release runs the strict full-project gate.** Whole-tree health is proven there, once, not
  on every per-change close - a close that always rebuilds the world gets slow, then gets skipped.
- **Attribute a failure before you fix it.** On a multi-writer tree a red check may belong to a
  sibling's in-flight edit, not yours. Confirm the failure is inside your diff first; the working
  tree, not git history, is the authority for what is currently done, so re-read the live files
  rather than chasing a red that was never yours.

### Place a gate by its subject, not by how much it once hurt

The split above is only worth having if each gate is on the correct side of it, and the default -
"we were burned by this, so check it every time" - puts whole-tree checks in the per-change closure
where they cannot work. Applied to one changed file, a check whose subject is the *tree* or a
*shipped artifact* cannot attribute its finding to that change: it either fails on a sibling's work
in flight or gets demoted to advisory and stops meaning anything. Measured on one project, three
such gates produced **68 of the 191 red lines across 53 batch runs**, and one of them spent **33
minutes of closure time in a month to report a single finding**.

Move a gate to the **release scope** (a pre-release sweep) when all four hold:

- between releases the defect cannot reach a user;
- its subject is the tree or a shipped artifact, not the changed file;
- the finding names its own location, so no attribution is needed;
- batch fixing costs no more than per-change fixing.

Keep it **per-change** when any one holds:

- later work builds on the defect - compilation, resource linking, a migration, a cross-module
  contract;
- the evidence exists only at the moment of the change - the author's intent, a ticket state a probe
  is bound to;
- agents read the artifact between releases, where staleness poisons their decisions.

Two corollaries. **A relocation is a script with an exit code, never a line of prose** - moving a
rule in prose changes its force, not its stage, at the compliance rates `AUTHORING.md` records. And
**age is not the test**: "we were burned by this long ago" describes no gate in a repo whose gates
are all months old. A new gate names its scope class at birth, and unnamed means per-change - which
is exactly how the imbalance builds. A project with no release boundary substitutes "CI-only" for
the release scope and applies the same four-part test.

### Retiring a gate: demonstrated redundancy, never silence

Gates accumulate, and eventually one of them has to go. Two arguments get offered and only one of
them is worth anything.

**Measure the per-gate cost distribution before pruning anything.** Gate cost is usually skewed: one
or two gates carry most of the wall time, and the quiet ones cost a rounding error between them.
Deleting the quiet ones removes insurance and buys almost nothing. Record each gate's wall time over
real runs, then optimise the head: narrow its trigger, move it off the hot path, stop it re-proving
inputs that did not change.

**"It never fires" is not an argument.** A gate that finds nothing may be the reason the failure
stopped happening. Retire one only on a stated argument about the risk.

**"A cheaper check standing in front of it already found everything" is an argument** - and it is
measurable. Measure the *pair*, not the gate alone. Observed on one project (2026-09-20): an
expensive static-analysis step ran in **291 closures, and in 291 of 291 the cheap lexical pass had
already come back clean**; over the whole corpus, real findings the cheap pass missed came to
**0**. It cost **21.4% of the summed gate wall**, and a closure that ran it took **67.1 s against
26.6 s** for one that did not. That is a retirement argument.

One trap sits inside it: **count findings, not non-passes.** That gate's only two non-PASS verdicts
were *could not verify* - which is not yield. Reading them as "it caught two things" is how a
redundant gate survives its own audit.

### Every number a gate rests on ships with its date and the command that regenerates it

A threshold is a measurement, and a measurement decays. Observed: a concurrency bound of **14.1 s**,
measured once, was still refusing work seven weeks later when the real median over 157 runs was
**56.0 s** - about **4x drift**, with the stale figure quoted all the while as if it were current.

The second-order failure is worse than the first: **a standing refusal blinds the audit that would
have caught it.** The range it forbids produces no runs, so the data that would show the bound is
wrong can never be collected. Date every threshold, name its regenerating command beside it, and
treat a bound that has never been re-measured as an assumption rather than a limit.

## A lightweight progress journal (optional)

For multi-step work it helps to keep a human-readable journal - one concise entry per step, with
raw output kept *out* of it:

```
[STEP 4.2] add RetryPolicy to UploadService
changed:    upload/UploadService.ext, upload/RetryPolicy.ext
validation: <test command> → PASS
evidence:   scratch/sessions/20260314_upload_test.txt
blocker:    none
next:       4.3
```

`validation` must name the actual command or predicate, not "verified" or "checked". Full build
logs and grep dumps go to a scratch directory and are *referenced* from `evidence:`, never pasted
into the journal - the journal stays scannable, the raw proof stays available.

Journal at the granularity of the logical change, not the touched file: one entry per
change/ticket batching all its files, and run any index/catalog regeneration once per change, not
once per edit. Left unsupervised, an agent processes file-by-file and defaults to per-file entries
and per-edit regeneration, burying the narrative in noise.

## Why this is a document, not a vibe

Each rung of the ladder is a concrete, repeatable action a reviewer - human or agent - can demand
and re-run. "Done" stops being a feeling and becomes a line you can point at: *which check, what
did it print, was it PASS.* The ladder also keeps the ceremony proportional: a typo does not earn
a full build, and a migration does not get waved through on a compile. Make the check part of
"done", not part of "someday".

## Adapting it

- Map each rung to your project's real commands - your compiler and test runner, or your renderer,
  your validator, your reconciliation query. If a rung has no command yet, that is the next thing
  worth an hour (`PROJECT_SHAPES.md`, "We have no checks" is almost always false).
- If your CI already gates merges, the local ladder is your *fast feedback* before CI - it should
  be a subset you can run in seconds-to-a-minute, not a duplicate of the full pipeline.
- Drop the journal if your tasks are small; keep it the moment a task spans more than a handful of
  steps or more than one session.
