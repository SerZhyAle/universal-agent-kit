# `PAGE-STYLE` pointer

- Version: 3.4, read in full on 2026-10-21 (the controls, the kit bytes, and the rest of the document; 3.4 adds the
  exchange-server mark, which no page here carries, and changes no kit byte); the adoption row is `partial 3.4`
  for the reasons the `BUTTONS`, `UI-SIZING` and `COLLAPSIBLE-GROUP` pointers give. The kit bytes alone follow the
  revision 3.8 of 2026-11-10 (the 3.6 header-edge and 3.8 pill-contrast amendments were read in full; 3.7 is the
  hub's per-locale option and owes nothing here); the rest of 3.5 and 3.6 is not audited here and stays with the
  contract-synchronization ticket, so the row is not advanced
- Role: consumer, page type Informational / Docs
- Home: `product-web-pages/PAGE-STYLE.md` in the shared contracts catalog; its conformance artifact is
  `product-web-pages/reference/sza-kit.css`

`assets/sza-kit.css` is a byte-identical copy of that reference stylesheet (the revision of 2026-11-10, PAGE-STYLE
3.8, 30698 bytes, SHA-256 `d490abf3bf55455f2cffb92b9ba6305f58c2f1160f3f1ddf70c2d125dd22fa5d`, vendored 2026-11-11;
before it 3.6, `425dacf803b8e3035f3a66a3b6fa72698efa6bd477ecf088ac39aa30e1c322a0`, and
`4aba1dee10cb902ee21ca4d86e4fbeed3bf7931c64b69fe15619727fd038c141` of 2026-10-21; the 3.8 correction draws `.pill`
text in `--acc-strong` for 4.5:1 body-text contrast, and the site draws pills on every page; it implements BUTTONS, UI-SIZING and
COLLAPSIBLE-GROUP itself, so no button or group adapter is kept) - compare the SHA-256 of the two
files, never edit this one; `.gitattributes` keeps its line endings untouched. The 3.6 correction (the brand text
starts on the content edge, with logical start and end spacing) is measured by `tools/ui-check/run.py`: header
brand, heading and footer content share one inline-start edge on every page kind at 360 to 2560 px and at every
interface size, and the mirror under `dir=rtl` holds as an emulation, because no right-to-left locale ships. The controls and the groups are
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
