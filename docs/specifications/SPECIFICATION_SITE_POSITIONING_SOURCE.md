**Status:** Draft

# SPECIFICATION - The positioning source

Parent: [SPECIFICATION_CONTRACT_PRODUCT_SITE.md](SPECIFICATION_CONTRACT_PRODUCT_SITE.md). Opened 2026-10-09
by its P6; the registry exception that carries this gap runs until 2026-12-31.

## Why

`SITE-REPRESENTATION` rules 1 and 2: one document every external surface is written from - the landing, the
README, any future portal page and store surface - holding an ordered list of what the product is for, the
pillars, in the order every surface repeats. No such document exists; the closest text is the opening of
`README.md` and the description and Open Graph tags of `index.html`, written together but not held as a
source.

## What to do

1. Write one positioning source (a document a program can point at; the natural home is beside the README
   copy it governs) with the ordered pillars: what the kit is, who it is for, what it promises, in the order
   the surfaces list them.
2. Rewrite the landing's hero and description copy, the README opening and the Open Graph description from
   it - the pillar order repeated, not retyped - in one change, all three locales of the landing together.
3. From then on, no surface is written from another surface: where two disagree, the source decides which
   is wrong (`SITE-REPRESENTATION` rule 1). A store-policy exception, where a listing must name one
   function first, is declared in the adoption row if one ever arises.
4. Update the adoption row to name the source and close the registry exception.

## Acceptance

`SITE-CHECKLIST` section A: the positioning source is named in the adoption row, each surface it governs
exists, and reading each shows the pillars in the source's order.
