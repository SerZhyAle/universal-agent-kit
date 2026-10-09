**Status:** Draft

# SPECIFICATION - Publish the privacy page

Parent: [SPECIFICATION_CONTRACT_PRODUCT_SITE.md](SPECIFICATION_CONTRACT_PRODUCT_SITE.md). Opened 2026-10-09
by its P6; the registry exception that carries this gap runs until 2026-12-31.

## Why

The site contacts two third-party origins at load - `fonts.googleapis.com` (the fonts stylesheet) and
`fonts.gstatic.com` (the font files) - so the privacy page's condition in `SITE-STRUCTURE` section 2 holds.
`SITE-EXPERIENCE` rule 14 requires each declared origin to be named on the privacy page, with its purpose and
what it receives, in every language the page publishes; `SITE-REPRESENTATION` rule 12 requires its claims to
agree with every other trust surface. The page does not exist; the zero-data carve-out in
`.sza-canon.json` describes the product's own handling, not the fonts the page loads.

## What to do

1. Publish `privacy.html` at the root, in the core three (RU, EN, UA), linked from the footer of the landing.
2. Name the two origins with their purpose and what they receive (the visitor's IP address to the font
   servers; nothing else is contacted, no analytics, no advertising). State what the product itself collects:
   nothing beyond the two `localStorage` keys of the language and theme state (`sza-lang`, `sza-theme`),
   which never leave the browser.
3. Keep the page free of advertising origins whatever its role (`SITE-EXPERIENCE` rule 14), and keep every
   data claim on the landing agreeing with it (`SITE-REPRESENTATION` rule 12).
4. Add the page to the sitemap and the address scheme; update the adoption row and close the exception.

## Acceptance

`SITE-CHECKLIST` section F runs clean on the rendered page; the origins named there equal the declaration in
the adoption row, both ways.
