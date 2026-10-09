**Status:** Draft

# SPECIFICATION - The held-address list

Parent: [SPECIFICATION_CONTRACT_PRODUCT_SITE.md](SPECIFICATION_CONTRACT_PRODUCT_SITE.md). Opened 2026-10-09
by its P6; the registry exception that carries this gap runs until 2026-12-31.

## Why

`SITE-STRUCTURE` rule 8: the product keeps the list of addresses held outside the site - the in-app help
links, store listings, READMEs, the sibling sites of `SITE-FAMILY-MAP` - in a form a program can read, and a
gate resolves every entry against the page set. This repository has one address
(`https://serzhyale.github.io/universal-agent-kit/`) and no list file: the holders are the sibling pages of
the `SITE-FAMILY-MAP` section 2 map, the hub page, `README.md` and the repository's GitHub surfaces.

## What to do

1. Create `docs/site-held-addresses.jsonl`: one record per held address - the address, the holder (sibling
   site, hub, README, repository surface), and the anchor it targets where it has one (the landing's section
   anchors are part of the promise: an anchor an outside surface links is never renamed).
2. Add a gate that resolves every entry against the page set and refuses an entry that is itself a forwarder
   or answers nothing. The rule is decidable offline against a static tree with a near-zero false-positive
   rate, so this is the one new gate this round proposes; wire it beside the build check, not into the
   published page.
3. When a page moves or retires, the same change updates the list and leaves the forwarder
   (`SITE-STRUCTURE` rules 8, 13).

## Acceptance

The gate runs on every held address and exits 0; the registry exception closes.
