# Shared-contract pointers

This directory identifies the shared contracts this repository touches, without copying their text. Each
file names the contract id, its version, its home in the catalog, this repository's role, and what
conformance requires.

| Pointer | Version | Role | Surface |
| --- | --- | --- | --- |
| [`PAGE-CONTENT.md`](PAGE-CONTENT.md) | 1.4 | consumer | `index.html` |
| [`PAGE-STYLE.md`](PAGE-STYLE.md) | 1.6 | consumer | `index.html`, `assets/sza-kit.css` |
| [`SITE-FAMILY-MAP.md`](SITE-FAMILY-MAP.md) | 1.4 | consumer | `index.html` footer, `README.md` |
| [`SITE-STRUCTURE.md`](SITE-STRUCTURE.md) | 0.1 | consumer, portal tier declared | the site page set, addresses, locales |
| [`SITE-EXPERIENCE.md`](SITE-EXPERIENCE.md) | 0.3 | consumer | `index.html` behaviour, origins, reach |
| [`SITE-REPRESENTATION.md`](SITE-REPRESENTATION.md) | 0.1 | consumer | what the site claims about the product |
| [`ICON-SET.md`](ICON-SET.md) | 0.29 | consumer, opted in | `index.html` glyphs |
| [`ICON-RENDER.md`](ICON-RENDER.md) | 0.18 | consumer, opted in | `index.html` glyphs |
| [`ICON-EXTERNAL.md`](ICON-EXTERNAL.md) | 0.12 | consumer, opted in | `index.html` imagery |
| [`REPO-STAMP.md`](REPO-STAMP.md) | 0.12 | producer | `.sza-canon.json` |
| [`REPO-LAYOUT.md`](REPO-LAYOUT.md) | 0.11 | consumer | root files, `docs/` |
| [`RULE-DELIVERY.md`](RULE-DELIVERY.md) | 0.12 | consumer | the `sza` plugin |
| [`HARNESS-PROFILE.md`](HARNESS-PROFILE.md) | 0.11 | not bound | none - declared not bound (rule 7) |

`HARNESS-PROFILE` is not bound: this repository never runs the shipped harness, so it has no
`.sza-profile.json` for that reason, which rule 7 of the contract reads as a different fact from "the
defaults apply". The contracts declared not applicable are listed in
[SPECIFICATION_CONTRACTS_SYNC.md](../specifications/SPECIFICATION_CONTRACTS_SYNC.md).
