# Shared-contract pointers

This directory identifies the shared contracts this repository touches, without copying their text. Each
file names the contract id, its version, its home in the catalog, this repository's role, and what
conformance requires.

| Pointer | Version | Role | Surface |
| --- | --- | --- | --- |
| [`PAGE-CONTENT.md`](PAGE-CONTENT.md) | 1.1 | consumer | `index.html` |
| [`PAGE-STYLE.md`](PAGE-STYLE.md) | 1.0 | consumer | `index.html`, `assets/sza-kit.css` |
| [`SITE-FAMILY-MAP.md`](SITE-FAMILY-MAP.md) | 1.1 | consumer | `index.html` footer, `README.md` |
| [`ICON-SET.md`](ICON-SET.md) | 0.13 | consumer | `index.html` glyphs |
| [`ICON-RENDER.md`](ICON-RENDER.md) | 0.11 | consumer | `index.html` glyphs |
| [`ICON-EXTERNAL.md`](ICON-EXTERNAL.md) | 0.9 | consumer | `index.html` imagery |
| [`REPO-STAMP.md`](REPO-STAMP.md) | 0.9 | producer | `.sza-canon.json` |
| [`REPO-LAYOUT.md`](REPO-LAYOUT.md) | 0.9 | consumer | root files, `docs/` |
| [`RULE-DELIVERY.md`](RULE-DELIVERY.md) | 0.9 | consumer | the `sza` plugin |

`HARNESS-PROFILE` has no role here: no `.sza-profile.json`, which the contract reads as the defaults, and
the packaged harness is not run. The contracts declared not applicable are listed in
[SPECIFICATION_CONTRACTS_SYNC.md](../specifications/SPECIFICATION_CONTRACTS_SYNC.md).
