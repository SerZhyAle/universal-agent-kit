# `ICON-RENDER` pointer

- Version: 0.24 (draft); read on 2026-10-21 from 0.18 through the amendments to 0.24; the adoption row is
  `partial 0.24`
- Role: consumer, opted in
- Home: `iconography/README.md` in the shared contracts catalog

The site draws single-colour vector glyphs on the 24-unit grid - inline SVG for the sprite, CSS masks from the
kit for the rest - at the glyph size of the active input profile (16 px with a pointer, 20 px with touch, scaled
with the interface size), in the theme's content or state role, never enlarged from a bitmap (rule 5). Button
surfaces follow `BUTTONS` since 0.20 (its section 14 is a pointer now), so the glyph placement, palette and
content-fit rules of the command buttons are recorded in the `BUTTONS` pointer; the disclosure triangle of a
group header is the control's own state indicator and not a redraw of `nav.expand` (0.21, section 20); and the
touch-target floors of section 3 rule 5 yield to `UI-SIZING` for the covered controls (0.24). The site shows no
`state.warning` tone and its buttons' labels provide the accessible names. The row stays partial because rule 5
depends on `UI-SIZING`, whose own row is partial (a physical device and a screen reader are not measured).
