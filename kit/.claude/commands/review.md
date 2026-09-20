---
description: "Use for a terse, actionable code review of a diff or change - findings with severity, no cheerleading. Triggers: 'review this', 'look over my change', a pre-merge pass."
---

# Code Review

> **GLOBAL DIRECTIVES (anti-bureaucracy):**
> 1. Findings first, ordered by severity. No praise padding, no throat-clearing.
> 2. Every finding is actionable: a concrete fix or a precise question.
> 3. Default scope is the current diff / recently changed files, not the whole repo.

Review a change for correctness and quality. For terse one-line-per-finding output,
use `/caveman-review`; this skill is the fuller pass.

The dimensions below are named for code. If the change is a document, a dataset or a contract, they
map one for one: correctness → do the claims hold and do the numbers reconcile; security → what
leaks or cannot be undone; architecture → does it belong where it was put and does it contradict
something upstream; tests → what would catch this being wrong next time; anti-slop → the generic
list in `docs/PROJECT_SHAPES.md`.

## Usage

```text
/review [optional: file, diff, PR, or topic]
```

- `/review` - review the current diff
- `/review src/payments/` - scope to a path
- `/review correctness only` - restrict the dimensions

## What to check (in order)

1. **Correctness** - logic bugs, off-by-one, wrong conditionals, races, null/None handling,
   error paths, resource leaks, broken invariants.
2. **Security & data safety** - injection, unvalidated input, secrets in code, unsafe
   deserialization, destructive ops without guards, migration safety.
3. **Architecture** *(code layer)* - dependency direction respected (`<ARCH_LAYERS>`); entry points
   stay thin; logic lives in the right layer; no cross-layer leakage.
4. **Tests** - does the change have coverage for the new path and its failure modes? Flag
   missing/weak assertions.
5. **Anti-slop** - the seven greppable patterns in `docs/CODE_QUALITY.md` (the canonical list).
6. **Clarity** - naming, dead code, comment quality (why not what), file-size budget.

## Process

1. Identify the changed surface. Read the diff and enough surrounding code to judge it -
   do not review lines in isolation.
2. Verify claims against the code; never invent a line number or symbol.
3. For each finding emit: `severity` · `file:line` · the problem · a concrete fix.
   Severities: `bug` > `risk` > `arch` > `test` > `nit` > `q`.
4. Confirm or refute your own high-severity findings before reporting them - a plausible
   bug that does not actually reproduce is noise. **A false finding costs as much as a miss and is
   louder**: once a handful of them ship, a real defect is one row among the false ones and the
   whole review stops being read (`docs/VALIDATION.md`). If you cannot reach the thing you are
   judging, the finding is "could not verify", which is a third answer - not a defect.
5. If you find nothing material, say so and name the residual risks (untested path,
   uncovered edge case) rather than padding.

## Output

- Findings grouped by severity, highest first.
- A short "what's solid" line only if it carries information (e.g. "migration is reversible
  and guarded").
- One closing line: the single most important thing to address before merge.
