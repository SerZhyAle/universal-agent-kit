**Status:** Draft

# SPECIFICATION - Conform the site to PAGE-CONTENT 1.1

Parent: [SPECIFICATION_CONTRACTS_SYNC.md](SPECIFICATION_CONTRACTS_SYNC.md). Audit date 2026-09-23.

## Contract

- **Id / version:** `PAGE-CONTENT` 1.1, active. Owner: the portfolio hub. Its long-form record
  `PAGE-CONTENT-VISION` 1.1 carries the reasoning, including a paragraph written about this product.
- **Role here:** consumer. The public page `index.html` (RU/EN/UK) is bound as a
  **documentation / method** page.
- **What binds this page:** the "documentation / method" variant - hero with the method's promise ->
  audience -> choice of path -> minimal start -> detailed method -> download and help; the no-sales
  stance; the no-invention rule; the layout contract; the copy rules; the acceptance test read off the
  rendered page.
- **What does not bind:** the mandatory app page order (not an app), the hub contract (not the hub), the
  "dangerous path never first" rule (nothing here deletes data or asks for elevation).

## Where the page stands

| Rule | Verdict | Evidence |
| --- | --- | --- |
| Hero states the method's promise | holds | H1 and lead in the hero block |
| Audience named | holds | hero kicker; "who this is for" in the open section 00 |
| Choice of path | holds | hero buttons "adopt in an existing project" / "start new" jump to the two paths |
| **Minimal start near the top** | **deviates** | the minimal-start callout lives inside collapsed section 11; the record's paragraph on this product asks for the path choice and the minimal result at the top |
| Detailed method in disclosure groups | holds | sections 00-13, only 00 and 01 open by default |
| Download and help | holds | footer: zip, repository, licence |
| Full content width | holds | container scales to 1640 px / 94 vw |
| Brand once, hero without the name | holds | brand in the header only |
| No emoji, no urgency, no ads | holds | only text glyphs (the icon specification handles them) |
| **Stable action labels** | **deviates, minor** | "Download kit", "Adopt..." rather than the contract's stable labels; the repository link is labelled "GitHub" |
| **Sibling tool linked for what it does** | **deviates** | the provenance line's "FastMediaSorter" points to the author's GitHub profile, not to the product's page in the family map |
| Acceptance test | holds on reading | "this is ___, I need it when ___, I start with ___" is answerable above the fold |

## Goals

1. The minimal start - what a reader gets in the first ten minutes - is visible without opening a
   collapsed section, in all three locales.
2. Action labels follow the contract's stable vocabulary where one exists; where the page needs a label the
   contract does not have ("Download kit (.zip)"), that is raised as a proposal, not invented silently.
3. Every in-text mention of a sibling product links to that product's page from the family map (shared
   with `SITE-FAMILY-MAP` rule 4).

## Changes asked of the contract (proposals to the owner)

1. **Where the minimal start sits** in the documentation/method variant, and whether the path choice must
   be above the fold - the variant names the blocks but not their placement.
2. **Labels for a docs page whose download is a zip in the repository** rather than a release: which
   stable label replaces "Get started" / "Download", and whether the repository link must read
   "Source code".
3. **Width conflict** (shared with `PAGE-STYLE`): this contract asks for the full available width, while
   `PAGE-STYLE` section 5 and its reference stylesheet pin a 1100 px container. One of the two must say
   which wins.

## Constraints

- All three locales change in one edit.
- No new claim enters the page that the kit does not back (the no-invention rule).
- Nothing here touches `kit/`.

## Done criteria

- A read of the rendered page in each locale passes the acceptance test and shows the minimal start without
  expanding anything.
- The provenance link resolves to the sibling product's page from the family map.
- Each proposal above exists in the catalog beside the contract, or the owner has answered it.
- This product's registry row for `PAGE-CONTENT` is written with the date of that read.

## Open questions

1. Promote the minimal start into the hero note, or into a short always-open section right after it?
   (Recommended: a short always-open block right after the hero, so the hero stays one promise.)
