---
description: "Use for a terse code review - one line per finding, no preamble. Triggers: 'caveman review', a blunt fast pass over a diff."
---

# Caveman Review

> **LOCAL DIRECTIVES:**
> 1. Keep the review in the chat language unless the user asks for paste-ready English PR
>    comments.
> 2. Findings first. No throat-clearing, no praise padding.
> 3. Use fuller prose when a one-line comment would hide important security, architectural,
>    or destructive-risk context.

Produce terse, actionable code-review findings.

## Usage

```text
/caveman-review [optional: file, diff, or topic]
```

- `/caveman-review` - review the current diff or provided context
- `/caveman-review PaymentService` - focus on one file or symbol

## Process

On invoke with `$ARGUMENTS`:

1. Review at the normal bar: bugs, risks, regressions, missing tests first.
2. Output findings before any summary.
3. Prefer one line per finding when clarity is preserved.
4. Finding format:
   - `<file>:L<line>: bug: <problem>. <fix>.`
   - `<file>:L<line>: risk: <problem>. <fix>.`
   - `<file>:L<line>: nit: <problem>. <fix>.`
   - `<file>:L<line>: q: <question>.`
5. Keep exact symbols, file names, line numbers, commands, APIs, and error strings unchanged.
6. No findings → say so explicitly; mention residual test/validation gaps briefly.
7. Security-sensitive or architecturally non-trivial issue → switch to a short paragraph
   instead of forcing one-line compression.

## Output Rules

- No filler. No generic praise.
- No vague advice like "consider refactoring" without a concrete direction.
- Findings must stay actionable and technically exact.
