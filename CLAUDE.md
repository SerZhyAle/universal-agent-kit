# CLAUDE.md - universal-agent-kit (the public kit and its site)

Agent rules for working **on** this repository. The universal conventions are not restated here; they
arrive as the `sza` plugin's skills and rule docs.

## Canon

- Plugin `sza`, from the public marketplace repo `SerZhyAle/sza-unified-rules`. Consumption model:
  **reference** - the canon is pointed at, never copied into this repo.
- No platform overlay: this repo builds no product. [.sza-canon.json](.sza-canon.json) says so with
  `role: portfolio`, and its `$comment` says why.
- Per-project record: `rules/contrib/universal_agent_kit.md`, in the canon repo.

## Shared contracts

The portfolio's shared contracts - the formats, algorithms and boundary behaviours that outlive one
repository - live in one catalog outside every repo, at `P:\Contracts`, organized by function. **This
section is the only place in this repository that names it.** Everything else cites a contract by id -
`<DOCUMENT>.md section N`, `<ID> rule N` - and never links to it, because whoever clones this repo does not
have that drive. A pointer would go in `docs/contracts/`; the contract text itself never does.

What this repository touches, each with a pointer in [docs/contracts/](docs/contracts/README.md) and a
specification in [docs/specifications/](docs/specifications/SPECIFICATION_CONTRACTS_SYNC.md):

- **The site consumes** `PAGE-CONTENT` 1.1 (documentation / method page), `PAGE-STYLE` 1.0 (Informational /
  Docs, the shared stylesheet byte-identical in `assets/`), `SITE-FAMILY-MAP` 1.1 (footer family grid), and
  the opted-in iconography drafts `ICON-SET` 0.13, `ICON-RENDER` 0.11, `ICON-EXTERNAL` 0.9. It creates no
  vocabulary, style or map of its own.
- **The repository produces** `REPO-STAMP` 0.9 (`.sza-canon.json`, written only by the adoption skill) and
  **consumes** `REPO-LAYOUT` 0.9 and `RULE-DELIVERY` 0.9. `HARNESS-PROFILE` has no role: no
  `.sza-profile.json`, and the packaged harness is not run here.
- **Declared not applicable:** `INSTALL-TRUST` (the zip installs and executes nothing), `WAVE-PARTICLES`,
  the desktop-app contracts, and every format this repository neither reads nor writes. The automated-checks
  drafts are not bound; the build check aligns with them voluntarily.

`kit/` is method - how we develop - which the catalog keeps out by name, and the canon owns instead.

Like the canon pointer, this one must never be added under `kit/`, for the same reason: the kit
re-expresses shared method for an outside audience, it does not advertise where the portfolio keeps its
own material.

## `kit/` is product payload, not this repo's rules

`kit/CLAUDE.md`, `kit/AGENTS.md`, `kit/.claude/**` and `kit/docs/**` are a `<PLACEHOLDER>` template that a
stranger downloads and fills in for their own project. **This file is the authoritative agent-rules file
for work here**; the root [AGENTS.md](AGENTS.md) is its companion for agents that read that name, carries
the same canon pointer, and yields to this file where they differ, unless it is stricter. Everything below
follows from that one distinction:

- **Never apply `kit/CLAUDE.md` to work in this repo.** It addresses the downstream user, and its
  placeholders resolve to their project, not to this one.
- **`kit/` stays scrubbed and stack-neutral.** No product name, no portfolio path, no private repo layout,
  no canon-internal doc name. The canon pointer lives in *this* file and must never be added under `kit/` -
  the kit re-expresses shared method for an outside audience, it does not advertise where that method is
  maintained.
- **Editing `kit/` is a product change.** Hold it to the kit's own standard: `kit/docs/AUTHORING.md` for a
  new rule, gate, skill or agent - authored against a failure actually observed, naming the excuse it
  closes.

## Render targets - never hand-edit

`kit/` is the source. Two surfaces are rendered from it and one describes it:

- `universal-agent-kit.zip` - the distributable. Extraction root `universal-agent-kit/` is a **frozen
  anchor**: every published unzip instruction depends on it. Rebuild the zip from `kit/`; never edit inside
  it. It is tracked on purpose, with the reason in [.gitignore](.gitignore).
- `index.html` - the site, RU/EN/UK in one file, served by GitHub Pages from `main` at the repo root
  (`https://serzhyale.github.io/universal-agent-kit/`). The published domain and the repo name are frozen
  anchors too.
- `README.md` and `kit/README.md` - the listing surfaces.

A `kit/` change that does not reach the zip and the page ships a kit whose download disagrees with its own
documentation. `pwsh -NoProfile -File tools/build-kit.ps1` is the one way to rebuild the zip: it verifies
every entry against `kit/` and stamps the build date into the page's "Kit updated" line, JSON-LD
`dateModified` and `sitemap.xml` - so that date is a render target too, never hand-edited.

## Release shape

Rolling: no tags, no changelog, no version anchor - the site and the zip are regenerated in place. That is
a recorded DIVERGE from the canon's version-shape rule, legitimate for a living reference kit, and it is
why the stamp carries `tagRegex: null` and `ledgerShape: "none"`.

## Gate

```powershell
$sza = ((Get-Content "$HOME/.claude/plugins/installed_plugins.json" -Raw | ConvertFrom-Json).plugins.'sza@sza-unified-rules' |
    Sort-Object lastUpdated -Descending | Select-Object -First 1).installPath
pwsh -NoProfile -File "$sza/tools/check-compliance.ps1"
```

`CLAUDE_PLUGIN_ROOT` is expanded only for the plugin's own hooks, never in a tool shell, so the bare
`$env:CLAUDE_PLUGIN_ROOT/tools/..` form dies with exit 64; resolve the root from the install record.

Exit 0 before committing anything at the repo root or under `kit/`.
