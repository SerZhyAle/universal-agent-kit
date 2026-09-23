# Repository Guidelines

## Project Structure & Module Organization

This repository publishes the Universal Agent Kit and its GitHub Pages article. The root `index.html` is the trilingual site; `README.md` is the repository landing page. Treat `kit/` as the product source: it contains the portable rule templates, `.claude/` commands and agent briefs, `docs/` methodology, and `memory/` examples. `merge-prompt.txt` accompanies the kit. `universal-agent-kit.zip`, `sitemap.xml`, and the date shown in `index.html` are generated release surfaces. `tools/build-kit.ps1` owns their rebuild.

## Build, Test, and Development Commands

Run the release check after changing `kit/` or `merge-prompt.txt`:

```powershell
pwsh -NoProfile -File tools/build-kit.ps1
```

It recreates `universal-agent-kit.zip`, verifies each archive entry against `kit/` using SHA-256, and updates the kit date in `index.html` and `sitemap.xml`. Supply `-Date yyyy-MM-dd` for a deliberate release date. There is no application runtime or unit-test suite; this script is the primary mechanical validation.

Before committing, also run the configured compliance gate when the shared canon plugin is available:

```powershell
pwsh -File "$env:CLAUDE_PLUGIN_ROOT/tools/check-compliance.ps1"
```

## Content Style & Naming

Use concise English Markdown with meaningful headings and relative links. Keep kit content stack-neutral and preserve `<PLACEHOLDER>` tokens for downstream adopters. Do not add local product names, portfolio paths, or private infrastructure to `kit/`. Maintain the existing formatting in `index.html`; when changing reader-facing site copy, keep its English, Russian, and Ukrainian versions aligned. Name documentation in uppercase snake case (for example, `VALIDATION.md`); use lowercase kebab case for command files such as `spec-tech.md`.

## Generated Artifacts and Validation

Never hand-edit `universal-agent-kit.zip`, the displayed kit-update date, JSON-LD `dateModified`, or `sitemap.xml` dates. Change the source, then run the build script and review its `PASS` result plus `git diff`. A change to `kit/` is a product change: consult `kit/docs/AUTHORING.md` when introducing rules, commands, or role briefs.

## Commits & Pull Requests

Use concise, imperative subjects. Existing history uses optional scoped prefixes such as `kit: ...` and `chore: ...`; follow that pattern where it clarifies scope. Keep generated files in the same commit as their source changes. Pull requests should explain the user-facing or methodology change, list validation run, link relevant issues or specifications, and include screenshots for visible `index.html` changes.
