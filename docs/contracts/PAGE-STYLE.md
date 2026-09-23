# `PAGE-STYLE` pointer

- Version: 1.0 (active)
- Role: consumer, page type Informational / Docs
- Home: `product-web-pages/PAGE-STYLE.md` in the shared contracts catalog; its conformance artifact is
  `product-web-pages/reference/sza-kit.css`

`assets/sza-kit.css` is a byte-identical copy of that reference stylesheet - compare the SHA-256 of the two
files, never edit this one; `.gitattributes` keeps its line endings untouched. `index.html` loads, in
order: the pre-paint resolver on the shared `sza-lang` / `sza-theme` keys, the kit fonts, the kit
stylesheet, then a page layer that uses only kit tokens. The Ukrainian switch keys `ua`; `lang`, `hreflang`,
`?lang=`, section ids and the sitemap keep ISO `uk`. What the page layer does beyond the kit is a dated
registry exception, and the questions behind it are a filed proposal to the owner.
