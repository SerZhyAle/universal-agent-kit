# CLAUDE.md - Rules for the AI assistant in `<PROJECT_NAME>`

> Project-rules template. Fill every `<PLACEHOLDER>`. Delete rules that do not apply to
> your stack. These instructions override the assistant's default behaviour.

## 1. Communication & Style
- **Chat**: `<CHAT_LANGUAGE>`. **Code / docs / logs / commits**: English.
- **Tone**: dry, concise, technical. No filler, no cheerleading, no trailing summaries the
  user can read from the diff.
- **Ask if ambiguous** - but triage first. If an external convention settles it (naming,
  structure, grouping), research it and recommend; if the project's own architecture or
  contracts settle it, state it as a derived consequence, not a choice. Reserve real
  questions for product scope, taste with no external anchor, and irreversible/destructive
  actions. Pick the obvious default and state it; do not manufacture choices.

## 2. Autonomy (anti-bureaucracy)
- Do **not** ask permission to read, search, build, run tests, or query the repo. Just do
  it and report.
- Flag real blockers at the start, not after burning a turn.
- Fix minor, non-structural issues silently. Surface only decisions that change behaviour,
  data, or architecture.
- Split guards by what they check: a mechanical invariant (objectively true/false)
  hard-stops; a judgment call only informs - surface a graded risk signal and leave
  go/no-go to yourself. Hard-blocking on heuristics breeds bypasses. A destructive change
  is not automatically a stop-and-ask: if the plan already encodes the safeguards, do not
  invent a confirmation gate. Caution alone is not a blocker.
- Park, don't chase. Hitting a real but out-of-scope problem (more than a one-line fix,
  needs its own look) - record it as a stub via `/park`, report it in one line, and return
  to the task. Never switch the active task to chase a parked finding; fix trivial
  out-of-scope issues inline; drop cosmetic nitpicks.
- Prefer doing the work over describing the work.

## 3. Research Order (never guess)
Read in this order; stop as soon as a source answers:
1. The repo map / index (`<INDEX_DOC>`, e.g. `README.md`, `ARCHITECTURE.md`).
2. The relevant spec/plan under `<PLAN_DIR>/`.
3. The code - locate symbols with grep/your code index **before** reading whole trees.
4. External docs (official framework docs, changelogs) when the answer is version-specific.

For a large codebase, maintain a queryable code index: query it before grep, and regenerate it
after you change code. Never invent a file path, symbol name, or API - if you state one, you have
verified it. See `docs/RESEARCH_INDEX.md`.

- The working tree, not git history, is the authority for what is currently done.
  `git log`/`blame`/`diff` answer "how did we get here", not "what is true now", and
  mislead when one file carries several concurrent tasks. Reconcile in-progress work by
  reading the live files, then correct the trackers - never infer present state from a diff.
- A name is not evidence of behaviour. Before reasoning about what a flag, constant, or key
  does, confirm a live read/call site - a comment or doc mention is a hit, not a usage.

## 4. Skill Routing (slash commands)
- `/quick` - trivial edit (typo, one constant, one string). No spec, no build gate.
- `/fix` - narrow bug/behaviour fix. Local validation only.
- `/park` - capture an out-of-scope finding as a stub and return to the current task.
- `/research` - investigate before any non-trivial change.
- `/spec` - write the strategic *what/why* for a feature.
- `/spec-tech` - break an approved spec into a phased, verifiable plan.
- `/spec-dev` - execute a tactical plan step by step.
- `/spec-check` - audit implementation against the spec; set status.
- `/spec-fix` - apply the audit's mechanical action items, then re-audit.
- `/spec-all` - run the whole pipeline end to end (research → spec → plan → execute → audit).
- `/backlog` - drain the backlog unattended: pick the highest-priority eligible ticket, run
  the pipeline, repeat; defer human-gated tickets to one end-of-run report.
- `/ui-clarify` - resolve user-facing ambiguity before building.
- `/verify` - run the app and observe; PASS/FAIL with evidence.
- `/git` - branch model, staging, commit grouping.
- `/review`, `/caveman`, `/caveman-commit`, `/caveman-review`.

## 5. Spec / Plan tickets
- One ticket = one Markdown file `<PLAN_DIR>/<ID>_<slug>.md`, where `<ID>` is e.g. `T0042`.
- Status header is the first `**Status:**` line in the file; keep it accurate by hand.
- Lifecycle: `Draft -> Approved -> Tactical -> In Progress -> Implemented -> Verified`
  (plus `Partial` / `Broken` from an audit, and explicit `Block*` states).
- Status comes from reality (code + checks), never inferred from the filename.
- See `docs/SPEC_LIFECYCLE.md` for the full flow.
- No time/effort estimates in spec files.
- Spec style: lists over tables (tables only for 3+ columns); one idea per bullet; no
  pseudographics; no section summaries.

## 6. Verification tags (optional, powerful)
- A temporary debug log line `<LOGGER>("<ID>: <what this proves>")` may exist in source
  **iff** ticket `<ID>` is currently awaiting manual testing (`BlockNeedUserTest`).
- Insert one at each changed-flow entry point when the ticket enters that status; remove
  every one when it leaves. Permanent logs must never embed a ticket id.

## 7. Project structure & build
- **Source root**: `<SRC_ROOT>`. **Scratch**: `<SCRATCH_DIR>` (git-ignored).
- **Architecture**: `<ARCH_LAYERS>`. Respect the dependency direction strictly.
- **Build**: `<BUILD_CMD>`. **Test**: `<TEST_CMD>`. **Lint**: `<LINT_CMD>`. **Run**: `<RUN_CMD>`.
- **Logging**: `<LOGGER>` only (no ad-hoc print/console logging in shipped code).

## 8. Strict rules
1. No writes to the repo root. Scratch/backups go to `<SCRATCH_DIR>/`.
2. File-size budget: ~`<MAX_LOC>` lines. Past it, extract cohesive helpers.
3. Keep entry points (controllers/activities/handlers) thin - delegate logic to named
   helper/service classes.
4. Read-only zones: `<READONLY_ZONES>` - never modify.
5. Back up any file over ~500 lines to `<SCRATCH_DIR>/` before a large edit.
6. Naming: follow the codebase's existing convention consistently.
7. Resolve lint/compiler warnings in files you touch.
8. Read existing comments and API docs in the area before editing; treat them as intent.
9. Comment discipline: English; explain **why**, not what; only for non-obvious logic,
   handled edge cases, workarounds, or invariants the code cannot express. Remove stale
   comments.
10. Resolve user-facing ambiguity (placement, wording, fallback) before building - see
    `/ui-clarify`.

## 9. Anti-slop (write clean from the start)
Forbidden, and a reviewer must flag them - see `docs/CODE_QUALITY.md`:
- Trivial comments restating the adjacent line.
- Empty `catch {}` or broad catches that only log without recovery/safe-default.
- Hardcoded values where the codebase has a token/constant/theme attribute.
- Lifecycle-unsafe async collection / global mutable scope where a scoped one exists.
- Non-facade logging (`print`, `console.log`, `System.out`) in shipped code.
- Shipped stubs (`TODO()`, `throw NotImplementedError`) on a live path.
- Dead weight: orphaned classes, resources, keys, keep-rules left behind by a change.

Adopting one of these rules on a codebase that already violates it: gate on **new**
violations only - freeze the current count as a checked-in baseline that can ratchet down
but never up (see `docs/CODE_QUALITY.md`). And when a gate keeps catching the same defect,
close the source: add the matching DON'T here and reinforce it in the code-generating skills
- a detector stops a human once, but the agent re-emits the pattern every generation.

## 10. Post-change discipline
- Record `expected: X | actual: Y` for every check you run.
- A ticket is done only when its headline user-visible behaviour works end-to-end; created
  classes, wired contracts, and a passing compile are milestones, not deliverables. Never
  mark phases done or invite a manual test while the headline action still only logs, shows
  a placeholder, or no-ops.
- Journal at the granularity of the logical change, not the touched file: one entry per
  change batching its files, and regenerate any index/catalog once per change, not once per
  edit.
- Keep the change log / dev log current if the project has one.
- Update user-facing docs for any new user-visible capability.
- Re-run the touched area's narrowest meaningful check (compile > targeted test > full run)
  before declaring done.
- Match the evidence to the change type - the validation ladder is in `docs/VALIDATION.md`.

## 11. Persistent memory (if your runtime supports it)
- Keep a small, file-based memory under `memory/` so non-obvious context survives across sessions.
- Four entry types: `user`, `feedback` (corrections **and** confirmations), `project`, `reference`.
- `memory/MEMORY.md` is the always-loaded index - one line per entry, kept short.
- Do **not** memorize anything derivable from the repo, git history, or this file.
- Verify a remembered path/symbol against the repo before acting on it.
- Full discipline: `docs/AGENT_MEMORY.md`.
