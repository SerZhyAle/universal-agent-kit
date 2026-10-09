---
name: spec-check
description: "Use to audit an implementation against its spec and set the ticket status from reality (Verified/Partial/Broken). Triggers: 'spec-check', 'is this actually implemented', 'audit ticket X'."
argument-hint: "<ID-or-slug> [--strategic | --tactical | --phase NN] [--strict] [--quick]"
---

# Specification Implementation Audit

Audit a spec against the **actual state of the workspace**. Status comes from what the artifacts
and their checks prove, not from a filename or a hope. Auto-detects strategic vs tactical scope.

> No separate audit file is written. Findings go in a compact `## Last Audit` block at the
> bottom of the strategic spec, overwritten each run. Old audit history is intentionally
> discarded. Human sign-off lives elsewhere - in a `## Manual checks` section this skill reads
> and **never overwrites**, so a box a human ticked survives the next audit.

## Usage

```text
/spec-check <ID-or-slug>
/spec-check <ID-or-slug> --strategic
/spec-check <ID-or-slug> --tactical
/spec-check <ID-or-slug> --phase <NN>
/spec-check <ID-or-slug> --strict      # treat WARN as FAIL
/spec-check <ID-or-slug> --quick       # skip grep-heavy invariants
```

## Auto-detection

| Strategic file | Tactical folder | Flag | Mode |
| :---: | :---: | --- | --- |
| exists | exists | none | full - strategic + every phase |
| exists | missing | none | strategic only |
| exists | exists | `--strategic` | strategic only |
| exists | exists | `--tactical` | every phase |
| exists | exists | `--phase NN` | single phase |
| missing | any | any | abort |

## Process

**1 - Locate the spec.** Read `<PLAN_DIR>/<ID>_<slug>.md` (abort if missing). Record whether
`INDEX.md` exists. Apply the auto-detection table.

**2 - Extract the verification contract.**
- Strategic: §2 Goals, §3.2 Constraints, §6 Research items, §8 user-doc text, §11 Criteria.
- Tactical: INDEX Phase Overview / Blockers / Completion Gate; each phase's Files Touched,
  Steps Verification, Done Criteria.

**3 - Run checks.** Record per check: `PASS` / `WARN` / `FAIL` / `MANUAL` / `UNCHECKABLE` /
`EXEMPT`. How these map onto `/prove`'s four verdicts is one table in `docs/VALIDATION.md`
("One vocabulary"). Mechanics:

| Check | How |
| --- | --- |
| File exists | glob the exact path |
| Symbol declared | grep for the declaration - verify the hit is a declaration, not a comment/string |
| No forbidden call | grep the pattern; PASS iff zero hits |
| Schema version | read the schema source, match the expected version |
| Changelog entry | the project keeps no change log → EXEMPT. Else grep this ticket's one entry and confirm it lists the changed files |
| Index up to date | grep the symbol in your code index, if any |
| Dead weight introduced | grep for remnants the change should have removed (orphaned symbols, keep-rules for deleted code, unreferenced resources); WARN per remnant. Cross-check `<PLAN_DIR>/` before calling a zero-ref artifact dead - it may be active-ticket scaffolding |
| User docs | read strategic §8 first. "No changes" → EXEMPT. Else grep the keyword in the user docs - PASS only if present |
| Message formulas | read each message the ticket adds or edits - here the string is the subject. An error says what happened and one next step; an empty state gives the reason and an invitation; a destructive confirmation says what will happen and whether it can be undone. WARN per message off its formula |
| One name per concept | for each thing the new text names, grep the product's strings and user docs (its glossary first, if it keeps one) for a second name of the same thing. WARN per second name, all hits listed |
| Persona pass | trace each new path as each kind of reader it serves; a dead end - no next step, no way back - is WARN. A destructive action inverts the pass: PASS only if the confirmation sits on every path to it and a force flag skips the prompt, never the safety checks; FAIL if any path, forced or not, reaches it past them. What only a real run shows is MANUAL through §11 and `## Manual checks`, as for any human signal |
| Shared boundary | read strategic §3.2. "None" → EXEMPT. Else confirm the contract's version was bumped at its home before the boundary code changed, and the conformance run used the home's copy - FAIL if the code is ahead of its contract; UNCHECKABLE, never PASS, if the home cannot be reached |
| File size vs budget | read the file, count lines, compare to the step budget |
| Step status consistency | parse `[x] done`; cross-check against the Verification predicates |
| Phase status consistency | INDEX row status == phase header status |
| Verification-tag invariant | if status is `BlockNeedUserTest`: grep for `<ID>:` tags - PASS iff ≥ 1 hit. For any other status: PASS iff zero hits - surviving tags are stale (WARN; step 6 deletes them) |
| Open questions closed | a PRIMITIVE spec has no open-questions section by design → EXEMPT. Else locate §6 **by its heading text, never its number**; PASS iff every item is `Resolved`, or the header's `**Carried-to:**` token names a real successor ticket. An item still carrying the template's literal `Open / Resolved` line counts as **unanswered**, not as absent. FAIL otherwise |
| Manual checks | read the `## Manual checks` section; each unticked `[ ]` line is one open MANUAL item. No section and no §11 criterion that needs a human → EXEMPT |

The three reader-facing rows (message formulas, one name, persona pass) are EXEMPT on a ticket no
reader can see: §8 says "No changes" and no phase's Files Touched holds reader-facing text -
strings, help, templates, messages.

**4 - Score.** (Gates are defined once in `docs/SPEC_LIFECYCLE.md`; this is that rule applied.)
- `Verified` - every check is PASS or EXEMPT. Zero FAIL, zero WARN, and **no open MANUAL item**.
  This is the hard half of the two direction tokens (`docs/SPEC_LIFECYCLE.md`): an unhanded open
  §6 item refuses the flip, because a closed ticket leaves the queue and takes its question with it.
- `BlockNeedUserTest` - zero FAIL, UNCHECKABLE and WARN, but ≥ 1 open MANUAL / on-target item. The build
  is sound; a human signal is still outstanding. Do **not** call this Verified and do **not**
  remove verification tags - re-run `/spec-check` once the human closes the item.
- `Partial` - zero FAIL, zero UNCHECKABLE, ≥ 1 WARN. Collapses to `Broken` under `--strict`.
- `Broken` - ≥ 1 FAIL **or ≥ 1 UNCHECKABLE**. A check that could not reach its subject proved
  nothing, so it blocks exactly as a FAIL does - and its action item is never mechanical, because
  what is missing is access, not an edit.

When several fit, the worst wins: `Broken`, then `Partial`, then `BlockNeedUserTest`. An open manual
item never hides a FAIL, an UNCHECKABLE or a WARN.

A MANUAL check can never sit beneath a `Verified`: status comes from reality, and an unclosed
manual signal is reality saying "not proven yet".

**5 - Write the `## Last Audit` block** at the bottom of the strategic spec (overwrite).
Keep it under ~40 lines: PASS counts + FAIL/WARN/UNCHECKABLE action items only. The action items
are exactly what `/spec-fix` consumes.

If a §11 criterion needs a human or a real run and the spec has no `## Manual checks` section yet,
append one (template below), one `[ ]` line per such criterion. Never rewrite an existing section,
never untick a box, never tick one yourself - the human ticks it, with a word on what they saw.

**6 - Update `Status:`.** Full/strategic mode → flip the strategic `Status:` to the score -
except that a `BlockQuestions` or `BlockExternal` status is **kept** while the score is anything
but `Verified`: a block clears only when its condition is removed (`docs/SPEC_LIFECYCLE.md`), and
overwriting it with the score is what lets the audit and `/spec-fix` loop forever. Record the score
in the `## Last Audit` block instead.
Whenever the verdict flips the status **out of** `BlockNeedUserTest`, enforce the tag
invariant: grep all source for `<ID>:` verification tags and delete every matching line
(idempotent if none). This is the only source mutation this skill performs. Tactical-only
mode → update INDEX + audited phase rows only; do not touch the strategic status or tags.

**7 - Finalize.** If the audit removed tags, add those files to the ticket's one changelog entry
(none to add where the project keeps no change log). Never edit a user surface from here: a
user-visible change ran `/surfaces` in its docs-cleanup phase, and the User docs row checks that.

**8 - Auto-chain to `/spec-fix`** if the status this run set is `Partial` or `Broken`. On
`Verified`, no further action. On `BlockNeedUserTest` (sound build, open manual item), stop and
await the human signal - do not chain, do not remove tags. On a kept `BlockQuestions` /
`BlockExternal`, stop - there is nothing mechanical left to try.

**Chat output:** `<ID>: <score>. PASS/WARN/FAIL: N/N/N. Tags removed: N. Top issues: [list].`

## `## Last Audit` - compact template

```markdown
## Last Audit

**Date:** <YYYY-MM-DD>
**Mode:** full | strategic | tactical | phase-<NN>
**Outcome:** Verified | BlockNeedUserTest | Partial | Broken (status kept: <block>, if step 6 kept one)
**Counts:** PASS N · WARN N · FAIL N · UNCHECKABLE N · MANUAL open N · EXEMPT N

### Action items
1. **[FAIL §3.2.2 - Step 02.3]** <one line> - <concrete fix>.
2. **[WARN §2.3]** <one line> - <concrete fix>.
3. **[UNCHECKABLE §3.2]** <what could not be reached> - <what access would let it run>.

<No action items (Verified, BlockNeedUserTest): drop "Action items". Open manual items are counted here and listed in
`## Manual checks`, never copied into this block.>
```

## `## Manual checks` - template (appended once, never overwritten)

```markdown
## Manual checks

- [ ] <signal from §11 that needs a human or a real run>
- [x] <a closed one> - <date>, <what was observed>
```

`Verified` requires every line here ticked, or no section at all. One open `[ ]` holds the ticket at
`BlockNeedUserTest` until a human ticks it and re-runs `/spec-check`.

## Constraints

- Gate the **transition**, not the state: run the open-questions check only when this audit
  actually changes the status. Re-auditing an already-`Verified` ticket must not re-run it, and an
  `Archived` ticket is never gated - it closed a ticket that already passed.
- Never mutate spec content beyond `Status:`, the `## Last Audit` block, and appending a missing
  `## Manual checks` section. The one source mutation allowed is deleting `<ID>:` verification tags
  on a status flip out of `BlockNeedUserTest`.
- Strategic audit is qualitative (keyword overlap for goal coverage); tactical audit is
  strict (static predicates only).
- A grep miss is FAIL. A hit-count mismatch (expected 1, found 3) is WARN with all hits
  listed.
- Never run a build - static analysis only.
- Read-only zones ignored.
- `--quick` skips grep-heavy invariants and annotates the block; it still emits the status
  transition and tag removal.
- Never approve `Verified` while any tactical phase is Broken. Grep hits count only on
  declaration lines, not comments or string literals - except in the message-formula and
  one-name rows, where the string is the subject.
