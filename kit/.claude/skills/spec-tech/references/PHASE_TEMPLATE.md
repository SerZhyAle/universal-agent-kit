# Tactical phase file template - used by /spec-tech

```markdown
# Phase NN - <Title>

**Strategic spec:** [`../<ID>_<slug>.md`](../<ID>_<slug>.md)
**Tactical index:** [`INDEX.md`](INDEX.md)
**Status:** ⬜ Not started
**Depends on:** Phase NN-M (or "none - foundation phase")
**Steps done:** 0 / N

## Objective
<One sentence: what this phase produces.>

## Prerequisites
- [ ] All "Depends on" phases are ✅ Done.
- [ ] Strategic §6 items blocking this phase are Resolved.
- [ ] Working tree clean or on a feature branch.

## Files touched
| File | New / Modified | Line budget |
|------|:--------------:|------------:|
| `<WORK_ROOT>/<path>/<File>` | New | ≤ <SIZE_BUDGET> |
| `<WORK_ROOT>/<path>/<Existing>` | Modified | ≤ <SIZE_BUDGET> |

> Backup any file over ~`<SIZE_BUDGET>` lines before editing; split anything heading past your
> file-size budget via a helper/extraction step.

## Steps

### Step NN.1 - <imperative title>
**Files:** `path/to/File`
**Depends on:** - start of phase

**Prompt for implementer:**
> <Self-contained imperative, 1-4 sentences. The reader must not need the strategic spec.>

**Verification:**
- File `path/to/File` exists.
- `<symbol declaration>` matches exactly once (declaration, not comment).
- `<expected signature / value>` present.

**Status:** `[ ]` not done

---

### Step NN.2 - <imperative title>
**Files:** ..
**Depends on:** Step NN.1
**Prompt for implementer:** > ..
**Verification:** - ..
**Status:** `[ ]` not done

## Phase done criteria
- [ ] Every `Step NN.*` is `[x] done`.
- [ ] Narrowest meaningful check for this phase passes - pick the lowest sufficient rung from
      `docs/VALIDATION.md` (`<CHECK_CMD>`, a compile / type-check, a targeted test, or `<BUILD_CMD>` only when
      this phase touches packaging, resources, or wiring). Name the actual command here.
- [ ] Grep for `TODO(phase-<NN>)` returns zero hits.
- [ ] The ticket's one changelog entry lists every file in "Files touched" (skip where the project keeps no change log).

## Handoff notes
<Invariants this phase established. Final phase → "See INDEX.md Completion gate.">

## Rollback plan
<Which commits to revert / config to restore. Low-risk → "Revert phase commit(s).">

## Step Log
<Append-only, written by `/spec-dev`, one line per step run:
`- <YYYY-MM-DD> Step <NN>.<n> - expected: <predicates> PASS | actual: <result>`. Never rewrite a line.>
```
