# `PAGE-STYLE` pointer

- Version: 3.4, read in full on 2026-10-21 (the controls, the kit bytes, and the rest of the document; 3.4 adds the
  exchange-server mark, which no page here carries, and changes no kit byte); the adoption row is `partial 3.4`
  for the reasons the `BUTTONS`, `UI-SIZING` and `COLLAPSIBLE-GROUP` pointers give
- Role: consumer, page type Informational / Docs
- Home: `product-web-pages/PAGE-STYLE.md` in the shared contracts catalog; its conformance artifact is
  `product-web-pages/reference/sza-kit.css`

`assets/sza-kit.css` is a byte-identical copy of that reference stylesheet (the revision of 2026-10-21, SHA-256
`4aba1dee10cb902ee21ca4d86e4fbeed3bf7931c64b69fe15619727fd038c141`, which implements BUTTONS, UI-SIZING and
COLLAPSIBLE-GROUP itself, so no button or group adapter is kept) - compare the SHA-256 of the two
files, never edit this one; `.gitattributes` keeps its line endings untouched. The controls and the groups are
recorded in the `BUTTONS`, `UI-SIZING` and `COLLAPSIBLE-GROUP` pointers. `index.html` loads, in
order: the pre-paint resolver on the shared `sza-lang` / `sza-theme` keys, the kit fonts, the kit
stylesheet, then a page layer that uses only kit tokens (section 5 "Extending the kit"). The page fills the
viewport less the kit's `--gutter`; the page layer sets no width cap (1.3). The copy button's done state is
the localized word for "Copied" beside the `action.copy` glyph (1.4). The Ukrainian switch keys `ua`;
`lang`, `hreflang`, section ids and the sitemap keep ISO `uk`.

The locale query is `?lang=<ISO code>`, and the legacy `?l=` is read when no valid `lang` is present (amendment
of 2026-10-17 item 1); a query selects only a locale the page ships (`ru`, `en`, `uk`) and anything else falls
through to the stored choice and the browser. Switching the language writes `?lang=` and drops a stale `?l=`. The
resolver writes `sza-lang` and `sza-theme` only with their allowed values (section 7), so a stray value of the
older `uak-*` keys is not copied across.
The same resolver text is copied by the generator into every portal page. Footer scope (item 2): every page
keeps the contact line, the hub link and the sibling grid; the grid is optional on a child page and is kept
here on purpose, so a visitor on a function page can leave for a sibling. The role *In-app help page* (3.2)
has no page here. The earlier registry exceptions for this document are closed: the light-theme contrast
override went when the revised kit was vendored, and the language parameter's name is settled by the amendment.
