# AGENTS.md

Same contract, cross-tool name. This kit's always-loaded rulebook ships as
[`CLAUDE.md`](CLAUDE.md) - Claude Code's native filename; the content itself is tool-neutral.

If your tool reads `AGENTS.md` (OpenAI Codex and a growing list of tools follow this
convention), pick one:

- **Keep this pointer.** Read `CLAUDE.md` in this folder in full and treat it as the project's
  agent contract.
- **Rename.** Move `CLAUDE.md`'s content into `AGENTS.md` and delete this pointer - then grep
  the kit for `CLAUDE.md` and update every reference (they live in `.claude/`, `docs/`, and
  this kit's `README.md`).

Either way, keep exactly **one** canonical rules file. A duplicated rulebook drifts, and a
drifted rulebook is worse than none - the same single-source-of-truth rule the kit applies to
everything else.
