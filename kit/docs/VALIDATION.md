# Validation Ladder & Post-Change Discipline - "done" means evidence

A step is not done when you *intended* it to work. It is done when a check passed **in this
run**. The gap between those two is where most regressions live. This document is the rule that
closes it: every change ends with the weakest piece of evidence strong enough to prove it, and
not a heavier one.

## The ladder

Match the evidence to the kind of change. Climbing higher than necessary wastes time; climbing
lower than necessary ships a bug.

- **Doc / text only** → grep the file for the content you claim you wrote. If the words are
  there, the change is real.
- **Script** → run it; it exits `0` (or produces the expected artifact). A script you wrote and
  did not run is a guess.
- **Config / build files** → the target build passes. Config that "looks right" but breaks the
  build is the most common self-inflicted wound.
- **Code** → the *narrowest meaningful* check:
  - a compile / type-check for a pure symbol or signature change,
  - a targeted test for changed logic,
  - a full build or run only when packaging, resources, or end-to-end behaviour actually need
    proof.
  Do not run the whole suite to validate a one-line rename; do not claim a behaviour fix with
  only a compile.
- **User-visible behaviour** → run it and observe. Compiling is not behaving.

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

- **Changelog / dev log** - append the entry if the project keeps one.
- **User-facing docs** - update them for any new user-visible capability, in every surface and
  every **authored** locale. Do this *before* marking the step done, not in a cleanup pass that
  never comes. Keep the full list of ship-together surfaces (README, site page, each locale, each
  listing) in one manifest and touch them in the same change - the surface missing from the list is
  the one that silently goes stale.
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
gets slow, then gets skipped, which defeats fail-closed.

**The closure RUNS the rung; it does not merely ask for it.** When a change set carries an artifact
class whose only proof is a link, render, or compile step that nothing else in the routine performs,
the "done" command must run that step, selected by artifact class. Otherwise the matching rung of
the ladder above is a *request*, and a request is an ungated rule - which `AUTHORING.md` measures at
1-8% compliance. The observed failure: nothing in one project's closure routine linked its
resources, and its compile-only check compiled code without linking any, so a broken user-facing
layout closed **green** and its ticket reached "install this and test it" without the thing to be
installed ever having been built.

## A green can lie

A pass/fail signal can come from the wrong command. When commands are chained, piped, or
backgrounded, the aggregate exit status often reflects a trailing or wrapper step, not the build
or test you care about - a passing wrapper masks a failing core. Read the specific verdict line of
the operation that matters, or have it emit its own result. A green that lies is worse than no
check at all.

The worst shape this takes is a **backgrounded gate**. A command that could never run - a missing
interpreter, a refused lock - still exits through its launch line, so the wrapper reports success and
a failed build or a failed gate masquerades as passing. The false green is then the thing that gets
read and reported. Anything you background must write its verdict where a reader can find it - a
marker file with a closed set of outcome values - and never in its exit code. Related, and cheaper:
where a name can simply be **made to work** rather than guarded, make it work. No pre-call guard can
fix and retry a failed command; it can only refuse it before it starts.

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

- Map each rung to your stack's real commands (your compiler, your test runner, your build, your
  run/launch command).
- If your CI already gates merges, the local ladder is your *fast feedback* before CI - it should
  be a subset you can run in seconds-to-a-minute, not a duplicate of the full pipeline.
- Drop the journal if your tasks are small; keep it the moment a task spans more than a handful of
  steps or more than one session.
