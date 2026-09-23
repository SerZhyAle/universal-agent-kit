**Status:** Verified

# SPECIFICATION - Conform the site to SITE-FAMILY-MAP 1.1

Parent: [SPECIFICATION_CONTRACTS_SYNC.md](SPECIFICATION_CONTRACTS_SYNC.md). Audit date 2026-09-23.

## Contract

- **Id / version:** `SITE-FAMILY-MAP` 1.1, active. Owner: the portfolio hub. Conformance: the URL check in
  the contract's section 5.
- **Role here:** consumer. This product is itself one entry of the map ("Universal Agent Kit - AI-dev
  methodology", `https://serzhyale.github.io/universal-agent-kit/`), which is a frozen anchor.

## Where the page stands

| Rule | Verdict | Evidence |
| --- | --- | --- |
| 1 - the footer lists every sibling tool | holds | the shared `.tools-grid` lists the seven exact sibling names and URLs from section 2, plus the hub; Universal Agent Kit is omitted as the current product |
| 2 - hub exception | not applicable | not the hub |
| 3 - one contact identity | holds | the page and `README.md` state `sza@ukr.net` and the SerZhyAle GitHub profile |
| 4 - in-text cross-links go to the sibling's page | holds | the FastMediaSorter provenance link in all three locales points to the Android product page |
| Section 5 - every URL answers | holds | `curl.exe -s -o NUL -w "%{http_code} <url>\n" -L <url>` returned `200` for all nine section 2 URLs on 2026-09-23 |

The seven missing siblings: FastMediaSorter (Android), Fast Media Sorter for Windows, CyrFlip,
doc-html-translate, FileDO, StreamsPlayer, OneClickRunner - with the exact URLs the contract's section 2
lists.

## Goals

1. The footer carries the family grid in the shared kit's form, in all three locales, with every sibling
   the map lists and no product it does not.
2. The provenance mention of FastMediaSorter links to that product's page.
3. `README.md` states the same contact identity as the page, so the section 5 check has something to read.
4. When the map changes, this page follows: the grid is taken from the contract's list, not maintained
   from memory.

## Changes asked of the contract (proposals to the owner)

1. **The registry note** on this product's `INSTALL-TRUST` row says the repository holds "no contract of
   any kind", which contradicts this contract's consumer list. This product corrects its own row; nothing
   is asked of the owner beyond noting it when the "eight product pages" placeholder is expanded.
2. None on the map itself: the list and the rules fit a docs page as written.

## Constraints

- Link text is the product's name as the map spells it; no descriptions invented beyond the map's.
- Localised grid heading only; product names are not translated.
- Grid markup and styling come from `PAGE-STYLE` section 4.11, so this lands with or after the
  `PAGE-STYLE` work - or alone, in the page's current style, with the `PAGE-STYLE` exception covering the
  styling.

## Done criteria

- The rendered footer, in each locale, lists exactly the seven siblings plus the hub, each URL answering
  200 on the day of the check (command and output cited).
- The provenance link resolves to the FastMediaSorter page.
- `README.md` carries the contact line.
- Registry row for `SITE-FAMILY-MAP` written with that date.

## Open questions

None. This is the one violation of an active contract found in the audit, and it needs no owner decision.
(Recommended: ship it first, independently of the `PAGE-STYLE` restyle.)
