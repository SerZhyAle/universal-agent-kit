# CLAUDE.md - Claude Code entry point for `<PROJECT_NAME>`

The rules live in one file, `AGENTS.md`, which every agent tool reads; this file imports it and adds
only what is specific to Claude Code. Edit the rules there, never here - two rules files drift.

@AGENTS.md
@memory/MEMORY.md

## Claude Code specifics
- Skills are in `.claude/skills/<name>/SKILL.md`; a skill's long templates sit beside it in
  `references/` and are read only when the skill needs them.
- Agents are in `.claude/agents/`, each pinned to a model tier. `claude --agent rd-lead` makes the
  lead the whole session's agent - an opt-in: it replaces the default system prompt with that brief.
- `/prove` and `/critique` are named so they do not shadow the built-in `/verify` and `/review`.
- Permissions are in `.claude/settings.json`; a Bash deny rule stops the usual form of a command, it
  is not a security boundary. Hooks, and why the blocking exit code is 2: `docs/HOOKS.md`.
- Plan mode is the native home of `/spec`'s rule - agree the what before the how. Headless runs
  (`claude -p`) are the native driver for an unattended `/backlog` (`docs/PARALLEL.md`).
