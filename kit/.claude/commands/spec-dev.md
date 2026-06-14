# Specification Developer Executor

Execute a tactical spec **one step at a time**. Read `<PLAN_DIR>/<ID>_<slug>/INDEX.md` +
phase files, follow each `Prompt for developer:` in dependency order, run each step's
`Verification:` predicate **before** flipping it to `[x] done`. The discipline — one step,
one check, hard-stop on ambiguity — is what keeps a long plan from drifting.

## Usage

```text
/spec-dev <ID-or-slug>                 # continue from the first non-done step
/spec-dev <ID-or-slug> --phase <NN>    # all remaining steps in one phase
/spec-dev <ID-or-slug> --step <NN.M>   # a single step
/spec-dev <ID-or-slug> --dry-run       # print the plan, write nothing
/spec-dev <ID-or-slug> --verify-smoke  # after all phases, run /verify before flipping status
```

## Status gate

| Strategic `Status:` | Behaviour |
| --- | --- |
| `Tactical` | Allowed — advance to `In Progress` on the first executed step. |
| `In Progress` | Allowed — continue. |
| `Draft` / `Approved` | Abort: no tactical folder. Run `/spec-tech` first. |
| `Implemented` / `Verified` | Abort: feature closed. |
| `Partial` / `Broken` | Run `/spec-fix` (or apply the audit's action items), re-read status. If still broken, list remaining FAILs and stop. |
| `BlockNeedUserTest` | Note in chat and stop — user must confirm the on-device/manual result first. |
| `BlockByOtherTask` / `BlockQuestions` / `BlockExternal` | Abort: blocked. Resolve first. |

## Process

**1 — Parse args, load state.** Compute the target step set. Read the strategic spec, INDEX,
and all in-scope phase files. Verify the status gate. Verify all Pre-Implementation Blockers
are ticked — if any unchecked, abort with the blocker text.

**2 — If `--dry-run`:** print the planned step table and exit.

**3 — Execute steps, one at a time.** For each step in plan order:
1. **Re-read the phase file.** If its `Status:` is no longer `[ ]`/`[~]`, log "pre-resolved — skipped".
2. **Verify dependencies.** The `Depends on:` step must be `[x] done`, else abort:
   "Dependency violation: NN.M depends on NN.K which is not done."
3. **Read the prompt + Files Touched.** For each referenced existing symbol, confirm it
   exists at the stated path, else abort: "Prompt references `<symbol>` at `<path>`, not found."
4. **Ambiguity check.** Any unresolved placeholder (`<TODO>`, `<choose ..>`, `???`) → abort,
   request a spec update. If it needs user input, set `BlockQuestions` and stop.
5. **Pre-edit guards:** read-only zone → abort; file over ~500 lines and not yet backed up →
   back up to `<SCRATCH_DIR>/` first; projected size past the budget → abort and split;
   multiple form-factor variants → confirm the step covers the counterpart.
6. **Flip the step to `[~] in progress`.**
7. **Apply the edit.** Scope strictly to the prompt: no surrounding refactor, no extra
   comments, no unrelated import cleanup, no name not stated in the prompt.
8. **Run the `Verification:` predicates** (file exists / symbol present / value equality).
9. **Outcome:** all PASS → flip to `[x] done`, append a Step Log line. Any FAIL → leave
   `[~]`, append the FAIL note, **hard stop**.
10. **Post-change closure** for every modified file: changelog entry, index/catalog regen if
    public API changed, narrowest meaningful check.

After all planned steps in a phase:
- **Final-phase verification tags (before the phase check).** If this is the last in-scope phase
  and acceptance includes manual testing, insert the verification tags now — one at each
  changed-flow entry across all phases (see `CLAUDE.md` §6). Tags are the last code edits,
  inserted **before** the phase check below so one run validates code + tags.
- **Phase done criteria:** run each checkbox. For the phase's verification rung, run the
  narrowest meaningful check the phase names (per `docs/VALIDATION.md`) — a compile / type-check,
  a targeted test, or `<BUILD_CMD>` only when the phase touches packaging, resources, or wiring.
  Exit 0 → tick; non-zero → append the output tail and hard stop.
- All ticked → flip the phase to ✅ Done, update the INDEX row + counter. Any unticked →
  leave 🚧, update the step counter only, hard stop.

After all phases:
- **Optional smoke (only `--verify-smoke`).** Run `/verify --build` once. PASS → proceed.
  FAIL → abort the status flip, leave `In Progress`, log the failure.
- **No manual-test gate** → flip strategic `Status:` to `Implemented`, add the date. No tags.
- **Manual test is part of acceptance** → tags already inserted; flip status to
  `BlockNeedUserTest` with a note describing what to verify. Add a changelog line per tagged
  file.
- User-facing doc updates run **after** the build, never trigger a rebuild.
- **Auto-chain to `/spec-check`** unless the status went to `BlockNeedUserTest` (then stop
  and await the manual result, or run `/verify` if a target is available).

**Chat output:** `<ID>: N steps done. Cursor: <next step>. [stop reason]. -> Running /spec-check…`

## Hard stops

Stop immediately and report — never guess, never attempt speculative recovery — on any of:
1. **Ambiguous prompt** (placeholder, missing name, unspecified scope). Set `BlockQuestions`.
2. **Verification FAIL** after an edit — step left `[~]`.
3. **Read-only zone touch.**
4. **File-size budget violation.**
5. **Phase check FAIL** — the phase's narrowest-check command returned non-zero. Stop with the error excerpt.
6. **Schema/migration change** the step does not fully specify (version + migration name).
7. **Dependency-injection / module-graph change** beyond what the prompt scopes.
8. **Missing symbol** the prompt names but does not also create.
9. **Dependency violation** — a `Depends on:` step not `[x] done`.
10. **External-system touch** — network, deletion outside `<SCRATCH_DIR>/`, force push, CI
    edit. Require explicit permission.
11. **Localization gap** — a UI string added but not in all required locales. Never fabricate
    translations.
12. **External dependency missing** — needs a library version / hardware / third-party state
    not present. Set `BlockExternal`.

## Conventions

- Step status: `[ ] not done` → `[~] in progress` → `[x] done`. Append-only Step Log; never
  overwrite. A step is `[x]` only when every predicate returned PASS in the current run.
- Never run a final build/test of your own outside the Done-criteria check; never `git
  commit`/`push`/`rebase`; never skip planned steps or batch multiple steps' status updates.
- Committing is `/git`'s job, not this skill's. Steps are sized to be independently committable,
  so you (or `/git`) can commit per step or per phase once the work is in.
- Edit scope: never refactor surrounding code, add comments, or touch unrelated imports.
  A warranted comment is English, explains *why*, covers only non-obvious logic.
- Anti-slop applies while implementing (`docs/CODE_QUALITY.md`).
- Dead-weight hygiene: when a step orphans code/resources/deps, delete the remnant in the
  same step; drop any keep-rule naming a deleted symbol. Before deleting a zero-reference
  artifact, grep `<PLAN_DIR>/` for active-ticket scaffolding and do not remove another
  ticket's in-flight work.
- If a repo helper script in the current step is broken, fix the script rather than working
  around it, then continue.
- Verification tags belong only to `BlockNeedUserTest`: insert as the final code edits before
  the last build; never at `Implemented`, never per-step, never after the build. Removal is
  `/spec-check`'s job on the `Verified` transition.
