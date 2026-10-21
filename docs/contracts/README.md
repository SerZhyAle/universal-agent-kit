# Shared-contract pointers

This directory identifies the shared contracts this repository touches, without copying their text. Each
file names the contract id, its version, its home in the catalog, this repository's role, and what
conformance requires.

| Pointer | Version | Role | Surface |
| --- | --- | --- | --- |
| [`PAGE-CONTENT.md`](PAGE-CONTENT.md) | 1.5 | consumer | `index.html` |
| [`PAGE-STYLE.md`](PAGE-STYLE.md) | 3.4 | consumer, partial | `index.html`, `assets/sza-kit.css`, the locale query of every page |
| [`BUTTONS.md`](BUTTONS.md) | 2.0 | consumer, partial | every command button of the 55 pages |
| [`UI-SIZING.md`](UI-SIZING.md) | 1.1 | consumer, partial | profile, size and the footer choice of every page |
| [`COLLAPSIBLE-GROUP.md`](COLLAPSIBLE-GROUP.md) | 1.1 | consumer, partial | the numbered sections and prompt disclosures of the landing |
| [`BOOLEAN-OPTION.md`](BOOLEAN-OPTION.md) | 2.0 | declared not applicable | none - no boolean option is drawn |
| [`SETTINGS-NAVIGATION.md`](SETTINGS-NAVIGATION.md) | 2.0 | declared not applicable | none - no settings surface exists |
| [`SITE-FAMILY-MAP.md`](SITE-FAMILY-MAP.md) | 1.8 | consumer | `index.html` footer, `README.md` |
| [`SITE-STRUCTURE.md`](SITE-STRUCTURE.md) | 0.3 | consumer, portal tier declared | the site page set, addresses, locales |
| [`SITE-EXPERIENCE.md`](SITE-EXPERIENCE.md) | 0.4 | consumer, portal tier | every page's layers, behaviour, search, origins, reach |
| [`SITE-REPRESENTATION.md`](SITE-REPRESENTATION.md) | 0.1 | consumer, portal tier | `POSITIONING.md`, what every page claims about the product |
| [`ICON-SET.md`](ICON-SET.md) | 0.36 | consumer, opted in | every page's glyphs |
| [`ICON-RENDER.md`](ICON-RENDER.md) | 0.24 | consumer, opted in, partial | every page's glyphs |
| [`ICON-EXTERNAL.md`](ICON-EXTERNAL.md) | 0.12 | consumer, opted in | `index.html` imagery |
| [`CONTEXT-HELP.md`](CONTEXT-HELP.md) | 0.1 | guidance only; the site's pages not applicable | `kit/` text for projects that have a user interface (not yet written) |
| [`DOC-EXTERNAL-QUALITY.md`](DOC-EXTERNAL-QUALITY.md) | 0.12 | read, not adopted | the portal, through the site contracts that cite it |
| [`DOC-INTERNAL-QUALITY.md`](DOC-INTERNAL-QUALITY.md) | 0.10 | read, not adopted | `docs/specifications/`, `docs/contracts/`, `PLAN/` |
| [`REPO-STAMP.md`](REPO-STAMP.md) | 0.12 | producer | `.sza-canon.json` |
| [`REPO-LAYOUT.md`](REPO-LAYOUT.md) | 0.11 | consumer | root files, `docs/` |
| [`RULE-DELIVERY.md`](RULE-DELIVERY.md) | 0.12 | consumer | the `sza` plugin |
| [`HARNESS-PROFILE.md`](HARNESS-PROFILE.md) | 0.12 | not bound | none - declared not bound (rule 7) |

`HARNESS-PROFILE` is not bound: this repository never runs the shipped harness, so it has no
`.sza-profile.json` for that reason, which rule 7 of the contract reads as a different fact from "the
defaults apply". The contracts declared not applicable are listed in
[SPECIFICATION_CONTRACTS_SYNC.md](../specifications/DONE/SPECIFICATION_CONTRACTS_SYNC.md).
