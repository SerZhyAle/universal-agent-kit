# Placeholder Replacements Reference

This document provides a comprehensive guide for replacing the configuration `<PLACEHOLDER>` tokens in `CLAUDE.md`, the skills (slash commands), and the agents when importing the **Universal Agent Kit** into your repository.

---

## Configuration Placeholders

These tokens must be replaced once during the initial setup/merge of the kit into your project.

| Placeholder Token | Description | Frontend / Node.js | Backend (Go / Python) | Mobile (Kotlin / Swift) | Systems (Rust / C++) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `<PROJECT_NAME>` | Name of your repository/project. | `my-web-app` | `user-service` | `photo-gallery` | `game-engine` |
| `<CHAT_LANGUAGE>` | Language the agent speaks to you. | `English` / `Russian` | `English` | `Russian` | `English` |
| `<INDEX_DOC>` | Project entry point / map file. | `README.md` | `docs/ARCH.md` | `README.md` | `README.md` |
| `<PLAN_DIR>` | Folder where spec/plan files live. | `PLAN` | `docs/plans` | `PLAN` | `PLAN` |
| `<SCRATCH_DIR>` | Git-ignored directory for temp files. | `tmp` | `.scratch` | `.scratch` | `.scratch` |
| `<ID>` | Ticket ID format / pattern. | `TNNNN` (e.g. `T0042`) | `JIRA-NNN` | `PG-NNN` | `TNNNN` |
| `<LOGGER>` | Logging call/facade name. | `logger.info` | `logging.info` / `log.Printf` | `Log.d` / `os_log` | `log::info!` |
| `<SRC_ROOT>` | Main source code directory. | `src` | `src` / `.` (root) | `app/src/main/java` | `src` |
| `<ARCH_LAYERS>` | Dependency direction rules. | `page -> widget -> api` | `handler -> service -> repo` | `UI -> VM -> Repo` | `mod -> impl -> core` |
| `<BUILD_CMD>` | Build command for compilation. | `npm run build` | `go build ./...` | `./gradlew assemble` | `cargo build` |
| `<TEST_CMD>` | Command to run unit/integration tests. | `npm test` | `pytest` / `go test ./...` | `./gradlew test` | `cargo test` |
| `<LINT_CMD>` | Command to run static analysis. | `npm run lint` | `flake8` / `golangci-lint run` | `./gradlew lint` | `cargo clippy` |
| `<RUN_CMD>` | Command to launch the dev environment. | `npm run dev` | `python main.py` | `./gradlew installDebug` | `cargo run` |
| `<MAX_LOC>` | File size limit before refactoring. | `500` | `400` | `600` | `500` |
| `<READONLY_ZONES>`| Path zones the agent must never write to. | `dist, node_modules` | `vendor, .venv` | `build` | `target` |

---

## Detailed Placeholder Reference

### `<PROJECT_NAME>`
The name of the project. Used in title headers and logging comments to scope the agent's work.
* *Example:* `universal-agent-kit`

### `<CHAT_LANGUAGE>`
The conversational language between the human and the AI assistant. Note that code, symbols, commit messages, and comments should remain in English regardless of this setting to maintain consistency.
* *Example:* `Russian` or `English`

### `<INDEX_DOC>`
The entry point file where the agent starts researching the codebase map. It should contain high-level architecture details, project setup instructions, or links to other documentation.
* *Example:* `README.md` or `docs/ARCHITECTURE.md`

### `<PLAN_DIR>`
The directory that holds specification and plan markdown files. The kit relies on structured specs to split *what* from *how*.
* *Example:* `PLAN/`

### `<SCRATCH_DIR>`
A folder used by the agent to store temporary scratch files, script outputs, or pre-edit backups. This directory **must be added to `.gitignore`**.
* *Example:* `tmp/` or `.scratch/`

### `<ID>`
The ticket ID prefix formatting pattern. The kit groups work by tickets (e.g., spec files named `<PLAN_DIR>/<ID>_<slug>.md`).
* *Example:* `T0042` or `PROJ-101`

### `<LOGGER>`
The project's logging utility. The anti-slop rules forbid raw console logging or prints in production code. Any debug logs must go through this facade.
* *Example:* `logger.debug` (a winston/pino wrapper for JS), `logging.info` (Python), or `Log.d` (Android). Point this at a real facade - a bare `console.log`/`print` is exactly what the anti-slop rule bans.

### `<SRC_ROOT>`
The primary source code root where the application logic resides. Keeps the agent focused on actual code directories during searches.
* *Example:* `src/` or `app/src/main/`

### `<ARCH_LAYERS>`
Specifies the architectural boundaries and the allowed direction of dependencies. E.g., `A -> B -> C` means layer A can import layer B, but B cannot import A.
* *Example:* `controller -> service -> repository`

### `<BUILD_CMD>`, `<TEST_CMD>`, `<LINT_CMD>`, `<RUN_CMD>`
The shell commands used to compile, test, lint, and run the project. The agent uses these commands to verify that code changes do not break the project.
* *Examples:*
  * Build: `npm run build` | `go build ./...` | `mvn compile`
  * Test: `npm test` | `pytest` | `cargo test`
  * Lint: `npm run lint` | `golangci-lint run` | `cargo clippy`
  * Run: `npm run dev` | `python main.py` | `cargo run`

### `<MAX_LOC>`
The lines-of-code limit for a single file. Used as a heuristic to enforce modularity and cohesion. If a file exceeds this limit, the agent should extract code into helpers.
* *Example:* `500`

### `<READONLY_ZONES>`
Comma-separated paths that the agent is strictly prohibited from modifying (e.g., third-party libraries, generated code, database migrations).
* *Example:* `node_modules/, vendor/, gen/`

---

## Transient Template Tokens

These tokens are **not** configuration values. They are dynamic placeholders filled on the fly by you or the agent during daily workflow execution:

* `<slug>` - A short, hyphenated description of the ticket (e.g., `add-login-button`).
* `<NN>` / `<NNNN>` - A short sequence number for a phase or a research artifact (e.g., `01`, `0042`) - not the ticket id itself.
* `<TS>` - A timestamp slug for scratch filenames (e.g., `20260702_1530`), used by `/verify` and `/research`.
* `<TODO>` - An action item or unimplemented task.
* `<symbol>` - A code class, function, struct, or variable name.
* `<path>` - A file or folder path.
* `???` - An unresolved decision or check.
* `$ARGUMENTS` - Claude Code injects whatever you typed after the slash command here. In other tools it is the text after your saved-prompt trigger - substitute your tool's equivalent.
