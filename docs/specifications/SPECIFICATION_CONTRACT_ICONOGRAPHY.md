**Status:** Verified

# SPECIFICATION - Opt in to the iconography contracts

Parent: [SPECIFICATION_CONTRACTS_SYNC.md](SPECIFICATION_CONTRACTS_SYNC.md). Audit date 2026-09-23.

## Contracts

- **`ICON-SET` 0.10** - one glyph and one name per meaning; the vocabulary with its glyph files.
- **`ICON-RENDER` 0.10** - colour on light, dark and product themes; sizes from a button to a tile.
- **`ICON-EXTERNAL` 0.9** - third-party marks and downloaded pictures.
- All three are **drafts**, owned by FastMediaSorter Android. A draft binds only the products that opt in,
  and any product may supplement it by proposal. Scope: "every product with a user interface" - the site
  qualifies.
- **Role here:** consumer, once opted in.

## What applies to a single static page

Applies: `ICON-SET` rules 1, 2, 3, 5, 7, 8; `ICON-RENDER` rules 1-5 and 8 for the glyphs the page ships and
its two themes; `ICON-EXTERNAL` rules 1 and 5. Does not apply: launcher tiles and widgets, right-to-left
(all locales are LTR), adaptive / monochrome / notification icons, installed-app icons, downloaded
pictures, the owner's exporter.

## Inventory and verdicts

| Glyph on the site | Meaning | Vocabulary id | Verdict |
| --- | --- | --- | --- |
| `▸` / `▾` on disclosure headers, 11 px, violet | expand / collapse a section | `nav.expand` / `nav.collapse` | deviates: shows state instead of action; `▾` has the shape of `nav.dropdown`; below the 16 px minimum |
| `◐` theme button, 38 px target | switch light / dark theme | **no id** (`app.night-mode` means a reader's dark mode and has no states) | deviates: no canonical meaning; state not shown by the glyph; target below 44 px |
| `⤓` on the download buttons (and in `README.md`) | download the zip | `action.download` | deviates: `⤓` has the shape of `nav.scroll-bottom`; the header download button shows no glyph, so one meaning has two looks |
| `⧉` on the copy buttons | copy the prompt | `action.copy` | deviates: a font glyph, not the vocabulary's drawing; Russian label "Скопировать" vs the vocabulary's "Копировать" is borderline |
| `✓` in the copy confirmation | copy succeeded | `status.ok` | deviates: a bare check is `action.confirm`; not coloured as the ok state |
| `⚠` in the copy failure | copy failed | `status.error` | deviates: a triangle is `status.warning`; U+26A0 may render as a colour emoji |
| Favicon: gradient tile with three lines | the product's mark | none (own identity) | out of scope for the vocabulary; no PNG / apple-touch icon, so some systems show no mark |
| Language switch, expand-all, external links, "GitHub", agent names | - | - | text only, holds; no third-party marks are drawn (`ICON-EXTERNAL` rule 1 holds) |
| `→` in `README.md` "Read the article" | leave for the site | `nav.open-external` | deviates: a right arrow is `nav.forward`; but see proposal 5 |

Box-drawing characters, arrows inside prose and diagrams, quotes and separators are typography, not
icons, and stay.

## Goals

1. Every icon the site shows carries one vocabulary meaning and that meaning's drawing, taken from the
   vocabulary's glyph files, inlined once and coloured from the page's theme tokens.
2. Success and failure feedback uses the state colours from the shared palette.
3. Every icon-only control has a 44 px target and a label equal to the vocabulary's localised name.
4. Meanings the site needs that the vocabulary lacks go back to the owner as proposals before the site
   draws its own.
5. Third-party glyph licences (the vocabulary's Material-derived drawings are Apache-2.0) are credited in
   the repository.
6. `kit/` is not touched: it shows no icons, and it never names the catalog.

## Resolution

Completed 2026-09-23. The theme switch is now a localized text control, and disclosure headers use no
custom marker; neither requires a new vocabulary meaning. The site replaces its download, copy, success,
and failure symbols with the shared `action.download`, `action.copy`, `status.ok`, and `status.error` SVGs.
They are 16 px, inherit the correct content or state role, and appear beside the vocabulary name in all
three locales. README links are text-only because GitHub-flavoured Markdown cannot safely inherit the page
theme or inline the shared SVG. The catalog adoption proposal asks the owner to add this consumer to the
three header blocks; no vocabulary or rule proposal is needed because this consumer needed no meaning or
rule absent from the current drafts.

Measured against the actual page surfaces: `state.ok` is 8.72:1 in dark and 5.13:1 in light; `state.error`
is 5.04:1 in dark and 4.98:1 in light. All exceed the 3:1 non-text contrast floor. The success and error
feedback now display both the state glyph and its localized vocabulary name (for example, `OK: Copied`).

## Constraints

- The draft may change shape; this page follows the vocabulary by id, so a redraw upstream is a re-copy,
  not a redesign.
- A glyph the vocabulary marks as a stand-in for a third-party mark is not copied.
- All three locales and both themes change in one edit.

## Done criteria

- No glyph on the page outside the inventory's "text / typography" rows lacks a vocabulary id, except where
  an open proposal names it.
- Contrast of every icon against its background at least 3:1 in both themes, measured and cited.
- The licence notice for the copied drawings is in the repository.
- No custom glyph or unrecorded contract deviation remains.
- Registry rows for the three icon contracts written, with dated exceptions for anything waiting on a
  proposal.

## Decisions

1. Opted in on 2026-09-23 at `ICON-SET` / `ICON-RENDER` 0.10 and `ICON-EXTERNAL` 0.9.
2. The gradient favicon remains product identity artwork, outside the vocabulary.
