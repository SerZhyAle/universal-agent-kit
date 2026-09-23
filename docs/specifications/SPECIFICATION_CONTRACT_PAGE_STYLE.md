**Status:** Draft

# SPECIFICATION - Conform the site to PAGE-STYLE 1.0

Parent: [SPECIFICATION_CONTRACTS_SYNC.md](SPECIFICATION_CONTRACTS_SYNC.md). Audit date 2026-09-23.

## Contract

- **Id / version:** `PAGE-STYLE` 1.0, active. Owner: the portfolio hub. Conformance artifacts: the
  reference stylesheet `sza-kit.css` and the contract's section 11 checklist.
- **Role here:** consumer. The contract assigns this product the **Informational / Docs** page type:
  header, hero, numbered disclosure table of contents, copy boxes, callouts, footer, back-to-top.
- **Not applicable to this page type:** the distribution block, the dynamic release link (there are no
  releases; the zip is tracked in the repository), the demo strip.

## Where the page stands

The page was built before the contract and never moved onto the shared kit. Structure mostly conforms;
the visual system does not.

| Rule | Verdict | Evidence |
| --- | --- | --- |
| Shared stylesheet and tokens (sections 0, 11) | **deviates** | an own inline stylesheet; the shared kit is not referenced |
| No indigo, violet or cyan (section 11) | **deviates** | accent tokens `#7aa2ff` / `#9d7bff`, a gradient primary button, a gradient favicon, a violet callout border, a lavender code colour |
| Fonts Outfit + Plus Jakarta Sans (sections 5, 11) | **deviates** | a system stack naming Inter; no web fonts |
| Sticky header, brand in header, hero without it | holds | |
| Language switch RU EN UA, no flags (sections 4.2, 6) | **deviates** | Ukrainian is labelled **UK** and keyed `uk`; order RU, EN is right |
| Metadata follows the language (section 6) | holds, partly | title, description and Open Graph switch; Twitter card tags do not |
| Pre-paint script before CSS (section 7) | holds in substance | storage keys are `uak-lang` / `uak-theme` rather than the shared `sza-*` keys; an extra `?lang=` parameter |
| Theme toggle, dark default, `theme-color`, labelled (section 4.3) | holds | `theme-color` values are the page's own, not the kit's |
| Numbered sections with expand / collapse all (section 4.6) | holds | |
| Open the section named by the hash, on load and on change (section 7) | holds | |
| Copy box (section 4.7) | **deviates in form** | an inline `onclick` handler instead of the declared `data-copy` box; clipboard with fallback and a timed confirmation exist, but the confirmation text is localised rather than the contract's exact text |
| Tagged note with a gold border (section 4.8) | **deviates** | the border uses the violet accent |
| Back-to-top (section 4.12) | **deviates** | absent on a very long page, although the page type requires it |
| Footer tools grid and contact line (section 4.11) | **deviates** | no tools grid; covered by the `SITE-FAMILY-MAP` specification |
| Background blobs (section 5) | **deviates** | absent |
| 44 px targets, visible focus, reduced motion (sections 1, 11) | partly holds | 44 px only under a coarse pointer, 38 px otherwise; focus ring present; no motion to reduce |

## Goals

1. The page is built from the shared kit: its tokens, fonts, components and the section 11 checklist pass
   on the rendered page in both themes.
2. The language switch reads RU EN UA with the shared storage keys, while URLs, `hreflang` and the
   sitemap keep the standard `uk` language code - the mapping is written down, not improvised.
3. The page gains the back-to-top control and the tagged-note style its page type requires.
4. Every structural feature this page has and the contract lacks is offered back as a proposal rather
   than kept as a silent local variant.

## Changes asked of the contract (proposals to the owner)

1. **Width conflict** with `PAGE-CONTENT` (full available width vs a 1100 px container).
2. **`ua` label vs `uk` code:** state the mapping - the switch may read UA, but `lang`, `hreflang` and URL
   parameters use the ISO code `uk`.
3. **Language from the URL:** section 7 does not know a `?lang=` parameter; an explicit-language link
   should win over the stored choice, which is what `hreflang` alternates need.
4. **Copy box for a multi-line prompt:** `data-copy` assumes a one-line command; copying the text of a
   `<pre>` block from the DOM is the sound form for long prompts. Also: how the fixed confirmation text is
   localised on a three-locale page.
5. **No-JavaScript fallback:** which locale shows without script (this page uses a `<noscript>` rule).
6. **Print styles:** expanding every disclosure group and printing in dark ink is useful for any reference
   page; the contract is silent.
7. **Neutral glyphs vs iconography:** section 9 allows the text glyphs `◐ ⤓ → ▸`, which `ICON-SET` rules
   1, 2 and 8 forbid. Owned jointly with the iconography owner; see
   [SPECIFICATION_CONTRACT_ICONOGRAPHY.md](SPECIFICATION_CONTRACT_ICONOGRAPHY.md).

## Constraints

- The published URL, the repository name and the zip's extraction root are frozen anchors; none moves.
- Existing deep links (`#adopt`, `#adopt-en`, `#sec-..`) keep resolving; changing ids needs redirects in the
  hash handler.
- All three locales and both themes change in one edit.
- The page date is stamped by the build script only.

## Done criteria

- Section 11 checklist walked on the rendered page in both themes and three locales, each item cited.
- The shared stylesheet is used byte-identically, or the registry carries a dated exception naming what
  differs and why.
- Back-to-top present; all interactive targets at least 44 px, or an exception.
- The seven proposals exist in the catalog or have been answered.
- Registry row for `PAGE-STYLE` written with the date of that walk.

## Open questions

1. **Adopt the shared visual identity, or keep the page's own?** Full conformance replaces the
   indigo-violet palette, the gradient favicon and the fonts. The alternative is a dated exception, which
   the contract permits only with an `until` date. (Recommended: adopt - the page is one of the family's
   eight, and the exception would have no natural end date.)
2. Inline the shared stylesheet or reference it as a separate file? (Recommended: a separate tracked file,
   so byte-identity with the reference can be checked by hash.)
