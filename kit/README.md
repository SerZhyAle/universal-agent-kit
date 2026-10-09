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
layer** and are a minority. If your project compiles, you fill seventeen placeholders. If it does
not, you fill eleven and delete the rest - which is a supported path, not a degraded one.

---

## What is inside

```
universal-agent-kit/
  README.md                 <- you are here: import guide + manifest
  VERSION                   <- the kit's build date (one line); upgrades compare against it
  merge-prompt.txt          <- paste this to your agent to merge the kit safely (recommended path)
  AGENTS.md                 <- THE rules file - project-rules template (fill the <PLACEHOLDERS>)
  CLAUDE.md                 <- Claude Code entry point: imports AGENTS.md and the memory index
  .claude/
    settings.json           <- permission template (narrow git, destructive forms denied)
    skills/                 <- one folder per skill, SKILL.md inside (Agent Skills format)
      spec/                 <- strategic spec: what/why (template in references/)
      spec-tech/            <- tactical plan: phased, verifiable how (templates in references/)
      spec-dev/             <- execute the plan step by step
      spec-check/           <- audit the result against the spec
      spec-fix/             <- apply the audit's action items, re-audit
      spec-all/             <- run the whole pipeline end to end
      park/                 <- capture an out-of-scope finding as a Draft ticket, then resume
      backlog/              <- drain the backlog unattended, one eligible ticket at a time
      research/             <- research-first pass before any change
      quick/                <- fast path for trivial edits
      fix/                  <- narrow defect fix, no ceremony
      git/                  <- branch model, commit grouping, what-not-to-commit
      prove/                <- run it, observe, report one of four verdicts
      ui-clarify/           <- resolve reader-facing ambiguity before building
      surfaces/             <- every place a user-visible change shows, checked in one table
      critique/             <- terse, actionable review of a change
      caveman/              <- brevity mode for the whole chat
      caveman-commit/       <- terse Conventional Commit message
      caveman-review/       <- terse one-line-per-finding review
    agents/                 <- subagent definitions
      rd-lead.md            <- lead / orchestrator (opt in as the session agent)
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
    examples/               <- one sample entry per type, most of them not about code
  examples/                 <- reference only, never copied: one filled ticket (spec, plan, one
                               phase, audit) and a filled excerpt of the rules file
```

Every file is plain Markdown except `.claude/settings.json` (a small permission template for Claude
Code), `merge-prompt.txt` and the one-line `VERSION`. Nothing here runs on its own, calls an API, or hard-codes a language or
a framework. Where the source project wired in a specific tool, the kit states the *intent* and lets
your agent pick the equivalent.

---

## How to import (ask your agent to do this)

Unzip next to your project and paste `universal-agent-kit/merge-prompt.txt` into your agent. It
inventories your project, classifies it against `docs/PROJECT_SHAPES.md`, proposes a plan with every
placeholder resolved, and **stops for your approval** before it writes anything - on a new branch,
with backups, never overwriting a file of yours. That is the recommended path; the steps below are
what it does, for when you would rather do it by hand. To see what a filled rules file and a
finished ticket look like before you start, read `examples/`.

**No repository - a folder of documents?** The kit works the same; only the safety net changes
shape. Before the merge, copy the whole folder somewhere safe: that copy is your restore point, and
comparing against it is how you see "what changed since last time" (the merge prompt does this for
you instead of a branch). Skip `/git`, delete the `git` lines from `.claude/settings.json`, and read
"commit" in the rules as "keep a dated copy".

### For Claude Code (native)

1. Copy `.claude/skills/*` into your repo's `.claude/skills/`. Each folder becomes a skill you call
   as `/spec`, `/research`, `/git` and so on. Skills replace the older `.claude/commands/` files; if
   you hold a copy of the kit from before, `docs/REPLACES.md` has the rename table.
2. Copy `.claude/agents/*` into your repo's `.claude/agents/`. They become selectable subagents.
   Each declares an explicit `model:` tier rather than inheriting the session's - an unpinned spawn
   silently takes the most expensive model you have (`docs/COST.md`). The tier names are Claude
   Code's; on another runtime map them to its own.
3. Put `AGENTS.md` and `CLAUDE.md` at your repo root and fill the placeholders in `AGENTS.md`. If you
   already have a `CLAUDE.md`, add its two `@` import lines to yours instead of replacing it.
4. Optionally merge `.claude/settings.json` (review it first - see below).
5. Copy `docs/*` into a `docs/` folder at your repo root: the rules, skills and agents cite
   `docs/<NAME>.md` literally, so anywhere else means rewriting those references in the same change.
   Start with `PROJECT_SHAPES` if your project is not a codebase; skip `CODE_QUALITY` if it never will
   be. `REPLACES_RU.md` is a Russian mirror of `REPLACES.md` - skip it unless your team reads Russian.
6. Optionally copy `memory/` to your repo root - `CLAUDE.md` imports `memory/MEMORY.md` from there.
   It is the committed, team-shared memory; Claude Code's own auto memory stays per user
   (`docs/AGENT_MEMORY.md` says which fact goes where).

### Minimal start

Not ready for the full set? Take `AGENTS.md` (plus `CLAUDE.md` for Claude Code, minus its memory
import line), the whole `docs/` folder, `.claude/skills/quick/` and `.claude/skills/fix/`. The docs
cost nothing until a rule points the agent at one, and taking them all keeps every pointer true.
Then make the rules file name only what you shipped: search `AGENTS.md` for `/` followed by a skill
name, and delete or reword every line that names a skill you did not take - the list in section 4,
and the mentions of `/park`, `/ui-clarify`, `/surfaces`, `/prove` and `/spec` elsewhere. A rules file
that routes to a skill that is not there sends the agent looking for it. Add `/spec` the first time
a task carries real design decisions, and `memory/` once re-explaining things starts to hurt. Same
lowest-rung rule the kit preaches, applied to adopting it.

### For other agents (adaptation, not drop-in)

Two of the three pieces now travel on their own. The rules file is `AGENTS.md`, which most agent
tools read natively. The skills are in the open Agent Skills format (one folder with a `SKILL.md`),
which a growing list of tools loads - several straight from `.claude/skills/`, the others from
`.agents/skills/` (copy or link the folder there). The agents are the part that stays an
*adaptation*: they become custom agents, modes or system-prompt preambles. The `docs/` methodology is
tool-independent as-is. Concrete homes, as of 2026-10 (conventions move - check your tool's current
docs):

| Tool | Rules (`AGENTS.md`) | Skills (`.claude/skills/*`) | Agents (`.claude/agents/*`) |
| --- | --- | --- | --- |
| OpenAI Codex | `AGENTS.md`, nested ones too | `.agents/skills/` | system-prompt preambles |
| Cursor | `AGENTS.md`, or `.cursor/rules/*.mdc` | `.agents/skills/`, `.cursor/skills/`, or `.claude/skills/` as is | custom modes |
| GitHub Copilot / VS Code | `AGENTS.md`, or `.github/copilot-instructions.md` | `.github/skills/`, `.agents/skills/`, or `.claude/skills/` as is | `.github/agents/*.agent.md` |
| Gemini CLI | `GEMINI.md`, or `AGENTS.md` named in `context.fileName` | `.gemini/skills/` or `.agents/skills/` | system-prompt preambles |
| Cline | `AGENTS.md`, or a `.clinerules/` folder | `.cline/skills/` or `.claude/skills/` as is | mode presets |
| Windsurf | `AGENTS.md`, or its workspace rules folder | saved workflows | Cascade presets |
| Aider | `CONVENTIONS.md` loaded via `--read` | prompt files / aliases | single agent - fold into rules |

Some tools cap a rules file's size (one at 12,000 characters per file); the kit's `AGENTS.md` fits,
but watch it as you add rules. The mental model carries even where the file layout does not: one
always-loaded rules file, a set of named procedures you invoke, and a few role briefs.

---

## Fill these placeholders

Full reference with worked values per kind of project: `docs/REPLACES.md`.

**Tier 1 - every project:**

- `<PROJECT_NAME>` - your project's name.
- `<CHAT_LANGUAGE>` - the language the assistant talks to you in.
- `<ARTIFACT_LANGUAGE>` - the language of files, docs, logs and commits. English is the right
  default for code; a translator, a lawyer or an analyst delivers in the document's own language.
- `<INDEX_DOC>` - the map the agent reads first (`README.md`, an architecture doc, a data
  dictionary, a table of contents, a matter index).
- `<WORK_ROOT>` - where the project's real material lives.
- `<CHECK_CMD>` - **the command that proves a change is sound.** The one placeholder nobody may
  leave empty. If you are sure your project has none, read `docs/PROJECT_SHAPES.md` first - the
  five shapes a check takes in work that never compiles are listed there, and most projects already
  run one by hand.
- `<PLAN_DIR>` - where spec/plan files live (default `PLAN/`).
- `<SCRATCH_DIR>` - throwaway artifacts and backups, ignored by version control (default `tmp/`).
- `<SIZE_BUDGET>` - the file-size budget in lines past which you split along a real seam - a bare
  number (e.g. `500`); the templates already write `~` in front of it.
- `<READONLY_ZONES>` - paths the agent must never modify (vendored/generated material), or `none`.
- `<ID_SCHEME>` - the ticket id scheme (e.g. `T0042`, `JIRA-123`, a date-slug).

**Tier 2 - the code layer** (fill if your project builds or runs; otherwise delete the rules that
use them): `<ARCH_LAYERS>`, `<BUILD_CMD>`, `<TEST_CMD>`, `<LINT_CMD>`, `<RUN_CMD>`, `<LOGGER>`.

Template tokens like `<ID>`, `<slug>`, `<NN>`, `<TS>`, `<TODO>`, `<symbol>`, and `<path>` are *not*
config - they are filled per ticket as you use the skills (`<ID>` is one ticket's id, minted by
`<ID_SCHEME>`). So "no placeholder left" means none of the seventeen names above, not no `<` at all.

---

## The method in one screen

1. **Research before acting** (`/research`). Never guess a path or a fact. Read the map, then the
   material. Persist findings, don't search twice. `/prove` is how a claim about behaviour gets
   checked, and `/critique` how a change gets reviewed.
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

`.claude/settings.json` (Claude Code only) allows file reads and edits plus the git commands that
stage, commit and switch branches; it **asks** before a push or a rebase and **denies** force push,
hard reset, `git clean` and reading `.env` or `secrets/`. It deliberately does not allow `git *`,
which would pre-approve all of those. It sets no default permission mode (the runtime's own applies)
and no session agent (`claude --agent rd-lead` opts in). It does **not** pre-approve your
build/test/run commands - add the ones you trust (e.g. `Bash(npm run *)`). **Review it before
adopting**; the comment block at its top says why each line is there.

---

## Upgrading and removing

`VERSION` holds the build date of the kit you have. The merge prompt writes it into your rules file
as one line (`Adopted from universal-agent-kit <date>`); if you merged by hand, add that line
yourself. To **upgrade**, unzip the newer kit beside the older one and paste its `merge-prompt.txt`
with `MODE: UPGRADE` and the path of the older copy: it compares the two kits, shows you the
difference, and re-applies only that to your merged files, keeping your own edits. Without the older
copy it falls back to a fresh merge that treats every kit file you already have as yours.

To **remove** the kit, delete what it added and nothing else:

- `.claude/skills/` - the kit's skill folders (the names in the tree above);
- `.claude/agents/` - `rd-lead.md`, `solution-researcher.md`, `implementer.md`, `doc-writer.md`;
- `docs/` - the twelve files listed above, unless you have edited them into your own;
- the rules you merged into `AGENTS.md` (or your own rules file), the two `@` import lines in
  `CLAUDE.md`, and the `Adopted from` line;
- the lines you took from `.claude/settings.json`;
- `memory/` only if it still holds the example entries - real memories are yours;
- `<PLAN_DIR>/` and its tickets are your project's history, not the kit's: keep them.

---

## Provenance

Adapted from the `.claude/` setup of a real, mature mobile application - a multi-module product with
several store channels and a long ticket history. Platform-, shell-, and locale-specific machinery
was removed; the transferable methodology was kept and rewritten to be stack-neutral. The same core
has since been reconciled against a wider portfolio - desktop apps, command-line tools, a browser
extension, documentation sites - and the rules that survived every shape are the ones kept here. No
source code or proprietary content is included - only the working method.
