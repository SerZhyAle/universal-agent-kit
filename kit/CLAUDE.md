# CLAUDE.md - Rules for the AI assistant in `<PROJECT_NAME>`

> Project-rules template. Fill every `<PLACEHOLDER>`. Delete rules that do not apply to your
> project. These instructions override the assistant's default behaviour.
>
> **Two tiers of placeholder.** The first nine apply to any project with files, work items and
> checks: `<PROJECT_NAME>`, `<CHAT_LANGUAGE>`, `<INDEX_DOC>`, `<WORK_ROOT>`, `<CHECK_CMD>`,
> `<PLAN_DIR>`, `<SCRATCH_DIR>`, `<SIZE_BUDGET>`, `<READONLY_ZONES>`, `<ID>`. The rest -
> `<ARCH_LAYERS>`, `<BUILD_CMD>`, `<TEST_CMD>`, `<LINT_CMD>`, `<RUN_CMD>`, `<LOGGER>` - are the
> **code layer**: fill them if your project compiles or runs, delete the rules that use them if it
> does not. `docs/PROJECT_SHAPES.md` translates every noun below into data, writing, legal and
> operations work, and says which rules to delete outright.

## 1. Communication & Style
- **Chat**: `<CHAT_LANGUAGE>`. **Artifacts** - files, code, docs, logs, commits: English.
- **Tone**: dry, concise, technical. No filler, no cheerleading, no trailing summaries the
  user can read from the diff.
- **Ask if ambiguous** - but triage first. If an external convention settles it (naming,
  structure, grouping), research it and recommend; if the project's own structure or
  contracts settle it, state it as a derived consequence, not a choice. Reserve real
  questions for scope, taste with no external anchor, and irreversible/destructive
  actions. Pick the obvious default and state it; do not manufacture choices.

## 2. Autonomy (anti-bureaucracy)
- Do **not** ask permission to read, search, build, run checks, or query the project. Just do
  it and report.
- Flag real blockers at the start, not after burning a turn.
- Fix minor, non-structural issues silently. Surface only decisions that change behaviour,
  data, or structure.
- Split guards by what they check: a mechanical invariant (objectively true/false)
  hard-stops; a judgment call only informs - surface a graded risk signal and leave
  go/no-go to yourself. Hard-blocking on heuristics breeds bypasses. A destructive change
  is not automatically a stop-and-ask: if the plan already encodes the safeguards, do not
  invent a confirmation gate. Caution alone is not a blocker.
- Park, don't chase. Hitting a real but out-of-scope problem (more than a one-line fix,
  needs its own look) - record it as a stub via `/park`, report it in one line, and return
  to the task. Never switch the active task to chase a parked finding; fix trivial
  out-of-scope issues inline; drop cosmetic nitpicks.
- Argue once, then obey. If an instruction looks wrong, say so once - concise, with the
  reason - then do what the user decides. Do not relitigate a settled call; do not silently
  comply when you hold a real objection.
- Prefer doing the work over describing the work.

## 3. Research Order (never guess)
Read in this order; stop as soon as a source answers:
1. The map / index (`<INDEX_DOC>`, e.g. `README.md`, an architecture doc, a data dictionary, a
   table of contents, a matter index).
2. The relevant spec/plan under `<PLAN_DIR>/`.
3. The material itself - locate what you need through your index or a search **before** reading
   whole trees.
4. External sources (official docs, changelogs, the authoritative register) when the answer is
   version-specific or belongs to someone else's system.

For a large project, maintain a queryable index of your material: query it before searching, and
regenerate it after you change things. Never invent a path, a name, or an interface - if you state
one, you have verified it. See `docs/RESEARCH_INDEX.md`.

- The working tree, not the history, is the authority for what is currently done.
  `git log`/`blame`/`diff` answer "how did we get here", not "what is true now", and
  mislead when one file carries several concurrent tasks. Reconcile in-progress work by
  reading the live files, then correct the trackers - never infer present state from a diff.
- A name is not evidence of behaviour. Before reasoning about what a flag, constant, term or key
  does, confirm a live use site - a mention in a comment or a doc is a hit, not a usage.

## 4. Skill Routing (slash commands)
- `/quick` - trivial edit (typo, one constant, one string). No spec, no check gate.
- `/fix` - narrow defect or behaviour fix. Local validation only.
- `/park` - capture an out-of-scope finding as a stub and return to the current task.
- `/research` - investigate before any non-trivial change.
- `/spec` - write the strategic *what/why* for a change.
- `/spec-tech` - break an approved spec into a phased, verifiable plan.
- `/spec-dev` - execute a tactical plan step by step.
- `/spec-check` - audit the result against the spec; set status.
- `/spec-fix` - apply the audit's mechanical action items, then re-audit.
- `/spec-all` - run the whole pipeline end to end (research → spec → plan → execute → audit).
- `/backlog` - drain the backlog unattended: pick the highest-priority eligible ticket, run
  the pipeline, repeat; defer human-gated tickets to one end-of-run report.
- `/ui-clarify` - resolve reader-facing or user-facing ambiguity before building.
- `/verify` - run it, observe, report PASS/FAIL with evidence.
- `/git` - branch model, staging, commit grouping.
- `/review`, `/caveman`, `/caveman-commit`, `/caveman-review`.

**This list routes nothing on its own, and the obvious fix for that does not work either.** The
measurement that starts the story: on a project shipping exactly this ladder, **434 slash-command
invocations in a month, of which `/quick` 0 and `/fix` 2, against 150** for the pipeline commands -
the cheapest tier was never once chosen. The obvious remedy is to nudge at the moment routing is
decided, which is when the human types, so a prompt-submit advisory was built. **Its measured reach
was zero** (2026-09-20): not one of the owner's 17 free-text prompts in the window matched it,
because entering the pipeline means typing `/` and the hook skips slash prompts by design - and
**69% of pipeline entries (64 of 93) were headless processes**, where a prompt-submit event does not
exist at all. So ask both questions before wiring anything to an event: **is this where the decision
happens**, and **how many of the occurrences I care about pass through it**. An inert hook reads, in
every later audit, exactly like a rule nobody needed. Where a queue or a driver enters the pipeline,
the tier is picked **by the driver as it picks the item**; a prompt-submit nudge covers only what a
human still types by hand, and is worth having only for that population. Keep it advisory and
**always exit 0**. Which verdict a hook should return, what it owes when it errs, and the inventory
that keeps it from being invisible: `docs/HOOKS.md`.

## 5. Spec / Plan tickets
- One ticket = one Markdown file `<PLAN_DIR>/<ID>_<slug>.md`, where `<ID>` is e.g. `T0042`.
- Status header is the first `**Status:**` line in the file; keep it accurate by hand.
- Lifecycle: `Draft -> Approved -> Tactical -> In Progress -> Implemented -> Verified`
  (plus `Partial` / `Broken` from an audit, and explicit `Block*` states).
- Status comes from reality (the artifacts + the checks), never inferred from the filename.
- Two mandatory header tokens carry what a *skill* must act on: `**Blocked-by:**` (read by
  `/backlog`) and `**Carried-to:**` (read by `/spec-check` before it grants `Verified`). `none` is
  a value; an absent line is not. Never infer either from the ticket's prose about related tickets
  - an id in prose is a mention, an id in the token is a claim.
- See `docs/SPEC_LIFECYCLE.md` for the full flow.
- No time/effort estimates in spec files.
- Spec style: lists over tables (tables only for 3+ columns); one idea per bullet; no
  decorative pseudographics in prose (the status legend and the lifecycle's own flow diagram
  are the documented exceptions); no section summaries.

## 6. Verification tags (optional, powerful)
- A temporary debug line `<LOGGER>("<ID>: <what this proves>")` may exist in the work
  **iff** ticket `<ID>` is currently awaiting a manual check (`BlockNeedUserTest`).
- Insert one at each changed-flow entry point when the ticket enters that status; remove
  every one when it leaves. Permanent logs must never embed a ticket id.
- Code layer, mostly: this needs an execution trace you can grep. Delete the rule if your
  artifacts do not produce one.

## 7. Project structure & checks
- **Work root**: `<WORK_ROOT>` - where the project's real material lives. **Scratch**:
  `<SCRATCH_DIR>` (ignored by version control).
- **The check that proves a change**: `<CHECK_CMD>`. This is the one command every project must
  have and the one placeholder nobody may leave empty - if you think you have no mechanical check,
  read `docs/PROJECT_SHAPES.md` before you believe it.
- **Code layer**: **Build**: `<BUILD_CMD>`. **Test**: `<TEST_CMD>`. **Lint**: `<LINT_CMD>`.
  **Run**: `<RUN_CMD>`. **Structure**: `<ARCH_LAYERS>` - respect the dependency direction strictly.
  **Logging**: `<LOGGER>` only (no ad-hoc print/console logging in shipped code).
- A slow check runs in the background - do not block the turn on it. But a single exclusive
  resource (one device, one output directory, one licence seat, one lock) serializes: never launch
  two runs that contend for it.

## 8. Strict rules
1. No writes to the project root. Scratch/backups go to `<SCRATCH_DIR>/`.
2. Size budget: ~`<SIZE_BUDGET>` lines per file. Past it, split along a seam that means something.
3. Keep entry points thin - a controller, a route handler, a template, a cover sheet wires and
   delegates; it does not hold the substance.
4. Read-only zones: `<READONLY_ZONES>` - never modify.
5. Back up any file over ~`<SIZE_BUDGET>` lines to `<SCRATCH_DIR>/` before a large edit.
6. Naming: follow the project's existing convention consistently.
7. Resolve warnings the checks raise in files you touch.
8. Read existing comments, notes and instructions in the area before editing; treat them as intent.
9. Comment discipline: English; explain **why**, not what; only for non-obvious logic,
   handled edge cases, workarounds, or invariants the artifact cannot express. Remove stale
   comments.
10. Resolve reader-facing ambiguity (placement, wording, fallback) before building - see
    `/ui-clarify`.
11. **An override that NARROWS a shipped default disables the mechanism, silently.** Where this
    project's config merges over a shared layer's defaults, the two directions are not
    symmetrical: widening a list adds cases the mechanism then handles, while narrowing one removes
    cases it was counting on - and nothing goes red, because a shorter list is a valid list.
    Measured 2026-09-20: a profile declared two of the six outcomes its shared library counts as
    "this run made no progress", and **52 of 54** stalled runs carried one of the four it had left
    out, so the idle counter never advanced and the queue re-issued one ticket **five times in a
    row**. Any narrowing override carries a recorded reason, or it is a defect waiting for a quiet
    week.

## 9. Anti-slop (write clean from the start)
Forbidden, and a reviewer must flag them - the code list is in `docs/CODE_QUALITY.md`, the generic
one in `docs/PROJECT_SHAPES.md`:
- Trivial comments restating the adjacent line; text that restates its own heading.
- Empty `catch {}` or broad catches that only log without recovery/safe-default.
- Hardcoded values where the project has a token/constant/theme attribute; a number with no source.
- Lifecycle-unsafe async collection / global mutable scope where a scoped one exists.
- Non-facade logging (`print`, `console.log`, `System.out`) in shipped code.
- Shipped stubs (`TODO()`, `throw NotImplementedError`, a `TBD` left in a finished document) on a
  live path.
- Dead weight: orphaned modules, resources, keys, keep-rules, sections kept because deleting them
  felt rude.

Adopting one of these rules on a project that already violates it: gate on **new** violations only -
freeze the current count as a checked-in baseline that can ratchet down but never up (see
`docs/CODE_QUALITY.md`). And when a gate keeps catching the same defect, close the source: add the
matching DON'T here and reinforce it in the skills that generate that artifact - a detector stops a
human once, but the agent re-emits the pattern every generation.

**A point fix on a shared contract is half a fix.** When the defect is not "this is wrong" but "this
did not pay what the platform, the API, the template or the format demands", the same debt is almost
certainly unpaid elsewhere, written by the same hand on the same day. Sweep every site of that
contract in the same ticket - the contract names its own call sites, so the sweep is cheap. Measured
2026-09-20: the identical lifecycle contract had already been paid **twice** in one subsystem, each
time as a point fix; a third site nobody looked at crashed in the field and was reported **three
hours after the release shipped**. Two paid fixes were, between them, the map of every place to look.

**What another project reads has one home, and it changes first.** A format, payload or behaviour a
second project depends on lives in one place outside both; each project holds a pointer, never a copy.
Amend the contract (version bump, dated note) before the code, or record a dated exception - never
drift in silence (`docs/CODE_QUALITY.md`).

When you write a *new* rule, gate, skill, or agent on top of the kit, follow `docs/AUTHORING.md`:
author it against a failure you actually observed, name the excuse it must close, and give every
skill/agent a trigger-focused `description` (not a summary of its steps).

## 10. Post-change discipline
- Record `expected: X | actual: Y` for every check you run.
- No completion claim without fresh evidence. "should work", "probably passes", "seems fixed",
  "looks right" mean the proving command has not been run this run - stop and run it, read the
  exit code, then state the result. A subagent's "build passed" is its narration, not your
  evidence; re-run and read it yourself. See `docs/VALIDATION.md`.
- **A check has four answers, not two.** Pass and found-a-defect are obvious; *could not verify* is
  the third, and **not applicable in this configuration** is the fourth. A check with no way to say
  the last two reports one of the first two instead, and then it lies. Two consequences: validate
  the instrument before trusting its reading - a physically impossible reading means the instrument
  is broken, not that the subject failed (2026-09-20: one checker called 5 of 5 screens off-glass,
  another reported 18 of 28 rows unreachable, all false) - and treat a fresh *could not verify* as
  blocking, exactly as a FAIL is, since neither one proves the thing.
- A ticket is done only when its headline user-visible behaviour works end-to-end; created
  modules, wired contracts, and a passing compile are milestones, not deliverables. Never
  mark phases done or invite a manual check while the headline action still only logs, shows
  a placeholder, or no-ops.
- Journal at the granularity of the logical change, not the touched file: one entry per
  change batching its files, and regenerate any index/catalog once per change, not once per
  edit.
- A check only a human can run has not happened yet. An audit with **no failures** but an
  unobserved manual line is not "verified", it is "needs a human pass" - one unticked manual item
  holds the closing status back, and only the human pass converts it.
- Keep the change log / dev log current if the project has one.
- Update reader-facing docs for any new user-visible capability - every surface and every
  **authored** locale in the same change. Where the project has a release boundary, the remaining
  declared locales fan out there in one bulk pass and the closure only *names* what is missing; with
  no release boundary the whole fan-out stays in the one edit.
- Re-run the touched area's narrowest meaningful check before declaring done, and match the
  evidence to the change type - the validation ladder is in `docs/VALIDATION.md`.
- **Before anything irreversible** - a release, a publication, a filing, a send - take a written
  PASS/FAIL that **names what it judged** as the input to that step. The absence of a verdict is not
  a pass, and that is how this gate actually fails: nobody breaks the rule, nothing ever goes red,
  and months ship unverified. Everything the step itself generates is committed *before* it, never
  after.

## 11. Persistent memory (if your runtime supports it)
- Keep a small, file-based memory under `memory/` so non-obvious context survives across sessions.
- Four entry types: `user`, `feedback` (corrections **and** confirmations), `project`, `reference`.
- `memory/MEMORY.md` is the always-loaded index - one line per entry, kept short.
- Do **not** memorize anything derivable from the project files, the history, or this file.
- Verify a remembered path/name against reality before acting on it.
- Full discipline: `docs/AGENT_MEMORY.md`.

## 12. Cost & fan-out (if your runtime bills tokens or caps agents)
- Do the work inline by default; spawn a subagent only for parallelism, evidence isolation, or
  a fresh context. Offload raw artifacts to `<SCRATCH_DIR>/` and reference them by path.
- Gate a parallel fan-out: estimate the count and cost, keep a small ceiling (~6-8), get an
  explicit GO above it, stage find-then-verify, and never silently resume a limit-killed run.
- Route mechanical leaf skills to a cheap model; keep diagnosis/review/orchestration on a
  strong one - and route the **spawn** too: name the tier at the call site, and give every agent
  you define an explicit tier. An unpinned spawn silently takes the most expensive one.
- **Never fire-and-forget a verdict, and never poll for one.** Launching a check and then reporting
  what you assume it said is the most expensive single habit here; the second most expensive is
  waiting for it by asking repeatedly. Measured over one month: **~1,300 polling turns and 81
  minutes of literal sleep** (2026-08-02). Wait on a condition your runtime can signal, or write the
  verdict to a marker file a reader can branch on - never in an exit code, never in a guess.
- **Brevity is a legibility decision, not a cost lever - but it is a latency lever.** Turn latency
  tracks what the model *writes* (+0.681 correlation with output tokens), not what it *reads*
  (+0.065 with context size), and **76.5% of billed output is hidden reasoning, of which 5.6%
  reaches a file** (2026-08-28). So a long answer costs you time even where it barely moves the
  bill, and a shorter rulebook buys neither.
- Serialize a shared resource with a lock that **queues** rather than refuses; take it immediately
  before the edit and release it right after, never for a whole task; judge staleness by liveness,
  never by a clock. A lock is a (kind, domain) pair and the domain is derived from the changed file
  set, never declared by the caller. Abandoning a queued intent obliges you to withdraw your own
  ticket - nothing else will.
- **Parallel readers are free; parallel writers need isolation, and disjoint files are not it.** Any
  whole-tree version-control op one writer runs (stash, checkout, reset, restore, clean) reverts
  every other writer's uncommitted edits. Either you own version-control/build/index commands
  between waves, or each writer gets its own checkout - and then the lock path must resolve from the
  **shared** git directory, or every worktree holds its own lock and serializes nothing.
- For an **unattended** run, make the process boundary the reset: a driver outside the session takes
  the next item, runs it in a fresh process, repeats. A self-imposed "compact between tickets" is a
  request; a new process is a guarantee. Full discipline: `docs/COST.md` for the spend,
  `docs/PARALLEL.md` for running several at once.
