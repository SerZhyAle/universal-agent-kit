# `ICON-SET` pointer

- Version: 0.29 (draft)
- Role: consumer, opted in
- Home: `iconography/README.md` in the shared contracts catalog

The site maps each interface glyph to a vocabulary id and displays the corresponding shared SVG beside its
localized name. The copied state of a copy button is the localized word "Copied" beside the same
`action.copy` glyph - never a status glyph, never a check (the 0.15 note on `action.copy`). Conformance
evidence is the inline icon inventory in `index.html`, the attribution in `NOTICE.md`, and the registry row.

The inline sprite draws `action.download`, `action.copy`, `nav.scroll-top` and `status.error`. The shared
stylesheet also draws the disclosure actions `nav.expand` / `nav.collapse` as a CSS mask (section 2 rules 1
and 8); the theme and language controls are text-only. Compare each inline SVG's path and transforms with
the current catalog glyph, and the stylesheet byte for byte with the PAGE-STYLE reference. No catalog
conformance vectors exist yet (ICON-RENDER section 3 rule 1); the exported glyphs are the comparison artifacts.
