**Status:** Verified

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

Audited 2026-09-23 as built before the contract, with its own inline stylesheet, indigo-violet palette,
system fonts, a `UK` label, `uak-*` storage keys, no back-to-top and no blobs. Moved onto the kit the same
day. The verdicts below are the rendered page after that move, walked in headless Chrome in both themes
and all three locales.

| Rule | Verdict | Evidence |
| --- | --- | --- |
| Shared stylesheet and tokens (sections 0, 11) | holds | `assets/sza-kit.css` and the catalog reference both hash to SHA-256 `72bd903e...332593f`; the page layer after it uses kit tokens only |
| No indigo, violet or cyan (section 11) | holds | `grep` for the old values (`#7aa2ff`, `#9d7bff`, `#3b63d6`, `#cdd6f4`, gradients) finds nothing; favicon and `og-image.png` redrawn in Pine + Gold |
| Fonts Outfit + Plus Jakarta Sans (sections 5, 11) | holds | computed `font-family`: body `"Plus Jakarta Sans"`, `h1` `Outfit` |
| Sticky header, brand in header, hero without it | holds | kit `.site-header`, allowed to wrap at 360 px |
| Language switch RU EN UA, no flags (sections 4.2, 6) | holds | label **UA**, key `ua`; `lang`, `?lang=`, `hreflang`, section ids and sitemap keep `uk`; `setLang('ua')` gave `lang=uk`, `?lang=uk`, `sza-lang=ua` |
| Metadata follows the language (section 6) | holds | title, description, Open Graph and now Twitter card tags switch |
| Pre-paint script before CSS (section 7) | holds | before the font link and the kit; shared `sza-lang` / `sza-theme` keys, legacy `uak-*` read once; `?lang=` kept (exception, proposal 3) |
| Theme toggle, dark default, `theme-color`, labelled (section 4.3) | holds | `theme-color` is the kit `--bg` per theme (`#0a0f0a` / `#eef3ea`); the toggle is a labelled `.theme-btn`, visible at 360 px |
| Numbered sections with expand / collapse all (section 4.6) | holds | |
| Open the section named by the hash, on load and on change (section 7) | holds | `#sec-09-uk` switches to UA and opens section 09; `#adopt-uk`, `#new-uk`, `#old-en` resolve |
| Copy box (section 4.7) | exception | multi-line prompts copy from their `<pre>` with a localised confirmation and the `status.ok` glyph (proposals 4 and 7) |
| Tagged note with a gold border (section 4.8) | holds | kit `.note` |
| Back-to-top (section 4.12) | holds | hidden at the top, shown after 600 px of scroll, 44 x 44, `nav.scroll-top` glyph, localised label |
| Footer tools grid and contact line (section 4.11) | holds | kit `.site-footer` / `.tools-grid` / `.footer-bottom`; grid per `SITE-FAMILY-MAP` |
| Background blobs (section 5) | holds | kit `.bg-blobs`; motion off under `prefers-reduced-motion` by the kit |
| 44 px targets, visible focus, reduced motion (sections 1, 11) | holds | every visible button, `.btn` and tools-grid link measured at 44 px or more; kit focus ring; kit reduced-motion rule |
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

## Open questions - answered 2026-09-23

1. **Adopt the shared visual identity** - adopted, as recommended. No exception covers the palette, the
   fonts or the favicon.
2. **A separate tracked file**, as recommended: `assets/sza-kit.css`, pinned by `.gitattributes` against
   line-ending conversion so its hash stays comparable with the reference.

## Where the seven proposals went

Filed in the catalog as `product-web-pages/PROPOSAL-2026-09-23-universal-agent-kit-page-style.md`, item 1
by reference to the width item already filed in `PROPOSAL-2026-09-23-documentation-method-start-and-actions.md`.
It also reports one defect in the reference: `.to-top` is 42 px and the other targets reach 44 px only under
a coarse pointer, against section 1. The page layer's four local forms (width, `?lang=`, prompt copy,
text-only disclosure and theme control) are one registry exception until 2026-12-31. The registry row for
`PAGE-STYLE` carries this walk's date.