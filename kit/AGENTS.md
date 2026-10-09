# AGENTS.md - rules for the AI agent in `<PROJECT_NAME>`

> The project's one rules file (`CLAUDE.md` imports it for Claude Code). Fill every placeholder
> (list and worked values: `docs/REPLACES.md`); the **code layer** ones (`<ARCH_LAYERS>`, `<BUILD_CMD>`,
> `<TEST_CMD>`, `<LINT_CMD>`, `<RUN_CMD>`, `<LOGGER>`) only if the project builds or runs - otherwise
> delete the rules that use them. Delete any rule that does not apply; why each exists is in its doc.

## 1. Communication
- **Chat**: `<CHAT_LANGUAGE>`. **Artifacts** - files, code, docs, logs, commits: `<ARTIFACT_LANGUAGE>`.
- **Tone**: dry, concise, plain. No filler, no cheerleading, no trailing summary of the change.
- **Ask if ambiguous - but triage first.** An external convention settles it → research and
  recommend. The project's own structure settles it → state it as a consequence, not a choice. Ask
  only about scope, taste with no anchor, and irreversible actions; else pick the default, say so.

## 2. Autonomy (anti-bureaucracy)
- Do **not** ask permission to read, search, build, run checks, or query the project. Do it, report.
- Flag real blockers at the start, not after burning a turn.
- Fix minor, non-structural issues silently; surface only what changes behaviour, data or structure.
- A mechanical invariant hard-stops; a judgement call only informs. Hard-blocking on heuristics
  breeds bypasses. A destructive change whose plan already encodes the safeguards needs no invented
  confirmation gate - caution alone is not a blocker.
- **Park, don't chase.** A real out-of-scope problem bigger than a one-line fix → `/park` it, report
  one line, return to the task. Fix trivial ones inline; drop cosmetic nitpicks.
- **Argue once, then obey.** Object once, concisely, with the reason; then do what the user decides.
- Prefer doing the work over describing the work.

## 3. Research order (never guess)
Stop as soon as a source answers: (1) the map, `<INDEX_DOC>`; (2) the ticket under `<PLAN_DIR>/`;
(3) the material itself, located through the index or a search **before** reading whole trees;
(4) external sources, when the answer is version-specific or someone else's.
- Never invent a path, a name or an interface; anything you state, you have verified. A large
  project keeps a queryable index, queried before searching and regenerated after changes
  (`docs/RESEARCH_INDEX.md`).
- The working tree, not the history, says what is done now. History answers "how did we get here".
- A name is not evidence of behaviour: confirm a live use site; a mention in a comment is a hit.

## 4. Skills
- `/quick` - trivial edit (typo, one constant, one string). No spec; only the narrowest check.
- `/fix` - narrow defect with a known-enough cause. Local validation only.
- `/park` - capture an out-of-scope finding as a ticket stub and return to the task.
- `/research` - investigate before any non-trivial change.
- `/spec` - strategic *what/why* (or `/spec <ID>` to expand a parked Draft); `/spec-tech` - the
  phased plan; `/spec-dev` - execute it; `/spec-check` - audit and set status; `/spec-fix` - apply
  the audit's mechanical items; `/spec-all` - the whole pipeline for one ticket.
- `/backlog` - drain the queue unattended; human-gated tickets go to one end-of-run report.
- `/ui-clarify` - resolve reader-facing ambiguity before building.
- `/prove` - run it, observe, report PASS, DEFECT, COULD NOT VERIFY or NOT APPLICABLE with evidence.
- `/critique`, `/caveman-review` - review a change; `/git` - branches and commits; `/caveman`,
  `/caveman-commit` - brevity; `/surfaces` - every place a user-visible change shows, in one table.

Take the lowest rung that holds the change - `/quick`, `/fix`, `/spec` - and say which rung and what
forced it up. Delete the lines for skills you did not copy. This list routes nothing by itself: the
cheapest tier goes unchosen unless something picks it at the moment of decision, and a routing hook
helps only the population that passes through its event - count that first (`docs/HOOKS.md`).

## 5. Tickets
- One ticket = one file `<PLAN_DIR>/<ID>_<slug>.md`, `<ID>` allocated by `<ID_SCHEME>`. Its status
  is the first `**Status:**` line, true because the work makes it so - never the filename.
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

## 6. Verification tags (code layer)
A temporary `<LOGGER>("<ID>: <what this proves>")` line may exist **iff** ticket `<ID>` is at
`BlockNeedUserTest`: inserted at each changed-flow entry point on entering it, all removed on leaving
it. Permanent logs never carry a ticket id. Delete this rule if your artifacts produce no trace you
can grep (`docs/SPEC_LIFECYCLE.md`, "Verification tags").

## 7. Structure & checks
- **Work root**: `<WORK_ROOT>`. **Scratch**: `<SCRATCH_DIR>` (kept out of version control, if any).
- **The check that proves a change**: `<CHECK_CMD>` - the one placeholder nobody may leave empty. "We
  have no checks" is almost always false (`docs/PROJECT_SHAPES.md`). A check command you did not
  find is never invented: ask once, then write the answer here.
- **Code layer**: build `<BUILD_CMD>`, test `<TEST_CMD>`, lint `<LINT_CMD>`, run `<RUN_CMD>`.
  Structure `<ARCH_LAYERS>` - respect the dependency direction. Logging via `<LOGGER>` only.
- A slow check runs in the background, but one exclusive resource (a device, an output directory, a
  licence seat, a lock) serializes: never two runs that contend for it.

## 8. Strict rules
1. No writes to the project root. Scratch and backups go to `<SCRATCH_DIR>/`.
2. Size budget ~`<SIZE_BUDGET>` lines per file; past it, split along a seam that means something.
3. Entry points stay thin - a handler, a template, a cover sheet wires and delegates.
4. Read-only zones `<READONLY_ZONES>` are never modified (reading them is fine).
5. Before a large edit to a file over ~`<SIZE_BUDGET>` lines, take a restore point: a copy in
   `<SCRATCH_DIR>/`. Without version control, that copy is also how you see what changed.
6. Follow the project's existing naming convention consistently.
7. Resolve the warnings the checks raise in files you touch.
8. Read existing comments, notes and instructions in the area first; treat them as intent.
9. Comments explain **why**, never what, in `<ARTIFACT_LANGUAGE>`; only for non-obvious logic,
   handled edge cases, workarounds, invariants. Remove stale ones.
10. Resolve reader-facing ambiguity before building (`/ui-clarify`).
11. **An override that narrows a shared default disables the mechanism silently** - a shorter list is
    a valid list, so nothing goes red. Every narrowing override carries a recorded reason
    (`docs/CODE_QUALITY.md`, "Structural rules").

## 9. Anti-slop (write clean from the start)
Forbidden, and a reviewer flags them (full lists: `docs/PROJECT_SHAPES.md`, `docs/CODE_QUALITY.md`):
- **Any artifact**: text restating its heading; a number with no source; a value typed where a
  named one exists; a shipped stub (a `TBD` in a finished document); dead weight kept to be polite.
- **Code layer**: comments restating the line; empty or log-only catches; lifecycle-unsafe async or
  global mutable scope; `print`-style logging in shipped code; a `TODO()` left in.
- Adopting a rule on a project that already breaks it: gate **new** violations against a ratcheting
  baseline. A gate that keeps catching one defect means: close the source in the skill that emits it.
- **A point fix on a shared contract is half a fix** - sweep every site of that contract in the same
  ticket. **What another project reads has one home, and it changes first** (`docs/CODE_QUALITY.md`).
- A *new* rule, gate, skill or agent: author it against an observed failure, name the excuse it
  closes, give it a trigger-first `description` (`docs/AUTHORING.md`).

## 10. Post-change discipline
- Record `expected: X | actual: Y` for every check you run.
- No completion claim without fresh evidence. "Should work", "probably passes", "seems fixed" mean
  the proving command has not run - run it, read the exit code, then state the result. A subagent's
  "it passed" is narration; re-run it yourself.
- A check has **four answers** - pass, defect, could not verify, not applicable - and a fresh *could
  not verify* blocks exactly as a defect does. Validate the instrument before trusting an impossible
  reading. One vocabulary across the skills: `docs/VALIDATION.md`.
- Done = the headline user-visible behaviour works end to end; created modules and a passing compile
  are milestones. Never invite a manual check while the headline action still no-ops.
- One change-log entry per ticket (if the project keeps a change log); regenerate any index once per
  change, not per edit.
- A check only a human can run has not happened yet: no failures plus one unticked manual line is
  "needs a human pass", not "verified".
- New user-visible capability → every surface and every **authored** locale in the same change
  (`/surfaces`); the rest of the declared locales fan out at a release boundary where one exists.
- Re-run the narrowest meaningful check before declaring done; the ladder is in `docs/VALIDATION.md`.
- **Before anything irreversible** - a release, a publication, a filing, a send - take a written
  verdict that names what it judged; no verdict is not a pass. Generate, commit (or copy), then ship.

## 11. Memory
- At session start, read `memory/MEMORY.md` and open the entries that look relevant (Claude Code
  imports it through `CLAUDE.md`). It is the committed, team-shared layer; personal preferences go to
  the runtime's own per-user memory - never the same fact in both.
- Four entry types: `user`, `feedback` (corrections **and** confirmations), `project`, `reference`.
  Never memorize what the files, the history or this file already say. Verify a remembered path or
  name before acting on it. Discipline: `docs/AGENT_MEMORY.md`.

## 12. Cost & several agents at once
- Work inline by default; spawn a subagent for parallelism, evidence isolation or a fresh context.
  Offload raw artifacts to `<SCRATCH_DIR>/` and pass paths.
- Gate a fan-out: estimate count and cost, a small ceiling, an explicit GO above it,
  find-then-verify, never a silent resume of a killed run.
- Route mechanical leaf work to a cheap tier and judgement to a strong one; name the tier at every
  spawn - an unpinned spawn takes the most expensive model.
- Never fire-and-forget a verdict, never poll for one: wait on a signal or a marker file.
- Parallel readers are free; parallel writers need isolation, and disjoint files are not it. A
  shared resource takes a lock that queues, held only around the edit.
- An unattended run loops the **process**, not the session: each item starts in a fresh one.
- Spend: `docs/COST.md`. Several agents: `docs/PARALLEL.md`.
