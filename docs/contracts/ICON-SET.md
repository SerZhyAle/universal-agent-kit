# `ICON-SET` pointer

- Version: 0.37 (draft); read on 2026-10-21 from 0.29 through 0.36, the 0.37 amendment read on 2026-11-10
- Role: consumer, opted in
- Home: `iconography/README.md` in the shared contracts catalog

The site maps each interface glyph to a vocabulary id and displays the corresponding shared SVG beside its
localized name. The copied state of a copy button is the localized word "Copied" beside the same
`action.copy` glyph - never a status glyph, never a check (the 0.15 note on `action.copy`). Conformance
evidence is the inline icon inventory in `index.html`, the attribution in `NOTICE.md`, and the registry row.

The inline sprite draws `action.download`, `action.search`, `nav.expand` and `nav.collapse` on every page and
`status.error` on the landing; the revised shared stylesheet draws the other meanings the controls use
(`action.copy`, `app.theme`, `nav.scroll-top`, `nav.open-external`, `nav.go-to`) as CSS masks from the catalog's
own path data. That stylesheet is the kit's, byte-identical to the PAGE-STYLE reference, so its glyph geometry is
the reference's and not a second copy. The versions after 0.29 add and activate meanings (`app.help`, `app.tour`,
`action.retry`, `action.paste`, the exchange glyphs, and in 0.37 `nav.menu` with the one-tone glyph on
`source.exchange-server`) that no page here draws: no help, tour, paste or menu control exists on the site.
Compare each inline SVG's path and transforms with the current catalog glyph - the comparison
(`tools/ui-check/run.py`, 16353 checks, 0 failed, 2026-11-10) re-verified every inline symbol after the 0.37
bump and the kit re-vendor. No catalog conformance vectors exist yet (ICON-RENDER section 3 rule 1); the
exported glyphs are the comparison artifacts.
