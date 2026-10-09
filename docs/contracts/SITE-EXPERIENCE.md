# `SITE-EXPERIENCE` pointer

- Version: 0.3 (draft; opted in 2026-10-09; the spec that opened this work read 0.1 - rules 20 and the picker
  form of rule 10 arrived as 0.2 and 0.3 before this row was written)
- Role: consumer (page-tier subset plus rule 20 bind today; every rule binds once the declared portal pages
  exist)
- Home: `product-site/SITE-EXPERIENCE.md` in the shared contracts catalog; its conformance artifact is the
  run-list `SITE-CHECKLIST.md`, read off the rendered site

The landing is built on the kit served byte-identical (rule 1; compare SHA-256 with the catalog copy, never
edit the vendored file), carries the pre-paint resolver and the shared `sza-lang` / `sza-theme` state of
`PAGE-STYLE` section 7 (rules 7, 10), and fills the viewport less the kit gutter with no width cap (rule 20).
The declared third-party origins are `fonts.googleapis.com` (the fonts stylesheet) and `fonts.gstatic.com` (the
font files) - nothing else is contacted at load, no analytics, no advertising; the privacy page that must name
them is owed (rule 14, ticket `SPECIFICATION_SITE_PRIVACY_PAGE.md`), and any new origin joins the declaration
and the page in the same change. Keyboard, landmarks, contrast, alternative text and reduced motion (rules 15
to 19) are verified in a browser, not from the source; the open source-level findings (no skip link, no `nav`
landmark, one static `style` attribute on the `noscript` fallback) are held by ticket
`SPECIFICATION_SITE_LANDING_EXPERIENCE.md`. Staying conformant: keep the resolver text the kit's, keep layout
in the stylesheet, declare every origin, and re-run the browser half of the run-list when the page set changes.
