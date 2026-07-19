# Universal Agent Kit

A portable set of **rules, skills (slash commands), and agents** for an AI coding assistant.
Built for **Claude Code**, and adaptable to other promptable agents (see the mapping below).
Distilled from a real, mature Android project, then stripped of everything project-specific so it
carries over to most **git-backed software repos** - web, backend, mobile, CLI, library, infra -
regardless of language.

The value here is not the tooling - it is the **working method**: research before you act,
split *what/why* from *how*, plan in verifiable phases, keep autonomy high and bureaucracy
low, and keep the assistant terse and honest.

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
      spec-check.md         <- audit implementation vs spec
      spec-fix.md           <- apply the audit's action items, re-audit
      spec-all.md           <- run the whole pipeline end to end
      park.md               <- capture an out-of-scope finding as a Draft stub, then resume
      backlog.md            <- drain the backlog unattended, one eligible ticket at a time
      research.md           <- research-first pass before any change
      quick.md              <- fast path for trivial edits
      fix.md                <- narrow bug/behaviour fix, no ceremony
      git.md                <- branch model, commit grouping, what-not-to-commit
      verify.md             <- run the app, observe, report PASS/FAIL
      ui-clarify.md         <- resolve user-facing ambiguity before building
      review.md             <- terse, actionable code review
      caveman.md            <- brevity mode for the whole chat
      caveman-commit.md     <- terse Conventional Commit message
      caveman-review.md     <- terse one-line-per-finding review
    agents/                 <- subagent definitions
      rd-lead.md            <- senior engineer / orchestrator (default agent)
      solution-researcher.md<- read-only investigator, produces a report
      implementer.md        <- focused code writer
      doc-writer.md         <- human, friendly docs & UI copy
  docs/
    SPEC_LIFECYCLE.md       <- the ticket methodology, tooling-agnostic
    CODE_QUALITY.md         <- anti-slop conventions, layering, comments
    AUTHORING.md            <- how to write a new rule/skill/agent (test-first, SDO descriptions)
    AGENT_MEMORY.md         <- persistent memory that survives across sessions
    RESEARCH_INDEX.md       <- research order + the queryable code index
    VALIDATION.md           <- the validation ladder: "done" means evidence
    COST.md                 <- agent cost & fan-out discipline, model-tier routing
    REPLACES.md             <- placeholder replacements reference (EN)
    REPLACES_RU.md          <- placeholder replacements reference (RU mirror - optional)
  memory/
    MEMORY.md               <- the always-loaded memory index (template)
    examples/               <- one sample entry per memory type
```

Almost every file is plain Markdown; the one exception is `.claude/settings.json` (a small JSON
permission template for Claude Code). Nothing here runs on its own, calls an API, or hard-codes a
language or framework. Where the source project wired in a specific tool, the kit states the
*intent* and lets your agent pick the equivalent in your stack.

---

## How to import (ask your agent to do this)

Hand this whole folder to your coding agent and say something like:

> "Import the Universal Agent Kit into this repo. Read `universal-agent-kit/README.md`,
> then merge the pieces I want into my project. Adapt every `<PLACEHOLDER>` to this
> codebase. Do not overwrite my existing `CLAUDE.md` or `.claude/` files without showing
> me a diff first."

### For Claude Code (native)

1. Copy `.claude/commands/*` into your repo's `.claude/commands/`. They become
   `/spec`, `/research`, `/git`, etc. immediately.
2. Copy `.claude/agents/*` into your repo's `.claude/agents/`. They become selectable
   subagents.
3. Merge `CLAUDE.md` into your repo root (or `.claude/CLAUDE.md`). Fill the placeholders.
4. Optionally merge `.claude/settings.json` (review permissions first - see below).
5. Copy the `docs/*` files (`SPEC_LIFECYCLE`, `CODE_QUALITY`, `AUTHORING`, `AGENT_MEMORY`,
   `RESEARCH_INDEX`, `VALIDATION`, `COST`, `REPLACES`) wherever your docs live; reference them
   from `CLAUDE.md`.
   `REPLACES_RU.md` is a Russian mirror of `REPLACES.md` - skip it unless your team reads Russian.
6. Optionally copy `memory/` - the index template and one sample entry per type - if your
   runtime supports persistent agent memory.

### Minimal start

Not ready for the full set? Take three files: `CLAUDE.md` (rename it to `AGENTS.md` if that is
what your tool reads), `.claude/commands/quick.md`, and `.claude/commands/fix.md`. Add `/spec` +
`docs/SPEC_LIFECYCLE.md` the first time a task carries real design decisions, and `memory/`
once re-explaining things starts to hurt. Same lowest-rung rule the kit preaches, applied to
adopting it.

### For other agents (adaptation, not drop-in)

Only Claude Code reads `.claude/` and `/slash` commands natively. The kit ships an `AGENTS.md`
pointer at its root, so tools that follow that convention (Codex and others) find the
contract immediately. Beyond the rules file the kit is an *adaptation*: each skill becomes a
saved prompt you paste or trigger, and the agents become custom modes / system prompts. The `docs/` methodology is
tool-independent as-is. Concrete homes (conventions evolve - check your tool's current docs):

| Tool | `CLAUDE.md` → | Skills (`.claude/commands/*`) → | Agents (`.claude/agents/*`) → |
| --- | --- | --- | --- |
| OpenAI Codex / Codex CLI | `AGENTS.md` | prompts pasted per task | system-prompt preambles |
| Cursor | `.cursor/rules/*.mdc` | saved prompts / Cursor commands | custom modes |
| Cline | `.clinerules` (file or dir) | prompt snippets | mode presets |
| Windsurf | `.windsurf/rules/` (or `.windsurfrules`) | saved prompts | Cascade presets |
| Aider | `CONVENTIONS.md` (loaded via `--read`) | prompt files / aliases | single agent - fold into rules |

The mental model carries even where the file layout does not: one always-loaded rules file, a set
of named procedures you invoke, and a few role briefs.

---

## Fill these placeholders

`CLAUDE.md`, the skills, and the agents use `<PLACEHOLDER>` tokens. This is the complete set of
config placeholders to fill once for your repo:

- `<PROJECT_NAME>` - your project's name.
- `<CHAT_LANGUAGE>` - the language the assistant talks to you in. Code, docs, logs, and commits
  stay **English** regardless (recommended).
- `<INDEX_DOC>` - the repo map/overview the agent reads first (e.g. `README.md`, `ARCHITECTURE.md`).
- `<SRC_ROOT>` - main source directory.
- `<ARCH_LAYERS>` - your architecture/dependency rule, e.g. `UI -> ViewModel -> UseCase -> Repo`,
  `route -> handler -> service -> store`, or `n/a`.
- `<BUILD_CMD>` / `<TEST_CMD>` / `<LINT_CMD>` / `<RUN_CMD>` - how your project builds, tests,
  lints, runs.
- `<LOGGER>` - your logging facade (or `n/a`).
- `<PLAN_DIR>` - where spec/plan files live (default `PLAN/`).
- `<SCRATCH_DIR>` - throwaway artifacts and backups, git-ignored (default `tmp/`).
- `<MAX_LOC>` - the file-size budget past which you extract a helper (e.g. `~500`).
- `<READONLY_ZONES>` - paths the agent must never modify (vendored/generated code), or `none`.
- `<ID>` - the ticket id scheme (e.g. `T0042`, `JIRA-123`, a date-slug).

Template tokens like `<slug>`, `<NN>`, `<TODO>`, `<symbol>`, and `<path>` are *not* config - they
are filled per ticket as you use the skills. A good first move: ask your agent to grep the kit for
`<` + `>` tokens and propose values from the actual repo.

---

## The method in one screen

1. **Research before acting** (`/research`). Never guess paths or behaviour. Read the map,
   then the code. Persist findings, don't re-grep.
2. **Split what from how.** `/spec` writes the *what/why* (no class names, no file paths).
   `/spec-tech` turns it into a *phased, verifiable plan*. This split is the single most
   valuable idea in the kit.
3. **Plan in verifiable phases.** Every step ends in a static check (file exists, symbol
   present, command exits 0) - never "works correctly". Order phases so no phase consumes
   something a later phase produces.
4. **Execute one step at a time** (`/spec-dev`). Run each step's check before marking it
   done. Hard-stop on ambiguity instead of guessing.
5. **Audit against reality** (`/spec-check`). Status comes from the repo, not from a
   filename or a hope; `/spec-fix` closes the mechanical findings, then re-audits.
6. **Stay cheap when the task is small.** `/quick` for trivial edits, `/fix` for a narrow
   bug, `/spec` only when design decisions exist.
7. **Keep autonomy high.** Don't ask permission for reads, searches, builds. Flag real
   blockers up front. Be terse (`/caveman`).
8. **Write clean from the start** (`docs/CODE_QUALITY.md`). No slop comments, no empty
   catches, no dead weight left behind.
9. **Remember across sessions** (`docs/AGENT_MEMORY.md`). A small, file-based memory keeps
   the durable, non-obvious context the runtime would otherwise forget every session.

See `docs/SPEC_LIFECYCLE.md` for the full status flow.

---

## A note on permissions

`.claude/settings.json` (Claude Code only) grants read/glob/grep plus edit/write and `git`, with
`defaultMode: acceptEdits`, so the agent can work without constant prompts. It does **not**
pre-approve your build/test/run commands - those are listed as commented examples; add the ones
you trust (e.g. `Bash(npm run *)`) for your stack. **Review it before adopting** and tighten
`allow` to your comfort level; the kit works fine under stricter permissions, you will just get
more confirmation prompts.

---

## Provenance

Adapted from the FastMediaSorter Android project's `.claude/` setup. Android-, PowerShell-,
and Russian-locale-specific machinery was removed; the transferable methodology was kept
and rewritten to be stack-neutral. No source code or proprietary content is included -
only the working method.
