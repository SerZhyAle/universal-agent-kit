# Universal Agent Kit

A portable, stack-agnostic set of **rules, skills (slash commands), and agents** for an
AI coding assistant (Claude Code and compatible agent runtimes). Distilled from a real,
mature Android project, then stripped of everything project-specific so it drops into
**any** codebase — web, backend, mobile, CLI, library, infra.

The value here is not the tooling — it is the **working method**: research before you act,
split *what/why* from *how*, plan in verifiable phases, keep autonomy high and bureaucracy
low, and keep the assistant terse and honest.

---

## What is inside

```
universal-agent-kit/
  README.md                 <- you are here: import guide + manifest
  CLAUDE.md                 <- project-rules template (fill the <PLACEHOLDERS>)
  .claude/
    settings.json           <- default agent + permission template
    commands/               <- slash-command "skills"
      spec.md               <- strategic spec: what/why
      spec-tech.md          <- tactical plan: phased, verifiable how
      spec-dev.md           <- execute the plan step by step
      spec-check.md         <- audit implementation vs spec
      spec-all.md           <- run the whole pipeline end to end
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
    AGENT_MEMORY.md         <- persistent memory that survives across sessions
    RESEARCH_INDEX.md       <- research order + the queryable code index
    VALIDATION.md           <- the validation ladder: "done" means evidence
  memory/
    MEMORY.md               <- the always-loaded memory index (template)
    examples/               <- one sample entry per memory type
```

Every file is plain Markdown. Nothing here runs a script, calls an API, or assumes a
language/framework. Where the source project hard-wired a tool, this kit describes the
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
4. Optionally merge `.claude/settings.json` (review permissions first — see below).
5. Copy the `docs/*` files (`SPEC_LIFECYCLE`, `CODE_QUALITY`, `AGENT_MEMORY`, `RESEARCH_INDEX`,
   `VALIDATION`) wherever your docs live; reference them from `CLAUDE.md`.
6. Optionally copy `memory/` — the index template and one sample entry per type — if your
   runtime supports persistent agent memory.

### For other agents (Cursor, Cline, Windsurf, Codex, Aider, ..)

The slash commands are just prompts. Your agent reads `.claude/commands/<name>.md` and
follows it. Map them to whatever your tool calls "commands", "rules", "modes", or
"prompts". The agents are role briefs — paste them as system prompts or custom modes.
The methodology in `docs/` is tool-independent.

---

## Fill these placeholders

`CLAUDE.md` and several skills use `<PLACEHOLDER>` tokens. The important ones:

- `<PROJECT_NAME>` — your project.
- `<CHAT_LANGUAGE>` — what language the assistant talks to you in. Code, docs, logs, and
  commits stay **English** regardless (recommended).
- `<BUILD_CMD>` / `<TEST_CMD>` / `<LINT_CMD>` / `<RUN_CMD>` — how your project builds,
  tests, lints, runs.
- `<SRC_ROOT>` — main source directory.
- `<ARCH_LAYERS>` — your architecture rule, e.g. `UI -> ViewModel -> UseCase -> Repo`,
  `route -> handler -> service -> store`, or "n/a".
- `<PLAN_DIR>` — where spec/plan files live (default `PLAN/`).
- `<SCRATCH_DIR>` — throwaway artifacts (default `temp/`).
- `<LOGGER>` — your logging facade, if you have one.

A good first move: ask your agent to grep the kit for `<` + `>` tokens and propose values
from the actual repo.

---

## The method in one screen

1. **Research before acting** (`/research`). Never guess paths or behaviour. Read the map,
   then the code. Persist findings, don't re-grep.
2. **Split what from how.** `/spec` writes the *what/why* (no class names, no file paths).
   `/spec-tech` turns it into a *phased, verifiable plan*. This split is the single most
   valuable idea in the kit.
3. **Plan in verifiable phases.** Every step ends in a static check (file exists, symbol
   present, command exits 0) — never "works correctly". Order phases so no phase consumes
   something a later phase produces.
4. **Execute one step at a time** (`/spec-dev`). Run each step's check before marking it
   done. Hard-stop on ambiguity instead of guessing.
5. **Audit against reality** (`/spec-check`). Status comes from the repo, not from a
   filename or a hope.
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

`.claude/settings.json` grants the agent broad edit/read/write plus `git` and generic
build commands so it can work without constant prompts — same trade the source project
made. **Review it before adopting.** Tighten `allow` to your comfort level; the kit works
fine with stricter permissions, you will just get more confirmation prompts.

---

## Provenance

Adapted from the FastMediaSorter Android project's `.claude/` setup. Android-, PowerShell-,
and Russian-locale-specific machinery was removed; the transferable methodology was kept
and rewritten to be stack-neutral. No source code or proprietary content is included —
only the working method.
