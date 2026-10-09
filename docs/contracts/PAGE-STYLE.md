# `PAGE-STYLE` pointer

- Version: 1.6 (active)
- Role: consumer, page type Informational / Docs
- Home: `product-web-pages/PAGE-STYLE.md` in the shared contracts catalog; its conformance artifact is
  `product-web-pages/reference/sza-kit.css`

`assets/sza-kit.css` is a byte-identical copy of that reference stylesheet - compare the SHA-256 of the two
files, never edit this one; `.gitattributes` keeps its line endings untouched. `index.html` loads, in
order: the pre-paint resolver on the shared `sza-lang` / `sza-theme` keys, the kit fonts, the kit
stylesheet, then a page layer that uses only kit tokens (section 5 "Extending the kit"). The page fills the
viewport less the kit's `--gutter`; the page layer sets no width cap (1.3). The copy button's done state is
the localized word for "Copied" beside the `action.copy` glyph (1.4). The Ukrainian switch keys `ua`;
`lang`, `hreflang`, `?lang=`, section ids and the sitemap keep ISO `uk`. What the page layer does beyond
the kit is a dated registry exception, and the one question still open with the owner is the name of the
language URL parameter, `?lang=` against `?l=`.
