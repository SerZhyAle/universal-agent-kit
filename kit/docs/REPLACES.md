# Placeholder Replacements Reference

How to fill the `<PLACEHOLDER>` tokens in `CLAUDE.md`, the skills (slash commands), and the agents
when importing the **Universal Agent Kit** into your project.

There are two tiers. **Fill tier 1 always.** Fill tier 2 only if your project compiles or runs -
and if it does not, delete the rules that use those tokens rather than inventing values for them. A
rule pointing at a placeholder nobody filled is the fastest way to teach everyone to skim the
rulebook.

A good first move after copying the kit in: ask your agent to grep it for `<` + `>` tokens and
propose a value for each from the actual project.

---

## Tier 1 - every project

These ten apply to any project that has files, work items and checks.

| Token | What it is | Software | Data & analysis | Writing & docs | Legal & ops |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `<PROJECT_NAME>` | The project's name. | `user-service` | `q3-churn-model` | `platform-handbook` | `acme-msa-2026` |
| `<CHAT_LANGUAGE>` | The language the agent talks to you in. Artifacts stay English. | `English` | `English` | `Russian` | `English` |
| `<INDEX_DOC>` | The map the agent reads first. | `README.md` | `docs/DATA_DICTIONARY.md` | `SUMMARY.md` | `MATTER_INDEX.md` |
| `<WORK_ROOT>` | Where the project's real material lives. | `src` | `pipelines` | `content` | `drafts` |
| `<CHECK_CMD>` | The command that proves a change is sound. The one nobody may leave empty. | `npm test` | `make validate` (schema + row counts) | `npm run lint:docs` (links, headings, terms) | `pwsh tools/check-terms.ps1` |
| `<PLAN_DIR>` | Where spec/plan files live. | `PLAN` | `PLAN` | `PLAN` | `PLAN` |
| `<SCRATCH_DIR>` | Throwaway artifacts and backups, ignored by version control. | `tmp` | `.scratch` | `tmp` | `tmp` |
| `<SIZE_BUDGET>` | Size past which a file gets split along a real seam. | `500` lines | `400` lines | `800` lines (one chapter) | `1200` lines (one agreement) |
| `<READONLY_ZONES>` | Paths the agent must never modify. | `dist, node_modules` | `data/raw` | `locales/generated` | `executed, filed` |
| `<ID>` | The ticket id scheme. | `T0042` | `AN-042` | `DOC-042` | `M-042` |

### The ones worth a second thought

**`<CHECK_CMD>`** - the most valuable line in the file. It answers "what command tells me this
change is not broken?", and it is the placeholder people skip because they believe their project
has nothing mechanical in it. That belief is usually false: `PROJECT_SHAPES.md` lists the five
shapes a check takes in work that never compiles (a total that must match another total, a name
that must exist elsewhere, a structure that must hold, a reference that must resolve, a rendering
that must succeed). Point this at the cheapest real one you have, today, and improve it later.

**`<INDEX_DOC>`** - not just something to read, something to *maintain*. It is where the agent's
research order starts, so a stale map costs a wrong turn on every task (`RESEARCH_INDEX.md`).

**`<CHAT_LANGUAGE>`** - the conversational language only. Code, symbols, commit messages, file
names and comments stay English regardless, so the project stays readable to anyone who joins it.

**`<READONLY_ZONES>`** - vendored code, generated output, raw data, anything already executed or
filed. Write `none` if there is nothing; an empty value reads as an unfinished merge.

**`<SIZE_BUDGET>`** - a heuristic for "this file does too many things", not a law. Set it where
your own review starts complaining.

---

## Tier 2 - the code layer

Fill these if your project builds or runs. If it does not, delete the rules that reference them -
`CLAUDE.md` section 7's code-layer bullet, section 6 (verification tags), the structural rules in
`CODE_QUALITY.md`, and the stack lines in the `implementer` and `rd-lead` agents.

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

* `<slug>` - a short hyphenated description of the ticket (`add-login-button`).
* `<NN>` / `<NNNN>` - a sequence number for a phase or a research artifact (`01`, `0042`) - not the
  ticket id itself.
* `<TS>` - a timestamp slug for scratch filenames (`20260702_1530`), used by `/verify` and
  `/research`.
* `<TODO>` - an action item or unfinished piece.
* `<symbol>` - a name in the material: a class, a function, a column, a defined term.
* `<path>` - a file or folder path.
* `???` - an unresolved decision or check.
* `$ARGUMENTS` - Claude Code injects whatever you typed after the slash command here. In other
  tools it is the text after your saved-prompt trigger - substitute your tool's equivalent.

---

## Coming from an earlier copy of the kit

Two tokens were renamed when the kit stopped assuming its projects were codebases, and one is new:

| Was | Now | Why |
| :--- | :--- | :--- |
| `<SRC_ROOT>` | `<WORK_ROOT>` | The material is not always source. |
| `<MAX_LOC>` | `<SIZE_BUDGET>` | Lines of code is one unit among several. |
| - | `<CHECK_CMD>` | The generic proof step the four build tokens specialize. |

A find-and-replace over your filled-in copy covers the first two. The third has no old value to
carry over: pick the cheapest check you already run by hand, and write it down.
