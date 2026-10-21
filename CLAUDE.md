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
specification in [docs/specifications/](docs/specifications/DONE/SPECIFICATION_CONTRACTS_SYNC.md):

- **The site consumes** `PAGE-CONTENT` 1.5 (documentation / method page), `PAGE-STYLE` 3.4 (Informational /
  Docs, the shared stylesheet byte-identical in `assets/`, the locale query `?lang=` with the legacy `?l=` read as
  well), `SITE-FAMILY-MAP` 1.8 (footer family grid), the unified UI contracts `BUTTONS` 2.0, `UI-SIZING` 1.1 and
  `COLLAPSIBLE-GROUP` 1.1 (partial: measured in Chromium only, plan and deadline in
  [SPECIFICATION_UNIFIED_UI_CONTRACTS.md](docs/specifications/SPECIFICATION_UNIFIED_UI_CONTRACTS.md); the browser
  check is `python -I tools/ui-check/run.py --catalog <catalog root>`), and
  the opted-in iconography drafts `ICON-SET` 0.36, `ICON-RENDER` 0.24 (partial, as `UI-SIZING` is), `ICON-EXTERNAL`
  0.12. It also opted in (2026-10-09, owner decision) to the product-site drafts `SITE-STRUCTURE` 0.3,
  `SITE-EXPERIENCE` 0.4 and `SITE-REPRESENTATION` 0.1 at the declared **portal** tier: the page set is published
  (`portal/**`, `privacy.html`, `404.html`), the positioning source is [POSITIONING.md](POSITIONING.md), and what is
  still open is a dated registry exception. It creates no vocabulary, style or map of its own. The child-page
  footer was settled by the amendment of 2026-10-17 (item 2): a landing keeps the sibling grid and the contact,
  a child page needs the contact line and the hub link and may drop the grid. Every page here keeps all three on
  purpose, so a visitor on a function page can leave for a sibling.
- **The repository produces** `REPO-STAMP` 0.12 (`.sza-canon.json`, written only by the adoption skill) and
  **consumes** `REPO-LAYOUT` 0.11 and `RULE-DELIVERY` 0.12. `HARNESS-PROFILE` 0.12 is **not bound**: this
  repository never runs the packaged harness, so it keeps no `.sza-profile.json`, and the contract's rule 7
  reads that as a different fact from "the defaults apply" - declared so in its pointer and the registry row.
- **The kit is to carry guidance for** `CONTEXT-HELP` 0.1 (F1, a `?` button and a help page or layer for each
  window of an application): the contract names this repository in its consumers line for what the kit carries,
  not for surfaces, because no application window is drawn here. The verdict for the site's pages is "not
  applicable" and the pointer says why. `kit/` does not restate the convention yet: that is slice B of
  [SPECIFICATION_IN_APP_HELP.md](docs/specifications/SPECIFICATION_IN_APP_HELP.md) (Draft), whose change also
  lists the `kit/` files in the pointer, so a later change of the contract finds them.
- **Read, not adopted:** `DOC-EXTERNAL-QUALITY` 0.12 and `DOC-INTERNAL-QUALITY` 0.10 (drafts; no owner decision
  has opted this repository in, and each pointer says what an opt-in would meet).
- **Declared not applicable:** `INSTALL-TRUST` (the zip installs and executes nothing), `WAVE-PARTICLES`,
  `BOOLEAN-OPTION` and `SETTINGS-NAVIGATION` (no boolean option and no settings surface is drawn; each pointer says
  why), the desktop-app contracts, and every format this repository neither reads nor writes. The automated-checks
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
- `portal/**`, `privacy.html`, `404.html`, `assets/search-index.json` and the page list of `sitemap.xml` - the
  documentation portal and its trust pages, RU/EN/UK in each file, **generated** by
  `pwsh -NoProfile -File tools/build-portal.ps1` from [tools/portal/](tools/portal/README.md) (the capability
  inventory, the page content, the glossary) and [POSITIONING.md](POSITIONING.md). A page is changed in its
  source and rebuilt; a retired page leaves a forwarder, never a gap. `-Check` fails on drift.
- `README.md` and `kit/README.md` - the listing surfaces.

The product layer (`assets/site.css`) and the portal layer (`assets/portal.css`, `assets/portal.js`) are
hand-written and sit after the byte-identical kit stylesheet; they set no width cap and no centred column
on a page wrapper (`SITE-EXPERIENCE` rule 20). Every payload file of `kit/` must be a source of a portal
capability or be excluded with a reason in `tools/portal/inventory.json` - the portal build refuses
otherwise, so a `kit/` change that adds, renames or moves a file also changes the portal sources.

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

The site has its own offline gates, beside the build check and not inside any published page:

```powershell
pwsh -NoProfile -File tools/build-portal.ps1 -Validate   # sources: inventory, coverage of kit/, text style, links
pwsh -NoProfile -File tools/check-site.ps1               # held addresses, page width, page set, positioning, origins, portal freshness
```

Exit 0 from both before a change to the site, the portal sources or `kit/` is committed. What needs a
rendered page - focus order, contrast, reduced motion, the network panel - is run in a browser against
`SITE-CHECKLIST` and recorded in the adoption rows, never ticked from the source.
