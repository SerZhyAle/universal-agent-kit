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

This repository consumes `ICON-SET` 0.10, `ICON-RENDER` 0.10 and `ICON-EXTERNAL` 0.9 as the static site's
icon consumer. The site maps each interface glyph to the vocabulary, uses the contract's rendering roles,
and records its conformance in `docs/contracts/`; it creates no icon vocabulary or contract artifact.
`kit/` is method - how we develop - which the catalog keeps out by name, and the canon owns instead.

Like the canon pointer, this one must never be added under `kit/`, for the same reason: the kit
re-expresses shared method for an outside audience, it does not advertise where the portfolio keeps its
own material.

## `kit/` is product payload, not this repo's rules

`kit/CLAUDE.md`, `kit/AGENTS.md`, `kit/.claude/**` and `kit/docs/**` are a `<PLACEHOLDER>` template that a
stranger downloads and fills in for their own project. **This file is the only agent-rules file that
governs work here.** Everything below follows from that one distinction:

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
pwsh -File "$env:CLAUDE_PLUGIN_ROOT/tools/check-compliance.ps1"
```

Exit 0 before committing anything at the repo root or under `kit/`.
