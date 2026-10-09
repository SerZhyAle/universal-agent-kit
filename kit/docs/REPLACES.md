# Placeholder Replacements Reference

How to fill the `<PLACEHOLDER>` tokens in the rules files (`AGENTS.md`, `CLAUDE.md`), the skills
(`.claude/skills/`), and the agents when importing the **Universal Agent Kit** into your project.

There are two tiers. **Fill tier 1 always.** Fill tier 2 only if your project compiles or runs -
and if it does not, delete the rules that use those tokens rather than inventing values for them. A
rule pointing at a placeholder nobody filled is the fastest way to teach everyone to skim the
rulebook.

A good first move after copying the kit in: ask your agent to grep it for `<` + `>` tokens and
propose a value for each from the actual project.

---

## Tier 1 - every project

These eleven apply to any project that has files, work items and checks.

| Token | What it is | Software | Data & analysis | Writing & docs | Legal & ops |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `<PROJECT_NAME>` | The project's name. | `user-service` | `q3-churn-model` | `platform-handbook` | `acme-msa-2026` |
| `<CHAT_LANGUAGE>` | The language the agent talks to you in. | `English` | `English` | `Russian` | `English` |
| `<ARTIFACT_LANGUAGE>` | The language of files, docs, logs and commits. | `English` | `English`, or the team's language | `Russian` (the manuscript's language) | `German` (legal: the jurisdiction's; ops: the team's) |
| `<INDEX_DOC>` | The map the agent reads first. | `README.md` | `docs/DATA_DICTIONARY.md` | `SUMMARY.md` | `MATTER_INDEX.md` |
| `<WORK_ROOT>` | Where the project's real material lives. | `src` | `pipelines` | `content` | `drafts` |
| `<CHECK_CMD>` | The command that proves a change is sound. The one nobody may leave empty. | `npm test` | `make validate` (schema + row counts) | `npm run lint:docs` (links, headings, terms) | `pwsh tools/check-terms.ps1` |
| `<PLAN_DIR>` | Where spec/plan files live. | `PLAN` | `PLAN` | `PLAN` | `PLAN` |
| `<SCRATCH_DIR>` | Throwaway artifacts and backups, ignored by version control. | `tmp` | `.scratch` | `tmp` | `tmp` |
| `<SIZE_BUDGET>` | Line count past which a file gets split along a real seam. A bare number: the templates add the `~` and the unit. | `500` | `400` | `800` (one chapter) | `1200` (one agreement) |
| `<READONLY_ZONES>` | Paths the agent must never modify. | `dist, node_modules` | `data/raw` | `locales/generated` | `executed, filed` |
| `<ID_SCHEME>` | The ticket id scheme, filled once. Not `<ID>` - see below. | `T0042` | `AN-042` | `DOC-042` | `M-042` |

### The ones worth a second thought

**`<CHECK_CMD>`** - the most valuable line in the file. It answers "what command tells me this
change is not broken?", and it is the placeholder people skip because they believe their project
has nothing mechanical in it. That belief is usually false: `PROJECT_SHAPES.md` lists the five
shapes a check takes in work that never compiles (a total that must match another total, a name
that must exist elsewhere, a structure that must hold, a reference that must resolve, a rendering
that must succeed). Point this at the cheapest real one you have, today, and improve it later.

**`<INDEX_DOC>`** - not just something to read, something to *maintain*. It is where the agent's
research order starts, so a stale map costs a wrong turn on every task (`RESEARCH_INDEX.md`).

**`<CHAT_LANGUAGE>`** and **`<ARTIFACT_LANGUAGE>`** - two settings, because talking and delivering
are different jobs. The chat language is what the agent speaks to you. The artifact language is
what it writes into files, docs, logs and commits: English by default for a code project, so the
project stays readable to anyone who joins it; a lawyer, a translator or an analyst may deliver in
the document's own language instead.

**`<READONLY_ZONES>`** - vendored code, generated output, raw data, anything already executed or
filed. Write `none` if there is nothing; an empty value reads as an unfinished merge.

**`<SIZE_BUDGET>`** - a heuristic for "this file does too many things", not a law. Set it where
your own review starts complaining.

---

## Tier 2 - the code layer

Fill these if your project builds or runs. If it does not, delete the rules that reference them -
the code-layer rules and the verification-tag rule in the rules file (`AGENTS.md`), the structural
rules in `CODE_QUALITY.md`, and the stack lines in the `implementer` and `rd-lead` agents.

| Token | What it is | Frontend / Node.js | Backend (Go / Python) | Mobile (Kotlin / Swift) | Systems (Rust / C++) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `<ARCH_LAYERS>` | Dependency direction. | `page -> widget -> api` | `handler -> service -> repo` | `UI -> VM -> Repo` | `mod -> impl -> core` |
| `<BUILD_CMD>` | Build / compile. | `npm run build` | `go build ./...` | `./gradlew assemble` | `cargo build` |
| `<TEST_CMD>` | Unit / integration tests. | `npm test` | `pytest` / `go test ./...` | `./gradlew test` | `cargo test` |
| `<LINT_CMD>` | Static analysis. | `npm run lint` | `golangci-lint run` | `./gradlew lint` | `cargo clippy` |
| `<RUN_CMD>` | Launch it. | `npm run dev` | `python main.py` | `./gradlew installDebug` | `cargo run` |
| `<LOGGER>` | The logging facade. | `logger.info` | `logging.info` / `log.Printf` | `Log.d` / `os_log` | `log::info!` |

`<LOGGER>` must name a real facade: a bare `console.log` / `print` is exactly what the anti-slop
rule bans. `<ARCH_LAYERS>` reads left-to-right as "may depend on": `A -> B` means A imports B and
never the reverse. Where a project genuinely has no layering, write `n/a` rather than inventing one.

The four command tokens are refinements of `<CHECK_CMD>`, not replacements for it: the kit's rules
reach for the narrowest one that proves the change (`VALIDATION.md`), so having all five filled is
what lets it pick a compile over a full build.

---

## Transient template tokens

These are **not** configuration. They are filled on the fly, per ticket, as you use the skills:

* `<ID>` - one ticket's id under `<ID_SCHEME>` (`T0042`), filled each time a ticket is made, never at
  merge time. A merge that writes a fixed id into the skills breaks every ticket after the first.
* `<slug>` - a short hyphenated description of the ticket (`add-login-button`).
* `<NN>` / `<NNNN>` - a sequence number for a phase or a research artifact (`01`, `0042`) - not the
  ticket id itself.
* `<TS>` - a timestamp slug for scratch filenames (`20260702_1530`), used by `/prove`.
* `<TODO>` - an action item or unfinished piece.
* `<symbol>` - a name in the material: a class, a function, a column, a defined term.
* `<path>` - a file or folder path.
* `???` - an unresolved decision or check.
* `$ARGUMENTS` - Claude Code injects whatever you typed after the skill's name here. In other
  tools it is the text after your saved-prompt trigger - substitute your tool's equivalent.

---

## Coming from an earlier copy of the kit

What was renamed, moved or added since earlier copies:

| Was | Now | Why |
| :--- | :--- | :--- |
| `<SRC_ROOT>` | `<WORK_ROOT>` | The material is not always source. |
| `<MAX_LOC>` | `<SIZE_BUDGET>` | Lines of code is one unit among several. |
| - | `<CHECK_CMD>` | The generic proof step the four build tokens specialize. |
| `<ID>` (the setting) | `<ID_SCHEME>` | One name was doing two jobs: the scheme, filled once, and one ticket's id, filled per ticket. |
| "Artifacts: English", fixed | `<ARTIFACT_LANGUAGE>` | A contract or a manuscript is delivered in its own language. |
| `/verify` | `/prove` | The old name shadowed a command the runtime ships. |
| `/review` | `/critique` | The old name shadowed a command the runtime ships. |
| `.claude/commands/<name>.md` | `.claude/skills/<name>/SKILL.md` | Skills are the runtime's current format, and the one other agent tools read too. |

A find-and-replace over your filled-in copy covers `<WORK_ROOT>` and `<SIZE_BUDGET>`.
`<CHECK_CMD>` has no old value to carry over: pick the cheapest check you already run by hand, and
write it down. Rename `<ID>` to `<ID_SCHEME>` only where it names the setting - never globally, since
the skills use `<ID>` per ticket; if an earlier merge wrote a fixed id such as `T0042` into the
skills, put `<ID>` back. `<ARTIFACT_LANGUAGE>` is new: `English` keeps the old behaviour. For the
two renamed skills and the folder move, copy `.claude/skills/` from the new kit, fill its
placeholders, and delete the old `.claude/commands/` files - left in place, `/verify` and `/review`
keep shadowing the runtime's own.
