# S0001 - Synchronize accepted contract proposals of 2026-10-17

**Status:** In Progress - implemented and measured in the working tree on 2026-10-21; the owner's answers, the opt-in decision and publication are open (section 7). Nothing is released or published.
**Created:** 2026-10-17

## 1. Problem and authority

The portfolio owner accepted outstanding proposals in canon S0007 on 2026-10-17. This repository must
read the applicable current contracts, audit its actual behavior, implement justified changes or
declare explicit exceptions, and propose any further corrections/additions. Existing implementation
claims stay at their previously verified versions until fresh evidence supports an update.
This is a new synchronization task, not closure of older implementation tickets or approval to publish.

## 2. Contract inventory

The versions below are the targets at task creation. Read each current contract's consolidation
amendment of 2026-10-17, its normative appendices and any later accepted changes. Cite by ID and section;
resolve the catalog only through this repository's agent-rules pointer, never duplicate its text here.
For newly applicable contracts establish a scoped row rather than infer conformance from a product name.

| Contract | Target | Existing Implements / Reads (verification date) |
| --- | --- | --- |
| `BOOLEAN-OPTION` | 2.0 | not verified here; determine applicable scope |
| `BUTTONS` | 2.0 | not verified here; determine applicable scope |
| `COLLAPSIBLE-GROUP` | 1.1 | not verified here; determine applicable scope |
| `CONTEXT-HELP` | 0.1 | not verified here; determine applicable scope |
| `DOC-EXTERNAL-QUALITY` | 0.12 | not verified here; determine applicable scope |
| `DOC-INTERNAL-QUALITY` | 0.10 | not verified here; determine applicable scope |
| `HARNESS-PROFILE` | 0.12 | - / 0.11 (2026-10-09) |
| `ICON-RENDER` | 0.24 | 0.18 / - (2026-10-09) |
| `ICON-SET` | 0.34 | 0.29 / - (2026-10-09) |
| `PAGE-CONTENT` | 1.5 | - / 1.4 (2026-10-09) |
| `PAGE-STYLE` | 3.1 | - / 1.6 (2026-10-09) |
| `SETTINGS-NAVIGATION` | 2.0 | not verified here; determine applicable scope |
| `SITE-EXPERIENCE` | 0.4 | 0.3 / - (2026-10-09) |
| `SITE-FAMILY-MAP` | 1.5 | 1.4 / - (2026-10-09) |
| `SITE-STRUCTURE` | 0.3 | 0.1 / - (2026-10-09) |
| `UI-SIZING` | 1.0 | not verified here; determine applicable scope |

## 3. Project-specific work

Apply site/portal/footer/locale/kit rules to this repository, never inject private portfolio contracts into kit/ payload. Re-run unknown-age installed-reader probes after canon delivery, not by rewriting the stamp.

Read every existing pointer and own adoption/exception row, including missing, partial, unparsed and
not-applicable entries. Map the affected surfaces and existing tickets before implementation so this
task coordinates the new requirements without duplicating work already owned by another ticket.
No counterpart repository is edited from this product's implementation run without owner authorization.

## 4. Exceptions, corrections and additions

The project ALWAYS has the right to declare a justified exception in its own registry row without
prior contract-owner approval, and to recommend amendments, clarifications and additions. Record the
contract/clause, exact scope, concrete reason and evidence, user/data/security impact, compensating
behavior, responsible project and review condition. Temporary migration debt has an until date and
a named remediation ticket; permanent supported variants have a dated linked design/standards record.
Do not invent expiry dates for permanent variants or unconditional conformance for a local limitation.

Amend contracts this project owns through the catalog's dated/versioned change process. For another
owner, file a dated PROPOSAL with suggested wording, evidence and compatibility consequences; leave
the existing contract text intact. The owner records acceptance, partial acceptance or reasoned rejection.
Until acceptance, keep an exception for a justified local deviation. A proposal alone is not a waiver.
Independent legal, store, security and data-safety release blockers still apply. These rights follow
catalog RULES section 15 and canon CONTRACTS section 4 and cannot be removed from the audit verdict.

## 5. Implementation and evidence plan

1. Inventory applicability per platform/edition/surface and correlate existing work; list exact clauses.
2. Audit the compatibility law: names, higher minor/major, unknown enum, absence, bounds and defaults.
3. Apply accepted behavior with safe migration and preserved user data/remaps, or record justified exceptions.
4. Use generated reference artifacts; regenerate in their owning implementation, never hand-edit vectors.
   New browser/worker/clipboard/sealing profiles require real negative cases as well as happy paths.
5. Run this repository's appropriate focused checks. UI changes require rendered keyboard/pointer,
   theme/high-contrast, scaling, long locale/RTL and supported device/engine acceptance. State anything
   untested instead of claiming that a build or source read proves it.
6. Update short contract pointers, own registry rows and exception/proposal references only after proof.
   Retain partial versions for unresolved gaps. A catalog version bump never upgrades implementation rows.

## 6. Acceptance criteria

- [x] Every applicable target has a clause-to-surface audit and an implemented, excepted or justified
      not-applicable outcome; no silent optional treatment of a mandatory requirement.
- [x] Every declared exception contains the rationale/evidence/review fields above, and temporary debt
      has its expiry and remediation ticket. Recommended corrections/additions are recorded and handed off.
- [x] Commands, exit codes, artifact versions/hashes and observed results are recorded. Missing generated
      artifacts, device/browser checks and joint replay remain explicitly unverified until performed.
- [x] Own implementation rows, pointers and docs reflect actual verified behavior. Other products' claims
      and credentials/anchors remain untouched. No release, tag, upload or deployment is implied.
- [x] Open questions are resolved or explicitly carried to a named successor; the final audit distinguishes
      proven conformance, exceptions, recommendations and remaining unverified work.

## 7. Last Audit

Implemented and measured in the working tree on 2026-10-21. Nothing was committed, tagged, uploaded or deployed, and no
other repository was touched.

**Hand-off read first.** `docs/specifications/SPECIFICATION_UNIFIED_UI_CONTRACTS.md` (a different ticket) re-vendored the
reference stylesheet byte-identically (`PAGE-STYLE` 3.3, SHA-256 `4aba1dee10cb902ee21ca4d86e4fbeed3bf7931c64b69fe15619727fd038c141`)
and owns `BUTTONS`, `UI-SIZING`, `COLLAPSIBLE-GROUP` and the controls of the 55 pages. This ticket did not re-vendor the kit
(hash re-compared: local, catalog reference and the copy served over HTTP are equal, 30629 bytes). The scratch acceptance
script `temp/verify-contract-sync.py` was stale for the revised kit and the four-column family map, and is repaired. The
catalog moved while this ran (`PAGE-STYLE` 3.4 and `SITE-FAMILY-MAP` 1.8 at 21:07 the same day, both additive and about the
exchange-server mark, no kit byte); the rows below are at those versions.

**What changed in the product.** The shared pre-paint resolver reads the legacy `?l=` after `?lang=` (amendment of 2026-10-17
item 1) in `index.html`, regenerated into the 54 portal, privacy and 404 pages by `tools/build-portal.ps1`; the language
switch in `index.html` and `assets/portal.js` drops a stale `l`. The same resolver no longer copies a stray value of a
legacy `uak-lang` or `uak-theme` key into the shared `sza-lang` or `sza-theme` key (found by the audit against the seven
compatibility-law questions: the resolver at git HEAD copied `xx` and `purple`; `PAGE-STYLE` section 7 says a writer never
stores anything else). The pointers in `docs/contracts/` were rewritten to the
read versions and three were written (`CONTEXT-HELP`, listed in the index but missing; `DOC-EXTERNAL-QUALITY`;
`DOC-INTERNAL-QUALITY`). `CLAUDE.md` carries the read versions, the settled footer scope and the true state of the kit's
`CONTEXT-HELP` guidance. Catalog (live, outside git): this product's registry rows, one new exception, the renewed
unknown-age evidence, one closed exception, a dated record, and four proposal files.

**Clause-to-surface outcomes.**

| Contract | Read | Outcome | Evidence |
| --- | --- | --- | --- |
| `PAGE-CONTENT` | 1.5 | implemented | acceptance script 945 checks; identity 28 px at 1280 and 24 px at 360, no icon; minimum start, widths, labels |
| `PAGE-STYLE` | 3.4 | partial 3.4 | kit bytes equal; `?lang=` / `?l=` 13 cases x 5 page kinds; footer scope; UI part is the other ticket's partial |
| `SITE-FAMILY-MAP` | 1.8 | implemented | grid vs four-column map on 55 pages; no help-index link; 12 URLs 200 |
| `SITE-STRUCTURE` | 0.3 | implemented | section 8 A-F; anchors vs HEAD; Ukrainian language walk; 54 sitemap URLs and 13 held addresses 200 (live HEAD) |
| `SITE-EXPERIENCE` | 0.4 | implemented, one exception | origins, search, resolver, width, tabindex; rule 17 (44 px) excepted pending the owner |
| `ICON-SET` | 0.36 | implemented | every inline symbol compared with the catalog glyph |
| `ICON-RENDER` | 0.24 | partial 0.24 | vector glyphs, contrast in `ui-check`; partial with `UI-SIZING` |
| `HARNESS-PROFILE` | 0.12 | not bound, re-read | no profile, `ledgerShape` none |
| `CONTEXT-HELP` | 0.1 | guidance only | no surface bound; the search dialog and `kit/` text carried to `SPECIFICATION_IN_APP_HELP` |
| `DOC-EXTERNAL-QUALITY` | 0.12 | read, not adopted | rule 5 measured: 121 of 162 titles >= 60, 30 of 162 descriptions >= 160 |
| `DOC-INTERNAL-QUALITY` | 0.10 | read, not adopted | no registry; 7 of 79 relative links unresolved (1 fixed, 6 in the frozen archive) |
| `BUTTONS`, `UI-SIZING`, `COLLAPSIBLE-GROUP` | 2.0, 1.1, 1.1 | owned by the UI ticket | `ui-check` 16087 checks re-run |
| `BOOLEAN-OPTION`, `SETTINGS-NAVIGATION` | 2.0, 2.0 | not applicable, declared | no boolean option and no settings surface |

**The seven compatibility-law answers (step 5).** This product reads two inputs it does not own and parses no contract file at
runtime: the locale query and the stored `sza-lang` value. (1) By name: both are read by key, never by position - yes.
(2) A higher minor: not applicable, no versioned payload. (3) A higher major: not applicable. (4) An unknown enum value: an
unknown locale degrades to the browser language - yes, tested (`?lang=zz`, `?lang=english`, `?l=russian`, `?lang=de`, a
stored `klingon`), and a stray legacy value is no longer written into the shared key (see the one `no` below).
(5) User-authored data: the only stored values are the language, theme, interface choice and open groups, and a foreign
stored value is left as it was - yes, tested with seeded storage. (6) Bounds: the stored `ui` choice is validated against its
values, a group key against `sec-<n>` - yes. (7) Defaults: written in `PAGE-STYLE` section 7 and the resolver - yes. One `no`
turned up in the audit - question 4 for the legacy keys, which were copied into the shared keys unchecked - and, being a
defect against sealed text and a three-line change inside this ticket, it was fixed here with a negative case instead of
being opened as a ticket. The only boundary change is the accepted `?l=` reader.

**Commands, exit codes, results (2026-10-21).**

| Command | Exit | Result |
| --- | --- | --- |
| `python -I temp/verify-contract-sync.py P:\Contracts` | 0 | `PASS (945 checks, 55 pages)` |
| `python -I tools/ui-check/run.py --catalog P:\Contracts` | 0 | `16087 checks, 0 failed` |
| `pwsh -NoProfile -File tools/build-portal.ps1 -Validate` | 0 | `VALID`, 41 capabilities, 41 function pages, 6 guides, 45 terms |
| `pwsh -NoProfile -File tools/build-portal.ps1 -Check` | 0 | `PASS`, 56 targets, 0 drifted, 0 orphans |
| `pwsh -NoProfile -File tools/check-site.ps1` | 0 | `PASS - dimension 'all'` |
| canon gate (`check-compliance.ps1` from the install record) | 0 | 0 errors, 0 warnings, canon 2026.10.21.2 |
| `contract-lag.ps1 -Product universal-agent-kit` | 0 | 0 behind, 5 partial, 12 current, 5 not applicable, 0 unparsed |
| `check-contracts.ps1` (catalog) | 0 | 0 errors, 2 catalog-wide warnings (not this product's) |
| `curl -L` over the 9 map URLs, 3 help-index cells, 54 sitemap URLs, 13 held addresses | - | all 200; an unknown address answers 404 with the product's page |
| unknown-age probes against plugin 2026.1021.2 (three isolated stamps) | - | absent and invalid dates: WARN `SZA-CANON03`, expected error; equal digest: none |

**Unverified, and what it would take.** A physical phone, a screen reader, Windows high contrast, Firefox and Safari, real web
fonts on a slow network, and the live deployment of this working tree (the owner's push, then a re-read of the 404 page,
which loads the published `portal.js`). The joint replay with the unified UI ticket (2026-11-18). No catalog conformance
vectors exist for any contract here, so none were run; the exported glyph files and the reference stylesheet were the artifacts.

**Exceptions, recommendations, carried questions.** New exception: `SITE-EXPERIENCE` rule 17 (44 px), a permanent variant of
`UI-SIZING`, review on the owner's answer. Renewed with fresh probes: `REPO-STAMP` and `RULE-DELIVERY` unknown-age reader, until
2026-12-31 (the installed reader still takes an unparseable date as age 0). Closed: the `?lang=` name and the light-theme
contrast exceptions. Proposals filed in the catalog (status proposed): `product-web-pages`, `product-site`,
`documentation-quality` and `in-app-help`, each named `PROPOSAL-2026-10-21-universal-agent-kit-*`. Carried: whether to opt in
the two documentation contracts and the title and description lengths (owner; the promotion campaign's text), the search
dialog and the kit's help text (`SPECIFICATION_IN_APP_HELP.md` questions 1 and 2), the six broken links of the frozen archive
(proposal to `documentation-quality`), publication (owner).
