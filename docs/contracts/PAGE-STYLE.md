# `PAGE-STYLE` pointer

- Version: 3.13 (active); read in full at 3.4 on 2026-10-21, then the amendments that reach this product: 3.5
  (the locale-query table and the resolver line), the kit re-vendors of 3.6 and 3.8 read on 2026-11-10 and
  2026-11-11, the 3.9 to 3.11 amendments read on 2026-11-16 (S0016), and the 3.12 and 3.13 amendments read on
  2026-11-17 with this re-vendor: 3.9's per-locale option stays an option -
  this landing keeps one DOM, which conforms; 3.10's release facts bind a release flow, and the rolling kit keeps
  the durable download link and shows no version, the shape its item 3 allows; 3.11's no-forward rule names the
  one-DOM pre-paint resolution as not a forward; 3.12's header box moves the brand text off the header's border and
  into the box, and the edges check below reads it the new way; 3.13's Cyrillic font pair is followed into every
  font link the pages load. The adoption row is `partial 3.13` for the reasons the `BUTTONS`,
  `UI-SIZING` and `COLLAPSIBLE-GROUP` pointers give. The kit bytes follow the
  revision 3.13 of 2026-11-17 (read with the 3.12 header-box and 3.13 font-pair amendments; 3.7 is the
  hub's per-locale option and owes nothing here)
- Role: consumer, page type Informational / Docs
- Home: `product-web-pages/PAGE-STYLE.md` in the shared contracts catalog; its conformance artifact is
  `product-web-pages/reference/sza-kit.css`

`assets/sza-kit.css` is a byte-identical copy of that reference stylesheet (the revision of 2026-11-17, PAGE-STYLE
3.13, 31950 bytes, SHA-256 `8d49a8f0a36369da62faf56a4dd9f026097f5aeba43b6d8f4f8c0edc56417e42`, vendored 2026-11-17;
before it 3.8, 30698 bytes, `d490abf3bf55455f2cffb92b9ba6305f58c2f1160f3f1ddf70c2d125dd22fa5d`, vendored 2026-11-11;
the 3.12 amendment keeps the brand text off the header's border by holding the border and padding inside the box,
and 3.13 replaces the latin-only Outfit / Plus Jakarta Sans pair with Manrope / Golos Text, which draw the Cyrillic
of the ru and uk pages; it implements BUTTONS, UI-SIZING and
COLLAPSIBLE-GROUP itself, so no button or group adapter is kept) - compare the SHA-256 of the two
files, never edit this one; `.gitattributes` keeps its line endings untouched. The 3.12 header box is measured by
`tools/ui-check/run.py`: the brand text keeps the header's border and inline-start padding inside the box at every
interface size, and the header brand, the heading and the footer content share one inline-start edge on every page
kind at 360 to 2560 px and at every interface size wherever the box's 4 px viewport floor does not bind; where the
floor binds (the largest UI sizes on a narrow screen) the text may stand a few pixels inside the shared edge, never
past it - and the mirror under `dir=rtl` holds as an emulation, because no right-to-left locale ships. The controls and thegroups are
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
