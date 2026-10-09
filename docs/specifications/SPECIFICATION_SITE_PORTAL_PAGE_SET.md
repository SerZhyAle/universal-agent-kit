**Status:** BlockNeedUserTest - the deployed pages and reduced motion are read after the site is published; everything that can be read before is verified

# SPECIFICATION - Publish the portal-tier page set

Parent: [SPECIFICATION_CONTRACT_PRODUCT_SITE.md](DONE/SPECIFICATION_CONTRACT_PRODUCT_SITE.md). Opened 2026-10-09
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

## Verification - 2026-10-09

- **Structure decided.** Seven sections, in the order of the six pillars of `POSITIONING.md` plus one for adopting the kit: rules, skills, role agents, spec lifecycle, persistent memory, parallel-agent discipline, adopt and adapt. A section listing is a titled section of the portal home that links every function page of the section.
- **The page set.** 54 public pages in the sitemap: the landing, `privacy.html`, the portal home (`portal/`), the overview, the features showcase, the subject index, the glossary, 6 guides by task and 41 function pages (one per capability: 5 rules, 12 skills, 4 role agents, 8 lifecycle, 2 memory, 3 parallel, 7 adopt), plus the not-found page. Search is owed above 25 pages and is built (local index, native modal dialog). All in RU, EN and UA, one address form per group, in one document per page.
- **The layers.** `assets/portal.css` takes every colour, font and radius from the kit's tokens and defines only `--prose-w` and `--panel-gap`; the language control is the segmented control; the footer of every child page is the footer of `SITE-FAMILY-MAP` rule 1 as it stands, so the hub's open question (ask 2 of its multi-page proposal) is followed, not deviated from.
- **The inventory and the manifest.** `tools/portal/inventory.json` lists every capability with its facts (kind, section, name, sources, permissions, runtime); `tools/build-portal.ps1` refuses a payload file of `kit/` that is neither a source of a capability nor listed as excluded with a reason (`kit/VERSION`, a build stamp, is the one exclusion), keeps one review digest per capability so that a changed kit source fails validation until its page is re-read and accepted, and counts commands, agents and practices from the inventory for the overview. The showcase is drawn from the inventory's shipped records.
- **Checklist boxes read in a browser** (Chrome, working tree served locally): B - the chrome identical on the home, a listing section and function pages, the navigation behind one labelled control at 360 px, breadcrumbs, the kit byte-identical (SHA-256 `27501a10..` equal to the catalog copy), no style attribute, landmarks, origins, resolver; C - the anatomy (title, lead, requirements, steps, outcome, related) on all 41 function pages by `check-site -Dimension page-set`, and several pages read in the browser and in the generated text (the Russian and Ukrainian wording was written and checked by reviewers, not by a native proofreader); E - the language control writes only `ru`, `en` or `ua` (`?lang=uk` stores `ua`), every target answers, the glossary and subject index follow the language; G - the showcase, subject index and glossary are generated from the sources.
- **Registry.** The exception row for the portal page set is removed; the adoption rows record the tier, the page set and what was not run.

Gates run 2026-10-09 on the working tree after the last change: `build-portal.ps1 -Validate` VALID (41 capabilities, 41 function pages, 6 guides, 45 terms), `build-portal.ps1 -Check` PASS (0 drifted, 0 orphans), `check-site.ps1` PASS (dimensions held-addresses, page-width, page-set, positioning, origins, portal-fresh), `build-kit.ps1` PASS (55 entries, 0 mismatches), `check-compliance.ps1` 0 error(s), 0 warning(s), exit 0.

## Manual checks

- [ ] After the site is published: request every address in `sitemap.xml` and confirm HTTP 200, then crawl from the landing and confirm each page is reached in three steps (the offline gate already proves this for the working tree).
- [ ] Reduced motion (`SITE-CHECKLIST` I): see the landing ticket; the same box covers the portal pages.
