# AGENTS.md - rules for the AI agent in `user-service`

> **An excerpt**, filled for the imaginary `user-service` of this folder: sections 1, 5 and 7 in
> full, and the lines of section 8 that carry a setting. The other sections read as the kit ships
> them, minus any rule that does not apply. The values are the "Software" column of
> `docs/REPLACES.md`, with its Node.js column for the code layer. `<ID>` and `<slug>` in section 5
> stay as they are: they are filled per ticket, never at merge time.

## 1. Communication
- **Chat**: English. **Artifacts** - files, code, docs, logs, commits: English.
- **Tone**: dry, concise, plain. No filler, no cheerleading, no trailing summary of the change.
- **Ask if ambiguous - but triage first.** An external convention settles it → research and
  recommend. The project's own structure settles it → state it as a consequence, not a choice. Ask
  only about scope, taste with no anchor, and irreversible actions; else pick the default, say so.

## 5. Tickets
- One ticket = one file `PLAN/<ID>_<slug>.md`, `<ID>` allocated as `T` plus the next free
  four-digit number (`T0042`). Its status is the first `**Status:**` line, true because the work
  makes it so - never the filename.
- Lifecycle: `Draft → Approved → Tactical → In Progress → Implemented → Verified`; an audit may
  yield `Partial` or `Broken`. Block states - `BlockNeedUserTest`, `BlockByOtherTask`,
  `BlockQuestions`, `BlockExternal` - are entered with a one-line note and kept until their
  condition is removed. `Archived` is the reversible end for a cancelled ticket.
- Two mandatory header tokens: `**Blocked-by:**` (read by `/backlog`) and `**Carried-to:**` (read by
  `/spec-check` before `Verified`). `none` is a value; an absent line is not. An id in prose is a
  mention, an id in the token is a claim.
- A check only a human can make is a `[ ]` line in the ticket's `## Manual checks` section; the
  human ticks it, no audit overwrites it.
- No time/effort estimates. Lists over tables (tables for 3+ columns), one idea per bullet, no
  decorative pseudographics, no section summaries. Full flow and gates: `docs/SPEC_LIFECYCLE.md`.

## 7. Structure & checks
- **Work root**: `src`. **Scratch**: `tmp` (kept out of version control, if any).
- **The check that proves a change**: `npm test` - the one placeholder nobody may leave empty. "We
  have no checks" is almost always false (`docs/PROJECT_SHAPES.md`). A check command you did not
  find is never invented: ask once, then write the answer here.
- **Code layer**: build `npm run build`, test `npm test`, lint `npm run lint`, run `npm run dev`.
  Structure `page -> widget -> api` - respect the dependency direction. Logging via `logger.info`
  only.
- A slow check runs in the background, but one exclusive resource (a device, an output directory, a
  licence seat, a lock) serializes: never two runs that contend for it.

## 8. Strict rules
1. No writes to the project root. Scratch and backups go to `tmp/`.
2. Size budget ~500 lines per file; past it, split along a seam that means something.
4. Read-only zones `dist, node_modules` are never modified (reading them is fine).
5. Before a large edit to a file over ~500 lines, take a restore point: a copy in
   `tmp/`. Without version control, that copy is also how you see what changed.
9. Comments explain **why**, never what, in English; only for non-obvious logic,
   handled edge cases, workarounds, invariants. Remove stale ones.
