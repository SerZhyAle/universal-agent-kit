**Status:** Draft

# SPECIFICATION - The landing's experience gaps and the browser half

Parent: [SPECIFICATION_CONTRACT_PRODUCT_SITE.md](SPECIFICATION_CONTRACT_PRODUCT_SITE.md). Opened 2026-10-09
by its P6; the registry exception that carries this gap runs until 2026-12-31.

## Why

Three source-level findings from the 2026-10-09 measurement, and the browser boxes that were not run:

- `SITE-EXPERIENCE` rule 15: no skip link leads past the chrome to the main content.
- `SITE-EXPERIENCE` rule 16: no `nav` landmark - the header controls and the footer link set are not marked
  as navigations (one `main` and one `h1` exist; the `lang` attribute follows the switch, UA writing ISO
  `uk`).
- `SITE-EXPERIENCE` rule 4: one static `style` attribute with layout and colour on the `noscript` fallback
  paragraph (`index.html:237`); layout belongs in the stylesheet.
- Not run in any browser on 2026-10-09: focus order and the visible focus ring, contrast in both themes,
  reduced motion, the network panel. The measurement recorded them as not run; this ticket runs them.

## What to do

1. Fix the three findings in one edit: a skip link as the first focusable element, the header and footer
   link sets as labelled `nav` elements, the `noscript` paragraph moved to a page-layer class - the copy of
   the fallback stays as it is in all three locales, and the release surfaces are rebuilt with
   `pwsh -NoProfile -File tools/build-kit.ps1`, never by hand.
2. Run `SITE-CHECKLIST` sections I0 and I in a browser: Tab through the page, measure the chrome, a callout
   and a link in both themes (4.5:1 text, 3:1 components and glyphs, 44 px targets), set reduced motion and
   reload, and load the page with the network panel open to confirm the two declared origins and nothing
   else.
3. Record the verdicts in the adoption row and close the exception; anything the browser run finds becomes
   its own ticket, not an inline fix.
4. **Gate candidate** (`SITE-EXPERIENCE` rule 20, handed over by the product-site ticket's P7): a small
   stylesheet parser that refuses a `max-width`, a `min(NNNpx, NNvw)` or a centred `margin: 0 auto` on a
   page wrapper of the page layer - decidable offline in an arbitrary tree; adopt it only if it runs clean
   with zero false positives here.

## Acceptance

The three findings are gone from the source, the browser boxes are ticked in the adoption row with the date
and the commit they were read from, and the gate exits 0.
