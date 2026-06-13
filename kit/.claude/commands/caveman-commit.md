# Caveman Commit

> **LOCAL DIRECTIVES:**
> 1. Commit messages in English.
> 2. `..` (two dots) — never `...`.
> 3. Generate the message only. Do NOT run `git commit`, stage files, or amend history.
> 4. For breaking changes, security fixes, data migrations, or reverts, include enough
>    context even if it costs more words.

Generate a terse Conventional Commit message with minimal noise and exact intent.

## Usage

```text
/caveman-commit [optional: context]
```

- `/caveman-commit` — infer from the current diff if available
- `/caveman-commit fix retry on network thumbnail` — generate from explicit context

## Process

On invoke with `$ARGUMENTS`:

1. User described the change → use that description.
2. User did not → inspect the current `git diff`/`git status` to infer the message.
3. Subject in Conventional Commits format:
   - `<type>(<scope>): <imperative summary>`
   - `<scope>` optional
   - Prefer `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `chore`, `build`, `ci`,
     `style`, `revert`
4. Keep the subject terse: target `<= 50` chars, hard cap `72`, no trailing period.
5. Add a body only when the *why* is not obvious from the subject.
6. Always add a body for: breaking changes, security fixes, data migrations, reverts.
7. Body lines concise, wrap near 72 chars.
8. No AI attribution, no filler phrases.

## Output Rules

- Output the commit message as a fenced code block, ready to paste.
- Do not explain the obvious diff.
- Keep the message exact, terse, and technically complete.
