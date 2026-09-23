# Universal Agent Kit

A portable set of **rules, skills (slash commands), and agents** for working with an AI agent on a
project. Built for **Claude Code**, adaptable to other promptable agents (mapping below).

It was distilled from a real, mature software project and then stripped of its language, its stack
and its subject matter - so what is left is the part that transfers. The method assumes five things
and not one of them is a compiler: **a workspace with history, artifacts, work items, checks, and an
agent that can read and write your files.** `docs/PROJECT_SHAPES.md` translates every noun in the
kit into data work, writing, legal and operations work, and says which rules to delete when they
have no subject.

The value here is not the tooling - it is the **working method**: research before you act, split
*what/why* from *how*, plan in verifiable phases, keep autonomy high and bureaucracy low, run
several agents at once without losing each other's work, and keep the assistant terse and honest.

**Two tiers.** Everything applies to any project; the parts that need a build are marked **code
layer** and are a minority. If your project compiles, you fill sixteen placeholders. If it does not,
you fill ten and delete the rest - which is a supported path, not a degraded one.

---

## What is inside

```
universal-agent-kit/
  README.md                 <- you are here: import guide + manifest
  CLAUDE.md                 <- project-rules template (fill the <PLACEHOLDERS>)
  AGENTS.md                 <- pointer: the same contract for tools that read AGENTS.md
  .claude/
    settings.json           <- default agent + permission template
    commands/               <- slash-command "skills"
      spec.md               <- strategic spec: what/why
      spec-tech.md          <- tactical plan: phased, verifiable how
      spec-dev.md           <- execute the plan step by step
      spec-check.md         <- audit the result against the spec
      spec-fix.md           <- apply the audit's action items, re-audit
      spec-all.md           <- run the whole pipeline end to end
      park.md               <- capture an out-of-scope finding as a Draft stub, then resume
      backlog.md            <- drain the backlog unattended, one eligible ticket at a time
      research.md           <- research-first pass before any change
      quick.md              <- fast path for trivial edits
      fix.md                <- narrow defect fix, no ceremony
      git.md                <- branch model, commit grouping, what-not-to-commit
      verify.md             <- run it, observe, report one of four verdicts
      ui-clarify.md         <- resolve reader-facing ambiguity before building
      review.md             <- terse, actionable review
      caveman.md            <- brevity mode for the whole chat
      caveman-commit.md     <- terse Conventional Commit message
      caveman-review.md     <- terse one-line-per-finding review
    agents/                 <- subagent definitions
      rd-lead.md            <- senior engineer / orchestrator (default agent)
      solution-researcher.md<- read-only investigator, produces a report
      implementer.md        <- focused maker
      doc-writer.md         <- human, friendly docs & UI copy
  docs/
    PROJECT_SHAPES.md       <- what the method assumes; the vocabulary in five kinds of project
    SPEC_LIFECYCLE.md       <- the ticket methodology, tooling-agnostic
    VALIDATION.md           <- the validation ladder: "done" means evidence
    CODE_QUALITY.md         <- anti-slop conventions (code layer)
    AUTHORING.md            <- how to write a new rule/skill/agent (test-first, SDO descriptions)
    HOOKS.md                <- event hooks: which verdict, who the event actually reaches
    AGENT_MEMORY.md         <- persistent memory that survives across sessions
    RESEARCH_INDEX.md       <- research order + the queryable index of your material
    COST.md                 <- cost & fan-out, model-tier routing, the shared-resource lock queue
    PARALLEL.md             <- several agents at once: isolation, merge-back, unattended drivers
    REPLACES.md             <- placeholder replacements reference (EN)
    REPLACES_RU.md          <- placeholder replacements reference (RU mirror - optional)
  memory/
    MEMORY.md               <- the always-loaded memory index (template)
    examples/               <- one sample entry per type, plus one from a non-code project
```

Every file is plain Markdown except `.claude/settings.json` (a small permission template for Claude
Code). Nothing here runs on its own, calls an API, or hard-codes a language or a framework. Where
the source project wired in a specific tool, the kit states the *intent* and lets your agent pick
the equivalent.

---

## How to import (ask your agent to do this)

Hand this whole folder to your agent and say something like:

> "Import the Universal Agent Kit into this project. Read `universal-agent-kit/README.md`, then
> `universal-agent-kit/docs/PROJECT_SHAPES.md` to work out which rules apply to work like mine,
> then merge the pieces I want. Adapt every `<PLACEHOLDER>` to this project. Do not overwrite my
> existing `CLAUDE.md` or `.claude/` files without showing me a diff first."

### For Claude Code (native)

1. Copy `.claude/commands/*` into your repo's `.claude/commands/`. They become `/spec`,
   `/research`, `/git`, etc. immediately.
2. Copy `.claude/agents/*` into your repo's `.claude/agents/`. They become selectable subagents.
   Each declares an explicit `model:` tier rather than inheriting the session's - an unpinned spawn
   silently takes the most expensive model you have (`docs/COST.md`). The tier names are Claude
   Code's; on another runtime map them to its own.
3. Merge `CLAUDE.md` into your repo root (or `.claude/CLAUDE.md`). Fill the placeholders.
4. Optionally merge `.claude/settings.json` (review permissions first - see below).
5. Copy the `docs/*` files wherever your docs live, and reference them from `CLAUDE.md`. Start with
   `PROJECT_SHAPES` if your project is not a codebase; skip `CODE_QUALITY` if it never will be.
   `REPLACES_RU.md` is a Russian mirror of `REPLACES.md` - skip it unless your team reads Russian.
6. Optionally copy `memory/` - the index template and the sample entries - if your runtime supports
   persistent agent memory.

### Minimal start

Not ready for the full set? Take three files: `CLAUDE.md` (rename it to `AGENTS.md` if that is what
your tool reads), `.claude/commands/quick.md`, and `.claude/commands/fix.md`. Add `/spec` +
`docs/SPEC_LIFECYCLE.md` the first time a task carries real design decisions, and `memory/` once
re-explaining things starts to hurt. Same lowest-rung rule the kit preaches, applied to adopting it.

### For other agents (adaptation, not drop-in)

Only Claude Code reads `.claude/` and `/slash` commands natively. The kit ships an `AGENTS.md`
pointer at its root, so tools that follow that convention (Codex and others) find the contract
immediately. Beyond the rules file the kit is an *adaptation*: each skill becomes a saved prompt you
paste or trigger, and the agents become custom modes / system prompts. The `docs/` methodology is
tool-independent as-is. Concrete homes (conventions evolve - check your tool's current docs):

| Tool | `CLAUDE.md` → | Skills (`.claude/commands/*`) → | Agents (`.claude/agents/*`) → |
| --- | --- | --- | --- |
| OpenAI Codex / Codex CLI | `AGENTS.md` | prompts pasted per task | system-prompt preambles |
| Cursor | `.cursor/rules/*.mdc` | saved prompts / Cursor commands | custom modes |
| Cline | `.clinerules` (file or dir) | prompt snippets | mode presets |
| Windsurf | `.windsurf/rules/` (or `.windsurfrules`) | saved prompts | Cascade presets |
| Aider | `CONVENTIONS.md` (loaded via `--read`) | prompt files / aliases | single agent - fold into rules |

The mental model carries even where the file layout does not: one always-loaded rules file, a set of
named procedures you invoke, and a few role briefs.

---

## Fill these placeholders

Full reference with worked values per kind of project: `docs/REPLACES.md`.

**Tier 1 - every project:**

- `<PROJECT_NAME>` - your project's name.
- `<CHAT_LANGUAGE>` - the language the assistant talks to you in. Artifacts - code, docs, logs,
  commits - stay **English** regardless (recommended).
- `<INDEX_DOC>` - the map the agent reads first (`README.md`, an architecture doc, a data
  dictionary, a table of contents, a matter index).
- `<WORK_ROOT>` - where the project's real material lives.
- `<CHECK_CMD>` - **the command that proves a change is sound.** The one placeholder nobody may
  leave empty. If you are sure your project has none, read `docs/PROJECT_SHAPES.md` first - the
  five shapes a check takes in work that never compiles are listed there, and most projects already
  run one by hand.
- `<PLAN_DIR>` - where spec/plan files live (default `PLAN/`).
- `<SCRATCH_DIR>` - throwaway artifacts and backups, ignored by version control (default `tmp/`).
- `<SIZE_BUDGET>` - the file-size budget past which you split along a real seam (e.g. `~500`).
- `<READONLY_ZONES>` - paths the agent must never modify (vendored/generated material), or `none`.
- `<ID>` - the ticket id scheme (e.g. `T0042`, `JIRA-123`, a date-slug).

**Tier 2 - the code layer** (fill if your project builds or runs; otherwise delete the rules that
use them): `<ARCH_LAYERS>`, `<BUILD_CMD>`, `<TEST_CMD>`, `<LINT_CMD>`, `<RUN_CMD>`, `<LOGGER>`.

Template tokens like `<slug>`, `<NN>`, `<TODO>`, `<symbol>`, and `<path>` are *not* config - they
are filled per ticket as you use the skills. A good first move: ask your agent to grep the kit for
`<` + `>` tokens and propose values from the actual project.

---

## The method in one screen

1. **Research before acting** (`/research`). Never guess a path or a fact. Read the map, then the
   material. Persist findings, don't search twice.
2. **Split what from how.** `/spec` writes the *what/why* (no file paths, no layout). `/spec-tech`
   turns it into a *phased, verifiable plan*. This split is the single most valuable idea in the
   kit, and the one that needs a compiler least.
3. **Plan in verifiable phases.** Every step ends in a mechanical check - file exists, command
   exits 0, the totals reconcile, every cross-reference resolves - never "works correctly". Order
   phases so no phase consumes something a later phase produces.
4. **Execute one step at a time** (`/spec-dev`). Run each step's check before marking it done.
   Hard-stop on ambiguity instead of guessing.
5. **Audit against reality** (`/spec-check`). Status comes from the workspace, not from a filename
   or a hope; `/spec-fix` closes the mechanical findings, then re-audits.
6. **Stay cheap when the task is small.** `/quick` for trivial edits, `/fix` for a narrow defect,
   `/spec` only when design decisions exist.
7. **Keep autonomy high.** Don't ask permission for reads, searches, checks. Flag real blockers up
   front. Be terse (`/caveman`).
8. **Write clean from the start** (`docs/CODE_QUALITY.md`, or the generic list in
   `docs/PROJECT_SHAPES.md`). No slop, no dead weight left behind.
9. **Remember across sessions** (`docs/AGENT_MEMORY.md`). A small, file-based memory keeps the
   durable, non-obvious context the runtime would otherwise forget every session.
10. **Run several agents without losing work** (`docs/PARALLEL.md`). Readers fan out freely; writers
    get one checkout each and a single owner for whole-tree commands. Unattended runs loop the
    *process*, not the session, so every item starts on an empty context.

See `docs/SPEC_LIFECYCLE.md` for the full status flow.

---

## Why the numbers are in here

Most of the rules carry a measurement and a date, and a few carry a correction of an earlier rule.
That is deliberate: a directive with a mechanical check behind it was followed **~99%** of the time
in the reference corpus, while the same directive as prose was followed **1-8%** - and the best case
ever measured for prose, shipped in the tool's own description and re-read every turn, was **22%**
(`docs/AUTHORING.md`). So the kit tries never to tell you something is important without saying what
it cost when it was ignored, and never to keep a recommendation after its own measurement came back
against it - see the prompt-submit nudge in `docs/HOOKS.md`, which this kit recommended until its
measured reach turned out to be zero.

Every number is from one portfolio, dated where it appears. Treat them as evidence that the rule
came from somewhere real, not as constants for your project.

---

## A note on permissions

`.claude/settings.json` (Claude Code only) grants read/glob/grep plus edit/write and `git`, with
`defaultMode: acceptEdits`, so the agent can work without constant prompts. It does **not**
pre-approve your build/test/run commands - those are listed as commented examples; add the ones you
trust (e.g. `Bash(npm run *)`) for your stack. **Review it before adopting** and tighten `allow` to
your comfort level; the kit works fine under stricter permissions, you will just get more
confirmation prompts.

---

## Provenance

Adapted from the `.claude/` setup of a real, mature mobile application - a multi-module product with
several store channels and a long ticket history. Platform-, shell-, and locale-specific machinery
was removed; the transferable methodology was kept and rewritten to be stack-neutral. The same core
has since been reconciled against a wider portfolio - desktop apps, command-line tools, a browser
extension, documentation sites - and the rules that survived every shape are the ones kept here. No
source code or proprietary content is included - only the working method.
