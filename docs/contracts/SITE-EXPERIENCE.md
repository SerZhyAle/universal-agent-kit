# `SITE-EXPERIENCE` pointer

- Version: 0.3 (draft; opted in 2026-10-09; the spec that opened this work read 0.1 - rules 20 and the picker
  form of rule 10 arrived as 0.2 and 0.3 before this row was written)
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
from the source, and recorded per run in the adoption row: the accent-filled controls of the kit itself
(`.btn-primary`, the active `.seg` button) measure 4.11:1 in the light theme and are the kit's to fix. Staying
conformant: keep the resolver text the kit's, keep layout in the stylesheets, declare every origin in
`tools/portal/privacy.json` and re-run the browser half of the run-list when the page set or a layer changes.
