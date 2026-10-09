**Status:** BlockNeedUserTest - reduced motion could not be set in the browser tool of the session (SITE-CHECKLIST I); everything else is verified

# SPECIFICATION - The landing's experience gaps and the browser half

Parent: [SPECIFICATION_CONTRACT_PRODUCT_SITE.md](DONE/SPECIFICATION_CONTRACT_PRODUCT_SITE.md). Opened 2026-10-09
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

## Verification - 2026-10-09

- **The three findings are gone from the source.** A skip link (`.skip-link`, target `#main`) is the first focusable element of the landing and of every portal page; the header link set (the Documentation link) and the footer link sets (the tools grid, the author links) are labelled `nav` landmarks whose labels follow the language; the `noscript` paragraph is the `.noscript-note` class, with the copy unchanged in all three locales. `check-site.ps1 -Dimension page-set` and `-Dimension page-width` hold these (skip link first, one `main`, labelled navs, ordered headings, no `style` attribute or element on any published page). The page layer left the inline `<style>` for `assets/site.css`; the release surfaces were rebuilt with `tools/build-kit.ps1`.
- **Browser run, Chrome, working tree served locally, 2026-10-09.**
  - Full width (I0): at 1920 and 2560 px, on the landing, portal home, a function page, the glossary, the privacy page and the not-found page, `main` spans the viewport less the scrollbar and the header, `h1` and footer share one x position (40 px). No horizontal scroll at 360 px on 30 pages of every kind.
  - Keyboard (I): no positive `tabindex` anywhere; the tab order read from the DOM is reading order (skip link, brand, portal links, search, language, theme, download, content, pager, footer); a real Tab key press reached the skip link first and showed its focus ring; nothing in either layer removes the ring (`:focus-visible` is the kit's).
  - Contrast: a script measured text, tags, links, pills, buttons and code over 13 page kinds in both themes. The kit's own accent-filled controls measured 4.11:1 in the light theme (white on `--acc`); the product layer draws them on the kit's `--acc-strong` (about 5.4:1) and the registry records the override as a dated exception. After it, no measured pair is under 4.5:1.
  - Network: a function page loaded the site's own files plus exactly `fonts.googleapis.com` and `fonts.gstatic.com`; the search index is fetched once, on first open, and not per keystroke.
- **Gate candidate (`SITE-EXPERIENCE` rule 20): adopted.** `check-site.ps1 -Dimension page-width` parses the product and portal layers and refuses a `max-width`, a `min(NNNpx, NNvw)`, a pixel `width` or a centred `auto` margin on a page wrapper, while a card, callout, table, dialog or code block may be narrower. Zero findings on this tree; negative test with `main{max-width:1200px; margin:0 auto}` and `.hero{width:900px}` gave three findings, and `.panel p{max-width:60ch}` was correctly not flagged.
- **Registry.** The exception row for rules 15, 16 and 4 is removed; the adoption row of `SITE-EXPERIENCE` records the verdicts and the box not run.

Gates run 2026-10-09 on the working tree after the last change: `build-portal.ps1 -Validate` VALID (41 capabilities, 41 function pages, 6 guides, 45 terms), `build-portal.ps1 -Check` PASS (0 drifted, 0 orphans), `check-site.ps1` PASS (dimensions held-addresses, page-width, page-set, positioning, origins, portal-fresh), `build-kit.ps1` PASS (55 entries, 0 mismatches), `check-compliance.ps1` 0 error(s), 0 warning(s), exit 0.

## Manual checks

- [ ] Reduced motion (`SITE-CHECKLIST` I; `SITE-EXPERIENCE` rules 8 and 19): set the operating-system or browser preference, reload the landing and one portal page, and confirm that transitions and the hover lift stop and the page scrolls without smooth scrolling. Not run: the browser tool of the session cannot set the preference. Source evidence only: the kit's `*, *::before, *::after` rule is in the served file and neither layer defines a transition or an animation.
