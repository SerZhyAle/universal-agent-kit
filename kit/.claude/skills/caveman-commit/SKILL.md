---
name: caveman-commit
description: "Use to write a terse Conventional Commit message with no filler. Triggers: 'caveman commit', a quick commit when the change is already understood."
argument-hint: "[context]"
---

# Caveman Commit

> **LOCAL DIRECTIVES:**
> 1. Commit messages in `<ARTIFACT_LANGUAGE>`.
> 2. Generate the message only. Do NOT run `git commit`, stage files, or amend history.
> 3. For breaking changes, security fixes, data migrations, or reverts, include enough
>    context even if it costs more words.

Generate a terse Conventional Commit message with minimal noise and exact intent.

## Usage

```text
/caveman-commit [optional: context]
```

- `/caveman-commit` - infer from the current diff if available
- `/caveman-commit fix retry on network thumbnail` - generate from explicit context

## Process

On invoke with `$ARGUMENTS`:

1. User described the change → use that description.
2. User did not → inspect the current `git diff`/`git status` to infer the message.
3. Subject in Conventional Commits format:
   - `<type>(<scope>): <imperative summary>`
   - `<scope>` optional
   - Prefer `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `chore`, `build`, `ci`,
     `style`, `revert`
4. The subject names the user-visible change, not the mechanism:
   `fix(export): keep page breaks in PDF invoices`, not `fix(export): flush stream before close`.
5. Keep the subject terse: target `<= 50` chars, hard cap `72`, no trailing period.
6. Add a body only when the *why* is not obvious from the subject.
7. Always add a body for: breaking changes, security fixes, data migrations, reverts.
8. Body lines concise, wrap near 72 chars.
9. Attribution - a co-author line, a tool trailer - is a team choice the project's rules file
   states: follow it. It says nothing → ask the user once, write the answer into the rules
   file, then follow it. Never add or strip attribution silently.
10. No filler phrases.

## Output Rules

- Output the commit message as a fenced code block, ready to paste.
- Do not explain the obvious diff.
- Keep the message exact, terse, and technically complete.
