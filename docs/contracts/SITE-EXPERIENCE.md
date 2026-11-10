# `SITE-EXPERIENCE` pointer

- Version: 0.5 (draft; opted in 2026-10-09); 0.4 read in full on 2026-10-21, the 0.5 amendment read on 2026-11-10
- Role: consumer; every rule binds at the declared portal tier
- Home: `product-site/SITE-EXPERIENCE.md` in the shared contracts catalog; its conformance artifact is the
  run-list `SITE-CHECKLIST.md`, read off the rendered site

Every page is built on the kit served byte-identical (rule 1; compare SHA-256 with the catalog copy, never
edit the vendored file), then the product layer `assets/site.css`, then the portal layer `assets/portal.css`
(rule 2: the layer's own tokens are `--prose-w` and `--panel-gap`, everything else is a kit token). Every page
carries the pre-paint resolver (the landing's text, copied by the generator) and the shared `sza-lang` /
`sza-theme` state of `PAGE-STYLE` section 7 (rules 7, 10; the language control is the segmented control), fills
the viewport less the kit gutter with no width cap (rule 20; held by `tools/check-site.ps1 -Dimension
page-width`, which also refuses a `style` attribute, rule 4), has the skip link first, one `main`, labelled
`nav` landmarks and ordered headings (rules 15, 16; `page-set`). Search is local: one index file, loaded once on
first open, no request per keystroke, a native modal dialog, Escape and focus return, polite result
announcements (rules 11, 12). The declared third-party origins are `fonts.googleapis.com` (the fonts stylesheet)
and `fonts.gstatic.com` (the font files) - nothing else is contacted at load, no analytics, no advertising -
named on `privacy.html` with purpose and what each receives, and compared both ways with what the pages load
(rule 14; `origins`). Contrast, focus order, reduced motion and the network panel are read in a browser, not
from the source, and recorded per run in the adoption row.

Rule 17 was answered by the owner's amendment of 2026-10-29 (0.5, item A): a button and every component
`UI-SIZING` covers follows `BUTTONS` and `UI-SIZING` (this site serves the kit byte-identical at the 3.6
revision of 2026-11-10, so its buttons draw 32 px with a pointer, 48 px with touch, and the declared compact
24 and 36), and a text link or any uncovered control holds the `ICON-RENDER` web floor - which this site's
uncovered controls exceed by keeping 44 px under every pointer. The former rule-17 exception closed on
2026-11-10 with the owner's acceptance; the profile targets are measured per profile and size by
`tools/ui-check/run.py` (16353 checks, 0 failed, on the working tree of 2026-11-10). The 0.4 additions (the
Support page and a static release-history page) are conditional and owed nothing here, for the reasons the
`SITE-STRUCTURE` pointer gives.
Staying conformant: keep the resolver text the kit's, keep layout in the stylesheets, declare every origin in
`tools/portal/privacy.json` and re-run the browser half of the run-list when the page set or a layer changes.
