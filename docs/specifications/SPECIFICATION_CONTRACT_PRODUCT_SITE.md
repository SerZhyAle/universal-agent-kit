**Status:** Verified 2026-10-09 (P3 ran against the source and the live deployment; the browser boxes are recorded as not run)

# SPECIFICATION - Product site contracts synchronization: SITE-STRUCTURE, SITE-EXPERIENCE, SITE-REPRESENTATION 0.1

Parent: [SPECIFICATION_CONTRACTS_SYNC.md](SPECIFICATION_CONTRACTS_SYNC.md). Opened 2026-10-06. Sibling of
[SPECIFICATION_CANON_CONTRACTS_SYNC_NOTICE.md](SPECIFICATION_CANON_CONTRACTS_SYNC_NOTICE.md), which covers the
2026-10-02 amendments to the contracts this repository already holds; this one covers three contracts it does
not hold yet. Date: 2026-10-06.

This repository keeps no numeric ticket ids: a specification is
`docs/specifications/SPECIFICATION_<TOPIC>.md`, and its id is its file name. This file follows the closest
convention, the `SPECIFICATION_CONTRACT_<NAME>.md` family, with the Status line first.

## Why this exists

On 2026-10-06 the shared contracts catalog gained a new domain, `product-site/` (catalog ticket S4096): three
contracts for a product's multi-page site and help portal, and a run-list that checks them. They were drawn from
one implementation, FastMediaSorter Android's site, and are written as the target state. All three are **draft
0.1**. A draft binds its owner and any product that opts in (`VERSIONING.md` section 1); the catalog's ladder to
1.0 needs a second product to register an adoption row (rung 2) and then each candidate to confirm or record
dated exceptions (rung 3). This repository publishes a site, and the domain README names it as a candidate
consumer or its site falls under the page-tier subset below, so the catalog is waiting for this repository's
answer. (Factual note from the first read: the domain README section 4 names five candidates - FastMediaSorter
Lite, CyrFlip, doc-html-translate, FileDO and StreamsPlayer - and this product is not among them; it is the
page-tier subset that applies.)

No registry row for these three contracts exists for this product yet, so `tools/contract-lag.ps1` in the canon
cannot generate this spec; it is written by hand from the contracts' own text. Nothing a conforming site did
yesterday becomes wrong today: the contracts are new, not amendments.

## The contracts

| Contract | Version | Status | What it fixes | Rules |
| --- | --- | --- | --- | --- |
| `SITE-STRUCTURE` | 0.1 | draft | the tier (page, guide, portal) and the page types each owes; reach in three steps from the landing; portal chrome and wayfinding; permanent addresses, forwarders and the list of addresses held outside the site; the locale obligation per page group; a missing translation never a dead end; a function ships with its page; the not-found page | 15 |
| `SITE-EXPERIENCE` | 0.1 | draft | the portal layer over the kit and its components; language and theme as one shared state; local search and its keyboard and screen-reader contract; every third-party origin declared and named on the privacy page; keyboard, landmarks, contrast, alt text, reduced motion | 19 |
| `SITE-REPRESENTATION` | 0.1 | draft | one positioning source with ordered pillars; a fact typed once in its source; the public editions with one display name each; one function, one page, with a fixed anatomy; availability marks derived from the matrix; the showcase says only what shipped; the trust pages say one thing | 12 |

All three live in the catalog domain `product-site/` with the run-list `SITE-CHECKLIST.md`, which is read off the
**rendered published site in a browser** and not off the source. The rules cite, and do not repeat, `PAGE-CONTENT`,
`PAGE-STYLE`, `SITE-FAMILY-MAP`, `DOC-EXTERNAL-QUALITY`, `DOC-INTERNAL-QUALITY`, `INSTALL-TRUST`, `ICON-SET`,
`ICON-RENDER`, `ICON-EXTERNAL` and `WAVE-PARTICLES`; a site that already conforms to those is most of the way
there.

**One thing is open and is not this repository's to decide.** The hub has a proposal pending
(`product-web-pages/PROPOSAL-2026-10-06-multi-page-site-and-portal.md`) on three points: which language control a
non-landing page carries, whether a portal page carries the tools grid and the contact in its footer, and whether
a documentation portal gets a role in `PAGE-STYLE` section 2. Until the hub answers, follow the text as it stands
and record a deviation on those points as a dated exception that names the proposal - never as a softened rule.

## What binds a page-tier site

A product with only a landing, a privacy page and the pages a channel requires is at the **page** tier and is bound
by `SITE-STRUCTURE` rules 1, 2, 8, 10 and 11; `SITE-EXPERIENCE` rules 1, 7, 13, 14 and 15 to 19;
`SITE-REPRESENTATION` rules 1 to 5 and 12. A **guide**- or **portal**-tier site is bound by the rest as well
(`SITE-STRUCTURE` section 2 table). A product declares one tier and never one lower than the pages it publishes.

Likely tier for this repository: **page** (see the next section). So the phases and decisions below that exist
only for a guide or portal tier do not apply here: in P2 the capability inventory and the coverage manifest, and
in D2 the extra page types; likewise the rules outside the subset above (portal chrome, wayfinding, search,
function pages, showcase). They are kept in the text, not deleted, so the page-tier answer is a stated choice
and not a silent omission; if D2 chooses a higher tier they apply in full.

## This repository

First read, read-only, 2026-10-06, of the working tree on `main`. Nothing was run in a browser and no gate was
run; none of it is a conformance verdict.

**Product and what it publishes.** The Universal Agent Kit: a portable method for working with AI agents,
distributed as `universal-agent-kit.zip` built from `kit/` (`AGENTS.md` "Project Structure"; `CLAUDE.md` "Render
targets"). The only published page is the root `index.html`, served by GitHub Pages from `main` at the repo root
(`CLAUDE.md` "Render targets"; `.nojekyll`). `README.md` is the repository landing and is a listing surface, not
a site page. Rolling release, no tags (`CLAUDE.md` "Release shape").

**Page types of the `SITE-STRUCTURE` section 2 table.** Present: the landing (`index.html`, a single document
with 48 `<details>` disclosure sections, first at `index.html:310`). Absent as files: a privacy page, an
install-trust page, an edition or channel page, guide pages, a subject index, a glossary, any portal page, a
release-notes page, a roadmap, and a not-found page (root listing: no `404.html`, no other `.html`). Which of
these the product owes is open: `.sza-canon.json` records `privacy.page: null` with `carveOut: "zero-data"`
and `site.pages: ["index.html"]`; `SPECIFICATION_CONTRACTS_SYNC.md` "Declared not applicable" and the registry row for `INSTALL-TRUST` record that
contract as out of scope for this product. The first read suggests one landing, so the page tier.

**Address scheme.** One address, `https://serzhyale.github.io/universal-agent-kit/` (canonical link,
`index.html:8`). A locale is a query parameter on the same document: `?lang=en|ru|uk`, with `hreflang` alternates
and `x-default` (`index.html:9-12`; `sitemap.xml`). The published domain and the repo name are frozen anchors
(`CLAUDE.md` "Render targets"). Section anchors exist (`#minimum-start`, `#adopt`); no file lists addresses
held outside the site.

**Locales.** Three in one file, RU, EN and UA (`index.html:226-231` switch; `data-l` markup; `lang` and the
sitemap keep ISO `uk`, `docs/contracts/PAGE-STYLE.md`). All page content sits in the one landing, so there is one
page group.

**Third-party origins in the HTML, CSS and JS.** Contacted at load: `fonts.googleapis.com` and
`fonts.gstatic.com` (`index.html:64-66`, Outfit and Plus Jakarta Sans). The file has no `src=` attribute, no
`fetch` or `XMLHttpRequest`, no analytics, advertising or release-API call (grep over `index.html`; the
2026-10-02 notice records the same for ads and analytics). Other hosts are outbound links only (GitHub, Anthropic,
OpenAI and Antigravity documentation links at `index.html:662-664`, sibling sites and `sza.od.ua` at
`index.html:1463-1481`). The download link is relative (`index.html:234`, `:265`); the raw GitHub zip URL
appears inside copyable prompt text (`index.html:555`, `:593`, `:932`).

**Presence of the artifacts.** Vendored `assets/sza-kit.css`: present, 13037 bytes, SHA-256 `72bd903e` (full
`72bd903e7edd4d883106eb296c50b64a6e11731125fab89017320b250332593f`); the catalog reference
`product-web-pages/reference/sza-kit.css` is 13880 bytes, SHA-256 `e544a6ce`, so the two **differ** today (the
2026-10-02 notice already carries the re-vendoring). Sitemap: `sitemap.xml`, one URL with three `hreflang`
alternates, date stamped by `tools/build-kit.ps1`. `robots.txt`: present, points at the sitemap. Custom 404:
none. Search index: none. Privacy page: none. Install-trust page: none. Positioning source: none found as a
document; the closest text is the opening of `README.md` and the `description` and Open Graph tags of
`index.html:6-23`.

**Existing gates touching the site.** `tools/build-kit.ps1` rebuilds the zip, verifies each entry against `kit/`
by SHA-256 and stamps the kit date into `index.html`, JSON-LD `dateModified` and `sitemap.xml`
(`tools/build-kit.ps1`; `AGENTS.md` "Build, Test"). The canon's `check-compliance.ps1` is the commit gate
(`CLAUDE.md` "Gate"). No script checks addresses, links, locales or the page set.

**Open work touching the site.** [SPECIFICATION_CANON_CONTRACTS_SYNC_NOTICE.md](SPECIFICATION_CANON_CONTRACTS_SYNC_NOTICE.md)
(Draft, untracked in the tree on 2026-10-06, written by another session) lists re-vendoring `assets/sza-kit.css`,
narrowing the `PAGE-STYLE` exception, and re-verifying the glyphs. Its rows are in the open and must not be
duplicated here. [SPECIFICATION_CONTRACT_PAGE_STYLE.md](SPECIFICATION_CONTRACT_PAGE_STYLE.md) and its siblings are
`Verified` for the earlier contract versions.

**Registry.** Rows for this product exist for `PAGE-CONTENT`, `PAGE-STYLE`, `SITE-FAMILY-MAP`, `INSTALL-TRUST`,
the three icon contracts and the three rule-adoption contracts (registry section 2, dated 2026-09-24). None
exists for `SITE-STRUCTURE`, `SITE-EXPERIENCE` or `SITE-REPRESENTATION`. One open exception overlaps in subject,
not in rule: the `PAGE-STYLE` page layer (registry section 3, until 2026-12-31), which includes `?lang=` winning
over the stored language and a text-label theme control - `SITE-EXPERIENCE` on language and theme state may read
on the same items.

**Not checked.** Rendered behaviour in any browser (focus order, contrast, the network panel, reduced motion,
narrow viewport); the live site and its HTTP responses; whether GitHub Pages serves a custom 404 here; the
glyphs and the copy of each of the 48 sections; the contents of `kit/` against `SITE-REPRESENTATION`; the
sibling sites' addresses; the git history of `index.html`.

## What the repository must do

Work in order; each phase ends in a statement a command or a file can confirm.

- [x] **P0 - Read.** The three contracts and `SITE-CHECKLIST.md` at 0.1, and the hub proposal above. Cite each by
  id and section in the ticket and in every registry note; never by catalog path.
- [x] **P1 - Decide with the owner (D1 to D3 below)** before any registry row is written.
- [x] **P2 - Write the profile.** The values the rules read, in this product's adoption rows (they are listed in
  the domain README section 4): the tier and any page type beyond the table; the locale set of each page group
  (landing; portal, guides and function pages; trust and privacy pages; reference pages) - the core three
  (`PAGE-STYLE` section 4.2) are the floor of every group unless a reference group is declared single-language
  with its reason; the address scheme and the file that lists every address an outside surface holds (in-app help
  links, store listings, READMEs, sibling sites); the third-party origins the pages contact; the positioning
  source with its ordered pillars and any store-policy exception; the public editions, their display names and the
  source they derive from; the device classes; at the portal tier, the capability inventory and the coverage
  manifest.
- [x] **P3 - Measure.** Run `SITE-CHECKLIST.md` against the rendered published site (or a local build served
  exactly as published), page group by page group. Record one verdict per group in the product's adoption row:
  **conforms**, or the box that failed with a dated exception, with the date and the commit or deployment the pages
  were read from. A box that was not run is written as not run, never as ticked. Boxes that need a browser (focus
  order, contrast, the network panel, reduced motion) are run in one, not inferred from the source.
- [x] **P4 - Pointers.** `docs/contracts/SITE-STRUCTURE.md`, `docs/contracts/SITE-EXPERIENCE.md` and
  `docs/contracts/SITE-REPRESENTATION.md`, each in the repository's existing pointer format, naming version 0.1,
  status draft, the role here and what the repository must do to stay conformant; the index in
  `docs/contracts/README.md` gains the three rows. The `contract-sync` skill of the canon plugin does this side.
- [x] **P5 - Registry.** The product's own rows in the catalog registry section 2, **one contract id per row**:
  `Implements` is `0.1`, `partial 0.1`, or `-` with `Reads` `0.1`; `Verified` is the date of P3; the note is one
  line naming the tier and the verdicts. Each gap is a dated exception in section 3 (the rule, the reason, an
  `until` date) with a ticket of its own. A product edits its own rows only; no contract document and no other
  product's row is touched.
- [x] **P6 - Park the gaps.** Every gap P3 found becomes its own ticket (a draft is enough) and is not fixed inline
  here. This ticket ends at measurement and registration; closing the gaps is the work it hands on.
- [x] **P7 - Mechanical evidence.** For each rule, write down whether a gate in this repository holds it or it is
  manual (the form of the Conformance table at the end of each contract). Propose a new gate only where a rule is
  decidable offline in an arbitrary repo with a near-zero false-positive rate; a gate that cries wolf gets
  disabled.

Repository-specific notes for the project session, none of which changes a phase: the root `CLAUDE.md`
"Shared contracts" section also gains the three ids (it lists every contract this repository touches, and a
site contract that binds the page is one); a pointer must stay out of `kit/`; any `index.html` change that
follows from a gap lands in all three locales in one edit and the zip and dates are rebuilt with
`tools/build-kit.ps1`, never by hand; and the gate must exit 0 before a commit at the root. For a page-tier
product the likely hot spots are the privacy page and the declaration of the Google Fonts origins
(`SITE-EXPERIENCE` rule 14), the not-found page (`SITE-STRUCTURE` rule 15, where GitHub Pages allows a root
`404.html`), the address list (rule 8) and the one-source positioning (`SITE-REPRESENTATION` rules 1 and 2); these
are things to measure in P3, not conclusions.

## Decisions that are the owner's

- **D1 - Opt in now, or defer.** The contracts are draft; adoption is voluntary below 1.0. Recommended: register
  the rows and measure, because the measurement is what turns a draft into a contract the portfolio can rely on,
  and a gap recorded with a date costs nothing until it expires.
- **D2 - The tier** (page, guide or portal) and, for a guide or portal tier, whether the product wants to publish
  the extra page types now or records them as dated exceptions. For this repository the first read points to the
  page tier, which makes the extra page types of a guide or portal not applicable; the owner confirms.
- **D3 - Locale sets per page group** where the repository publishes more than the core three: which extra locales
  are declared for which group, since a locale beyond the core three counts only when it is declared. The first
  read finds exactly the core three (RU, EN, UA) in one page group, so the expected answer is "none beyond the
  core three".

An unanswered owner decision stops the phase that needs it (`BlockQuestions`); it is not guessed.

## Out of scope

- Editing any contract document or any other product's registry row. A needed contract change is a proposal beside
  the contract (`PROPOSAL-<date>-<topic>.md`), raised through the canon session, and the catalog moves before the
  code.
- Redesigning the site. This ticket measures and registers; it does not restyle, translate or rewrite pages.
- The landing's own look and order (`PAGE-STYLE`, `PAGE-CONTENT`) and the freshness of the corpus
  (`DOC-EXTERNAL-QUALITY`): those are other contracts with their own rows.
- A release, a deploy or a site publish. Nothing here is billable or one-way.

## Definition of done

1. The three contracts are read at 0.1 and cited by id and section, never by catalog path.
2. D1 to D3 are answered by the owner in this ticket, or the ticket is `BlockQuestions` with the reason.
3. `SITE-CHECKLIST.md` was run per page group; the verdict, the commit or deployment read and the boxes not run
   are written in the adoption rows.
4. Every gap is a dated exception in the registry section 3 with `until` and a ticket, or the rule is conformed
   and the row says so.
5. The three pointers exist at 0.1 and the pointer index lists them; the repository's compliance check reports no
   new contract-pointer finding.
6. The product's own rows carry `Implements`, `Reads`, `Verified` (the date of P3) and a one-line note, in the cell
   format of the registry section 2.
7. Open questions are answered or handed to a named successor ticket; none is left inside this one.

## Evidence

Derived 2026-10-06 from the three contracts and the run-list in the catalog domain `product-site/`, from the hub
proposal of the same date, and from a first read of this repository's tree (see "This repository"). The first read
is not a conformance verdict: nothing was run in a browser.

## Decisions - answered 2026-10-09

- **D1 - Opt in now.** Register and measure, as recommended. The three rows are in the registry section 2,
  `Verified` 2026-10-09; this ticket ran P2 to P7 in the same session.
- **D2 - The tier: portal.** The owner chose the portal tier, above the page tier the first read pointed to.
  Every rule of the three contracts binds in full from today; each page type the tier requires and the site
  does not publish is a dated exception in the registry section 3 with a successor ticket (P6), because this
  ticket measures and registers and does not build ("Out of scope"). The tier is never declared below what is
  published, and nothing the page-tier subsets conformed to is withdrawn - they are subsets of the set that
  now binds.
- **D3 - Locales: the core three, nothing beyond.** The one page group (the landing) is declared RU, EN, UA;
  no group exists beyond it today.
- **One decision outside the ticket's list:** the working tree's uncommitted `docs/` ignore line stays (owner
  answer, 2026-10-09); the new files under `docs/` are force-added, and the earlier session's pending
  deletions and `.gitignore` change are left untouched.

**Version note.** This ticket was written against `SITE-EXPERIENCE` 0.1; the contract is at **0.3** today
(0.2 added rule 20, the full width, binding every tier, the landing included; 0.3 amended rule 10 with the
picker form the hub accepted on ask 1 of the 2026-10-06 proposal). 0.3 is what was read and registered. Both
changes are additive, and the page the 2026-10-09 sync left in the tree already conforms to rule 20 at the
source. Ask 2 of the same proposal, the child-page footer, is still open in the hub's domain and is recorded
inside the portal ticket as the dated-exception point the ticket's "One thing is open" section asks for.

## Verification - 2026-10-09

Read from the live deployment (the previous push, still serving the pre-2026-10-07 page; fetched over HTTP
this date) and the working tree at the 2026-10-09 sync commit. No browser was run in this session; the boxes
that need one are recorded as not run in the adoption rows, never ticked.

| Phase | Result |
| --- | --- |
| P0 | `SITE-STRUCTURE` 0.1, `SITE-EXPERIENCE` 0.3, `SITE-REPRESENTATION` 0.1 and `SITE-CHECKLIST.md` read, with the domain README, the hub proposal (asks 1 and 3 accepted, ask 2 open) and the 2026-10-09 support-page proposal (open; its condition - a support route beyond the footer contact - does not hold for this product, so the page is not owed) |
| P1 | D1 to D3 answered above, before any registry row was written |
| P2 | The profile sits in the three adoption rows: the tier and the page types owed; the locale set (RU, EN, UA, one group); the address scheme (one permanent address, locale as `?lang=<ISO>` on the root document) and the missing held-address list; the third-party origins (`fonts.googleapis.com`, `fonts.gstatic.com`); the missing positioning source; one public edition (`universal-agent-kit.zip`, from `kit/` via `tools/build-kit.ps1`); responsive device classes; the capability inventory and coverage manifest recorded as not existing yet (rule 12, the portal ticket) |
| P3 | The table below |
| P4 | The three pointers exist in the repository's pointer format - `docs/contracts/SITE-STRUCTURE.md` (0.1), `docs/contracts/SITE-EXPERIENCE.md` (0.3), `docs/contracts/SITE-REPRESENTATION.md` (0.1) - and the index in `docs/contracts/README.md` carries the three rows; the root `CLAUDE.md` "Shared contracts" names the three ids; nothing was added under `kit/`; the gate reports no new contract-pointer finding |
| P5 | Three adoption rows, one contract id per row, `Implements` `partial 0.1` / `partial 0.3` / `partial 0.1`, `Reads` `-`, `Verified` 2026-10-09, with the tier and the verdicts in each note; five dated exceptions in section 3, each with its reason and `until` 2026-12-31; no contract document and no other product's row was touched |
| P6 | Six successor tickets under `docs/specifications/`: the portal page set, the privacy page, the not-found page, the held-address list, the positioning source, and the landing experience gaps with the browser half |
| P7 | The evidence table below |

### P3 - the run-list, page group by page group

The landing is the only published group; its verdict is **conforms on the boxes that bind today, with five
gaps as dated exceptions, and the browser boxes not run**. The groups the portal tier owes - the portal,
guides and function pages; the trust and privacy pages; the reference pages - publish nothing yet; their
boxes are not run, and their page types are the portal exception.

| Checklist box | Verdict |
| --- | --- |
| A - the tier declared, the sitemap and the page set agree (ST 1, 2 partly) | conforms once this round's rows exist: the sitemap lists the one page that exists |
| A - the page types the tier requires (ST 2) | fails: the portal page set is not published (exception; the portal, privacy and not-found tickets) |
| A - the crawl and the landing's seven things (ST 3, `PAGE-CONTENT`) | conforms for what exists: one page, nothing unreachable; the landing's own walk is the `PAGE-CONTENT` row of 2026-10-09, except the portal link (ST 4, rides the portal ticket) |
| A - the positioning source (RP 1, 2) | fails: no source document exists (exception; the positioning ticket) |
| E - the language control, the locales, the dead ends (ST 9, 10, 11) | conforms: the segmented control of `PAGE-STYLE` section 4.2; three targets, each answered (HTTP 200 over `?lang=ru`, `?lang=en`, `?lang=uk`, fetched 2026-10-09); no link leads to an address that does not answer |
| F - the trust and privacy pages (EX 14, RP 12) | fails: the privacy page does not exist, so the two declared origins are named nowhere (exception; the privacy ticket); the landing makes no data claim, so nothing contradicts |
| G - the generated pages (ST 14, RP 3, 4, 10, 11) | not owed where the conditions do not hold (no dated releases, no settings screen); the showcase waits on the portal ticket; no edition, device, version or channel string is typed in copy (verified by search; the kit date is rendered by the build) |
| H - the addresses and the not-found page (ST 8, 15) | fails twice: no file lists the addresses outside surfaces hold (exception; the held-addresses ticket), and an unknown address returns the host's default page while GitHub Pages allows a root `404.html` (exception; the not-found ticket). The one address that exists has never moved |
| I0 - the full width (EX 20) | conforms at the source in the working tree (the 2026-10-09 sync dropped the `min(1640px, 94vw)` cap); the live deployment still serves the capped page - the sync commit is not published, and publishing is the owner's push, outside this ticket; the box was not run in a browser |
| B - the kit byte-identical (EX 1) | the same deployment split: the served file is the pre-2026-10-07 kit (SHA-256 `72bd903e..`, 13037 bytes); the tree's `assets/sza-kit.css` is byte-identical to the catalog copy (`27501a10..`, 15661 bytes, compared this session), linked before the page layer |
| I - keyboard, contrast, motion (EX 15, 17, 19) | not run - no browser in this session; the source-level findings are recorded as the exception the landing-experience ticket closes: no skip link (EX 15), no `nav` landmark (EX 16), one static `style` attribute on the `noscript` fallback (EX 4) |

### P7 - what holds each binding rule

Mechanical in this repository today: the kit date and the JSON-LD `dateModified` are rendered by
`tools/build-kit.ps1`, which verifies every zip entry against `kit/` (RP 3, EX 13 - a hand-typed date is
overwritten at the next build), and the compliance gate holds the pointer and stamp surfaces. Everything else
is manual this round, evidenced by the searches and HTTP fetches above. Two gates are proposed, each
decidable offline in an arbitrary tree with a near-zero false-positive rate: the held-address resolver
(ST 8, ticket `SPECIFICATION_SITE_HELD_ADDRESSES.md`) and a stylesheet parser refusing a width cap or a centred margin on a page wrapper (EX 20, handed to `SPECIFICATION_SITE_LANDING_EXPERIENCE.md`). No gate is proposed for a rule that needs a rendered page (contrast, focus, motion) - a gate that cries wolf gets disabled.

### Definition of done - checked 2026-10-09

1. Read and cited by id and section - yes; the version note records that `SITE-EXPERIENCE` is 0.3 and 0.3 is what was read.
2. D1 to D3 answered by the owner in this ticket - yes, above.
3. The run-list ran per group, with the verdict, the deployment and commit read and the boxes not run written into the adoption rows - yes (deployment: the previous push, fetched 2026-10-09; tree: the 2026-10-09 sync commit; the browser boxes: not run).
4. Every gap is a dated exception with `until` and a ticket, or the row says conformed - yes; five exceptions, `until` 2026-12-31.
5. The three pointers exist and the index lists them; the compliance check reports no new contract-pointer finding - yes: `check-compliance: universal-agent-kit - 0 error(s), 0 warning(s) (overlay none, canon 2026.10.02.3)`, exit 0, 2026-10-09.
6. The product's own rows carry `Implements`, `Reads`, `Verified` and a one-line note - yes, in the cell format of the registry section 2.
7. Open questions answered or handed to a named successor ticket - yes; the hub's ask 2 (the child-page footer) is carried inside the portal ticket as the dated-exception point, and no other question of this ticket is left open.
