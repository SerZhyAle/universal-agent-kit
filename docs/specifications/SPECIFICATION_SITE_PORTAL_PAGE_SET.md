**Status:** Draft

# SPECIFICATION - Publish the portal-tier page set

Parent: [SPECIFICATION_CONTRACT_PRODUCT_SITE.md](SPECIFICATION_CONTRACT_PRODUCT_SITE.md). Opened 2026-10-09
by its P6; the registry exception that carries this gap runs until 2026-12-31.

## Why

`SITE-STRUCTURE` rule 2 with the section 2 table: the owner declared the **portal** tier on 2026-10-09 (D2),
and the site publishes the landing only. Every page type the portal tier requires beyond the landing is owed:
portal home, portal overview, section listings, function pages, features showcase, guide pages by task, a
subject index and a glossary. `SITE-STRUCTURE` rules 4 to 7 (the hand-over from the landing, the portal
chrome, wayfinding) and `SITE-REPRESENTATION` rules 6 to 9 (one function one page, the fixed anatomy, the
interface's own words, availability from a matrix) bind those pages. The portal-tier profile values of
`SITE-STRUCTURE` rule 12 - the capability inventory and the coverage manifest - do not exist yet and belong
to this ticket: the kit's user-visible capabilities (the commands, the role briefs, the spec lifecycle) are
the inventory's subjects.

## What to do

1. Decide the section structure for the kit's capabilities, then build the pages on the shared kit stylesheet,
   at the core-three floor (RU, EN, UA) for every new page group, one address form per group
   (`SITE-STRUCTURE` rules 8, 10).
2. The portal layer takes its tokens from the kit and copies none of its values (`SITE-EXPERIENCE` rule 2);
   the language control of a page that is not the landing is the segmented control or the picker
   (`SITE-EXPERIENCE` rule 10). The footer of a child page follows the hub's open decision - record a dated
   exception naming `product-web-pages/PROPOSAL-2026-10-06-multi-page-site-and-portal.md` if it is still
   open when the pages land.
3. Search is owed only when the corpus passes 25 public pages (`SITE-STRUCTURE` section 2); decide then.
4. Write the capability inventory and the coverage manifest, and keep the release boundary honest
   (`SITE-STRUCTURE` rule 12).
5. Update the sitemap, the adoption rows and this repository's pointer notes in the same change; the
   `SITE-STRUCTURE` exception closes when the page set exists or is renewed with a reason.

## Acceptance

`SITE-CHECKLIST` sections B, C, E and G run clean on the rendered portal, or every open box is a dated
exception with a reason and an `until` date.
