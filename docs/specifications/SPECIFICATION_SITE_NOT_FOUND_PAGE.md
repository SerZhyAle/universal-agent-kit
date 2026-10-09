**Status:** Draft

# SPECIFICATION - Publish the not-found page

Parent: [SPECIFICATION_CONTRACT_PRODUCT_SITE.md](SPECIFICATION_CONTRACT_PRODUCT_SITE.md). Opened 2026-10-09
by its P6; the registry exception that carries this gap runs until 2026-12-31.

## Why

`SITE-STRUCTURE` rule 15 with the section 2 table: the not-found page is required at every tier where the
host allows a custom one, and GitHub Pages serves a root `404.html` for this repository (verified
2026-10-09: an unknown address returns the host's default page, not this product's chrome).

## What to do

1. Publish `404.html` at the repo root, in the product's chrome (the shared kit stylesheet, the same
   header), saying in the visitor's language - the static host cannot tell it, so the page offers the
   language control or states the fallback plainly - that the address does not exist, and linking what
   exists today: the landing and the download. When the portal lands, extend it with the portal home and the
   search, as rule 15 asks.
2. Mark it `noindex`; do not add it to the sitemap (it is not a page the corpus owes).
3. Land the copy in all three locales in one edit; rebuild the release surfaces with
   `pwsh -NoProfile -File tools/build-kit.ps1` only if `index.html` changed too.

## Acceptance

`SITE-CHECKLIST` section H: requesting an address that does not exist returns a page in the product's
chrome offering the landing; the registry exception closes.
