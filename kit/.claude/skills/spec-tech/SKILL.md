---
name: spec-tech
description: "Use to break an approved strategic spec into a phased, verifiable plan where every step ends in a static check. Triggers: 'spec-tech', 'make the plan', 'turn this spec into steps'."
argument-hint: "<ID-or-slug> [--phase NN] [--dry-run]"
---

# Tactical Specification Writer

Break an approved strategic spec into **sequenced, verifiable phases**. Creates
`<PLAN_DIR>/<ID>_<slug>/INDEX.md` + phase files. Language: `<ARTIFACT_LANGUAGE>`, imperative, no rationale
prose (the *why* lives in the strategic spec).

Requires the strategic spec at `Status: Approved` or later (gate table: `docs/SPEC_LIFECYCLE.md`).
A `Draft` is refused, not promoted: it may be a one-line `/park` stub, and planning from a symptom
skips the style and completeness gate `/spec` runs at approval. Abort with
`<ID> is Draft - run /spec <ID> first.` A `Block*` status is a hard abort - resolve first.

## Usage

```text
/spec-tech <ID-or-slug>
/spec-tech <ID-or-slug> --phase <NN>
/spec-tech <ID-or-slug> --dry-run
```

## Directory layout

```text
<PLAN_DIR>/<ID>_<slug>.md            # strategic - owned by /spec
<PLAN_DIR>/<ID>_<slug>/
  INDEX.md
  research/<NN>__<topic>.md          # research artifacts (first-class planning input)
  PHASE_01__<slug>.md
  ..
  PHASE_NN__docs-cleanup.md          # always the final phase
```

Phase slug: kebab-case, ≤ 4 words (`foundations`, `input-dispatch`, `db-migration`).

## Process

**1 - Validate the strategic spec.** Read it. Extract: feature name, tier, priority, goals
(§2), constraints (§3.2), pillars (§5.1), open research items (§6) + their artifact links,
ADRs (§9), criteria (§11).

**2 - Read project context.** Read **every** file in `research/` in full first - a resolved
finding that contradicts the intended approach is a planning input, not a footnote. Then the
repo map, architecture doc, and the actual source for the affected area. Every file path you
reference in a step must exist or be explicitly marked **New**.

**2.5 - Complexity gate (PRIMITIVE check).** Same checklist as `/spec` step 2.5. If ALL
pass: implement directly, no phase files, set status per acceptance (Implemented or
BlockNeedUserTest), report, stop. No `/spec-dev` chain. If ANY fails: continue.

**3 - Design the phase graph.** This is the highest-risk output of the skill: a wrong order
or a missed strategic requirement costs a full `/spec-dev` cycle. Do not write any file
until 3.1-3.4 pass.

**3.1 - Coverage inventory.** Re-read the strategic spec end-to-end plus every research
file. Build a scratch inventory (chat-side, never a file): one line per §2 goal, §5.1
pillar, §3.2 constraint with implementation impact, resolved §6 finding, §9 ADR, §11
criterion. Map every line to ≥ 1 planned phase, or mark it `out-of-scope: <reason>`. An
unmapped line means the phase set is incomplete - fix it before proceeding.

**3.2 - Produces/Consumes topology.** For each candidate phase list two sets: `Produces`
(new or changed artifacts: types, functions, schema, DI bindings, resources, config fields)
and `Consumes` (artifacts it needs - either pre-existing in code, verified in step 2, or
produced by a strictly earlier phase). Validate the topological order: no phase consumes
something a later phase produces. A forward reference means the order is wrong - reorder now.

**3.3 - Ordering heuristics** (refine the 3.2 topology, never override it):
1. Foundations first: data types, interfaces, DI, schema + migration, config/feature flags.
2. Producer before consumer for every new symbol; migration before code reading new fields;
   resources/strings before or with the UI referencing them.
3. User-visible changes last within their area.
4. The final phase is always `PHASE_NN__docs-cleanup.md`: changelog, index regen, and
   user-facing docs only if strategic §8 mandates an update - through `/surfaces`, so every
   surface and authored locale moves in that phase, before the audit checks them.
5. At least one phase per strategic pillar (§5.1); small pillars may fuse.

**3.4 - Real-work filter (anti-bureaucracy).** Every step's primary action must change
source, resources, config, or scripts. Forbidden as steps:
- Edits to `<PLAN_DIR>/**` text - status flips, counters, retitling. Progress tracking is
  `/spec-dev` bookkeeping; plan authoring is this skill's own output - neither is plan
  *content*.
- "Review / sync / align docs" without a concrete file delta outside `<PLAN_DIR>/`.
- Restating or re-verifying a previous step's outcome as a separate step.

Sole exception: the final docs-cleanup phase. A phase where most steps fail this filter is
not a phase - merge the survivors into a real one.

Phase shape: each phase mergeable as a coherent unit; one build-time invariant proving
completion; no half-broken state between steps. Target 3-8 phases. > 10 → split the feature
into multiple specs.

**4 - Write `INDEX.md`** (template below).

**5 - Write each `PHASE_NN__<slug>.md`** (template below). Steps numbered `NN.M`.

**5.5 - Plan self-review (mandatory).** After all phase files exist and before any status
flip, re-read INDEX + every phase against the 3.1 inventory and 3.2 topology:
- Every inventory line maps to a *written* step (not an intended one), or carries its
  `out-of-scope` reason.
- Every name a step consumes - a symbol, a column, a defined term, a section - either exists in the
  workspace today or is created by an earlier step. Check the actual `Files Touched` + prompts, not
  intent.
- Every `Depends on` matches the topology; no step references a later phase's artifact.
- No step violates the 3.4 real-work filter.
- Research findings are reflected. A step contradicting a resolved §6 artifact is a planning
  bug to fix *here*.

Fix findings directly (reorder, rewrite, renumber), re-run the failed check once. Report:
`Plan self-check: PASS - N inventory items mapped, M reorders applied.` Never skip this -
phase-order bugs are the dominant tactical-plan defect.

**6 - Update the strategic spec.** Flip `Status:` to `Tactical`; replace the body of §12 "Next
step" with the tactical-plan link and `/spec-dev <ID>`, so the spec never points at a done step.

**7 - Auto-chain to `/spec-dev`.** If no unchecked Pre-Implementation Blocker in INDEX,
invoke `/spec-dev <ID>`. Otherwise list the blockers and stop.

**Chat output:** `<ID>: N phases. Blockers: [list or none]. -> Running /spec-dev..`

## `INDEX.md` template

The template lives in [`references/INDEX_TEMPLATE.md`](references/INDEX_TEMPLATE.md). Read it before step 4.

## Phase file template

The template lives in [`references/PHASE_TEMPLATE.md`](references/PHASE_TEMPLATE.md). Read it before step 5.

## Constraints

- One step = one atomic, independently committable unit that does not break the build.
- Every Verification must be static (file exists / symbol present / value equality) - never
  "works correctly".
- File > ~`<SIZE_BUDGET>` lines after edit → backup step required. Heading past the size budget →
  refuse; split first.
- The final phase is always the docs-cleanup phase.
- Do not duplicate strategic content - tactical says *what*, not *why*.
- No step's primary action edits `<PLAN_DIR>/**` text (the real-work filter binds every
  step, not just the planning pass), except the final cleanup phase.
- Research artifacts under `research/` are mandatory planning input - read all before step 3
  and list them in INDEX `Research inputs:`.
- If your project has multiple form factors (e.g. portrait/landscape, light/dark, locale
  variants), a step editing one variant must cover its counterpart or note its absence.
