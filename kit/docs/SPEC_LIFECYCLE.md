# The Spec Lifecycle - tooling-agnostic

This is the methodology behind the `/spec*` skills. It needs no special tooling: a ticket is
one Markdown file, and a status is a line in that file you keep honest. If you later want a
JSONL index, a CLI, or a database behind it, fine - the method does not depend on it.

## Why split strategy from tactics

A spec answers two different questions that get muddled when written together:

- **Strategic (what / why):** the problem, the goals, the constraints, the open questions.
  No class names, no file paths, no signatures. If a reviewer disagrees here, you saved
  yourself an implementation.
- **Tactical (how):** the exact files, symbols, and the *order* to build them, each step
  ending in a check anyone can run. If a step is ambiguous here, the executor stops instead
  of guessing.

Keeping them in separate documents is the single highest-leverage habit in this kit. The
strategic doc is the contract; the tactical doc is the build instructions; the audit checks
the building against the contract.

## The status flow

```
Draft ──► Approved ──► Tactical ──► In Progress ──► Implemented ──► Verified
   │                                                      │
   └─ rough is fine here                                  └─ audit may instead yield:
                                                             Partial  (warnings, no failures)
                                                             Broken   (at least one failure)
```

Plus explicit block states, each entered with a one-line note:

- `BlockNeedUserTest` - built, awaiting a hands-on / manual check.
- `BlockByOtherTask` - depends on another ticket.
- `BlockQuestions` - awaiting a decision from the owner.
- `BlockExternal` - waiting on a library release, hardware, or a third party.

Block states need a defined exit. To clear a `BlockQuestions` ticket: isolate the decisions
blocking the next transition, silently settle any the codebase or prior research already
determines, put only the genuine judgment calls to the owner (offer a researched default first),
record the answers back into the ticket, and advance exactly one level - then stop. Never invent
an owner's answer. The other block states clear the same way: remove the condition, note it, and
advance one level.

Add a reversible terminal status, `Archived`: move a cancelled or superseded ticket's files out
of the active workspace but keep its record, so work stays findable and restorable. Never
hard-delete a record. Archiving is also the last sweep for verification tags - a ticket can be
archived from a non-verified state, so clear any leftover tag (see "Verification tags" below) as
part of archiving, or the "tag exists iff awaiting test" invariant breaks on the cancel path.

The status is the **first** `**Status:**` line in the file. It is true because the code makes
it true, never because the filename or a wish says so.

## The complexity ladder

The gate is not binary - it is a ladder of rungs, and the rule is **pick the lowest rung that
still proves the change**: a typo is `/quick`; a known bug is `/fix`; a small, deterministic
change is a three-section PRIMITIVE spec; anything with real unknowns is the full COMPLEX
pipeline. `/quick` and `/fix` need no spec at all.

To choose between the top two rungs, score the task:

- ≤ 3 existing files change, no new files
- no new public types
- no schema/migration change
- no new dependency-injection wiring
- no new screen/route/destination
- mechanically deterministic - no deferred decisions
- under ~100 lines of delta

**All true → PRIMITIVE:** write a three-section spec (Problem / Approach / Done criteria) and
implement directly. **Any false → COMPLEX:** run the full pipeline. The ladder is what keeps
the ceremony proportional to the work.

## Designing the phase graph (the part that goes wrong)

Phase ordering is where tactical plans fail. Three passes prevent it:

1. **Coverage inventory.** List every goal, pillar, constraint-with-impact, resolved research
   finding, ADR, and criterion. Map each to a phase, or mark it `out-of-scope: <reason>`. An
   unmapped line means the plan is incomplete.
2. **Produces / Consumes topology.** For each phase, list what it produces (new/changed
   artifacts) and what it consumes. No phase may consume what a *later* phase produces. A
   forward reference means the order is wrong - reorder before writing anything.
3. **Real-work filter.** Every step's primary action changes source/resources/config. Steps
   that only edit plan text, "review docs", or restate a previous step are not steps. The one
   exception is the final docs-cleanup phase.

Then a mandatory **self-review**: re-read the written plan against the inventory and the
topology. Every inventory line maps to a *written* step; every consumed symbol greps in the
code or is produced earlier; every dependency matches the topology. Fix in place. This pass
catches the phase-order bug that would otherwise cost a full execution cycle.

## Verifiable steps

Every step ends in a **static** check - file exists, symbol declared, value equals, command
exits 0 - never "works correctly". A step is done only when its check passes *in this run*,
not when you intended it. The executor runs one step, runs its check, and hard-stops on the
first failure or ambiguity rather than guessing forward.

## Verification tags (optional but neat)

When a ticket needs manual testing before it can be called done, insert a temporary log line
at each changed-flow entry point:

```
<LOGGER>("<ID>: <what this code path proves>")
```

The invariant: such a tag exists **iff** the ticket is currently `BlockNeedUserTest`. You
insert them as the last code edits before the final build (so one build validates code +
tags), and the audit deletes them when the ticket leaves that status. Permanent logs never
embed a ticket id. The payoff: during a manual run you grep the log for `<ID>:` and *see*
which paths actually executed. It complements automated tests, it does not replace them - reach
for it only where a test cannot observe which path a manual or on-device run took. Keep each tag a
single greppable line so removal stays mechanical and safe.

## The skills, end to end

```
/research      gather evidence, persist findings           (before anything non-trivial)
/spec          write the strategic what/why                Draft -> Approved
/spec-tech     turn it into a phased, verifiable plan       Approved -> Tactical
/spec-dev      execute one step at a time, check each       Tactical -> Implemented / BlockNeedUserTest
/spec-check    audit the build against the spec             -> Verified / Partial / Broken
/spec-fix      apply the audit's action items, re-audit     Partial / Broken -> (re-check)
/verify        run it and observe, when behaviour matters   (read-only on status)
```

`/quick` and `/fix` sit *below* this pipeline for changes too small to deserve it. `/ui-clarify`
sits *before* it whenever a user-facing decision is unresolved.

## Status gates (the one rule)

Every skill reads and writes the same ticket status, so the gates live here once. Each skill
**requires** an entry status, **produces** an exit status, and **auto-chains** to the next skill
unless a stop condition fires. This table is the single source of truth - a skill restates only
its own row, and `VALIDATION.md` and the skill files defer to it rather than redefining the flow.

| Skill | Requires | Produces | Auto-chains to | Stops instead when |
| --- | --- | --- | --- | --- |
| `/research` | any | no status change | the caller | - |
| `/spec` | none (allocates an id) | `Approved` (complex), or `Implemented` / `BlockNeedUserTest` (primitive, implemented in place) | `/spec-tech` (complex only; a primitive stops after implementing) | a required research item is Open |
| `/spec-tech` | `Approved` or later | `Tactical` | `/spec-dev` | an unchecked pre-implementation blocker remains |
| `/spec-dev` | `Tactical` / `In Progress` | `Implemented` or `BlockNeedUserTest` | `/spec-check` | ambiguity, a failed check, or a `Block*` condition |
| `/spec-check` | `Implemented` or later | `Verified` / `Partial` / `Broken` / `BlockNeedUserTest` | `/spec-fix` (only if `Partial`/`Broken`) | an open manual check holds at `BlockNeedUserTest`; an unhanded open §6 question refuses `Verified` |
| `/spec-fix` | `Partial` / `Broken` | re-runs `/spec-check` | `/spec-check` | a fix needs a decision the audit cannot supply |
| `/verify` | any | no status change | - | - |

Three rules bind the whole table:

- **Auto-chain by default; stop only at a real decision.** The pipeline flows on its own and
  pauses only at the encoded conditions above - an open required question, an unchecked blocker,
  an ambiguity. It does **not** wait for a sign-off at every stage; that would be bureaucracy, not
  safety. `/spec` records its own `Approved` flip and continues. To review between stages, run the
  skills individually or pass `--dry-run`.
- **`Verified` means nothing is left open.** A ticket reaches `Verified` only when every check is
  PASS or EXEMPT - zero FAIL, zero WARN, and **no open MANUAL item**. An unresolved manual /
  on-target signal keeps the ticket at `BlockNeedUserTest` (or `Partial`) until a human closes it
  and a re-audit turns it green. Status comes from reality, so an open manual check can never sit
  beneath a `Verified`.
- **Entry precondition for the verification states.** A ticket may enter `BlockNeedUserTest` or
  `Implemented` only when its headline user-visible behaviour already works end-to-end. Created
  classes, wired contracts, and a passing compile are milestones, not deliverables - never invite a
  human to test while the advertised action still only logs, shows a placeholder, or no-ops. That
  wastes their time and corrupts the meaning of the verification states.
- **Two branches leave the straight line, and the rows above encode them.** A *primitive* `/spec`
  (the complexity gate) implements without a tactical plan and stops at `Implemented` or
  `BlockNeedUserTest` - it never enters `/spec-tech`. A sound build with an unresolved manual check
  produces `BlockNeedUserTest`, not `Verified`. Everything else follows the linear flow.

## Two literal tokens: direction, and the question that leaves with a closed ticket

A ticket's prose about its neighbours cannot be read by a machine, and a closed ticket takes its
unanswered questions with it. Two literal tokens fix both, and they are the only place in this
lifecycle where a field exists for a *reader that is not human*.

Put them in the ticket's header block, next to `**Status:**`, and make both mandatory - `none` is a
value, an absent line is not:

```
**Blocked-by:** <ID>[, <ID>..] | none
**Carried-to:** <ID> | none
```

**Why a token and not the prose.** A "related tickets" section names blockers, successors,
consumers and neighbours in one breath, and it is equally happy to *deny* a relationship. Measured
on the reference corpus: **98 spec files yield a ticket id in that section against 15 that carry a
real directional line**, and of the lines containing the word "blocks", most use it to say "does not
block". A scraper reading ids out of that prose makes a producer look blocked by its own consumers.
**An id in prose is a mention; an id in the token is a claim.** Keep the prose - a human reads it -
but never let a skill route on it.

**Why `Carried-to` exists at all.** Closing a ticket requires every open question in §6 to be
answered, or explicitly handed to a named successor. Measured on the same corpus: **134 of 1 506
closed tickets carried at least one still-open research item - 372 items in all, 8.9% of every
closure.** Nothing breaks and nothing fails; the question is simply gone. The successor is an
ordinary ticket, so it reappears in the queue on its own - which is why no separate registry of
unanswered questions is needed, and why any such registry would be a second source of truth.

**Say which one is actually enforced, because they are usually not enforced alike.** In this kit:

- `Carried-to` is a **hard gate at closure** - `/spec-check` refuses `Verified` while §6 holds an
  unhanded `Open` item.
- `Blocked-by` is a **soft exclusion at selection** - nothing refuses the write; `/backlog` simply
  skips the ticket while its blocker is unresolved.

Both designs are legitimate; the costs differ. Claiming both are gated is what is not.

**Four mechanics decide whether such a gate does anything at all**, and every one of them was
learned by watching a gate that stayed green while enforcing nothing:

1. **Gate the transition, not the state**, and only on an actual change. Re-writing a record that is
   already closed must not re-run the gate.
2. **Do not gate the archive transition.** It closes a ticket that already passed, and blocking
   cleanup makes tidying harder than leaving the mess.
3. **An unfilled template placeholder counts as unanswered.** A ticket still carrying the template's
   literal `Open / Resolved` line has resolved nothing; treating the placeholder as absent lets a
   whole class through.
4. **Locate a section by its heading text, never by its number**, and **wire the gate into every
   path that can close a ticket.** Numbers shift the moment a template gains a section, and the gate
   then reads the wrong part of every older file while its verdict stays green. A gate wired into
   one of several equivalent closing paths guards the path used least - in the reference case it sat
   on the general update command while the canonical closure ran through a different script that
   enforced nothing, for weeks, almost never firing.

## Draining BlockNeedUserTest

The lifecycle accumulates human-gated tickets by design: every ticket whose headline behaviour
needs a real run parks at `BlockNeedUserTest` until a human closes it. Left alone they pile up, so
sweep them in a batch rather than one interruption at a time:

1. Group every ticket currently at `BlockNeedUserTest`.
2. For each, run the recorded manual check - its verification tags (grep `<ID>:`) say exactly which
   paths to exercise on the real run.
3. Re-audit the batch with `/spec-check`: the ones whose manual signal is now closed flip to
   `Verified` and their tags are removed in the same pass; the rest stay blocked with a note.

Keep it a periodic sweep, not a per-ticket prompt - deferring the human gate to one batch is the
whole reason the block state exists. A lean `/sweep` command (or a filter over `<PLAN_DIR>/`) is
enough; no new status model is needed.

## Adapting it

- Replace `<ID>` with whatever id scheme you like (`T0042`, `JIRA-123`, a date-slug).
- Replace `<PLAN_DIR>` with your docs location.
- If you do not want block states, drop them - the linear flow still works. `Archived` is
  optional in the same way; without it, just stop touching a dead ticket and leave its record.
- The two direction tokens earn their place only where something *machine-reads* the tickets - an
  unattended drainer, a status report, a dependency view. If you read every ticket by hand, keep the
  prose and drop the tokens; if you later automate, add them before the scraper, not after.
- If your team already has tickets in an external tracker, keep the *file* as the spec and
  link the tracker id; the discipline is in the document, not the tool.
- If you *do* build tooling around this (a ledger, a CLI, a status command), make the
  consequential transitions gates that **refuse** when their preconditions are missing - a
  promotion that cannot fire while a required question is open, a block that cannot be entered
  without a recorded reason - rather than labels a reviewer must remember. The discipline works
  by hand; tooling just makes it harder to skip.
