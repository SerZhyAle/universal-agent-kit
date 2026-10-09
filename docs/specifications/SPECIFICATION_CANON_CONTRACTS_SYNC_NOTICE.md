**Status:** Verified 2026-10-09

# SPECIFICATION - Canon and contracts synchronisation notice 2026-10-02

Parent: [SPECIFICATION_CONTRACTS_SYNC.md](SPECIFICATION_CONTRACTS_SYNC.md). Opened 2026-10-02. Rules status:
**SETTLED** (section 4).

## 1. What changed

- The shared canon (the `sza` plugin, version 2026.10.02.x) gained `UI_UX.md`: compact use of the screen, no
  advertising in apps, a friendly and clear voice, one kit of colours, icons and buttons, with FastMediaSorter
  Android as the reference. It also folded lessons from all ten projects: release and CI safety, testing,
  security including untrusted input, layout, and the audit-campaign method.
- The shared contracts catalog folded 53 proposals as dated MINOR amendments. Two of them started from this
  repo's own proposals (the documentation/method page variant, and this repo in the iconography consumers).
- The canon's compliance run on this repo today: 0 errors, 1 warning (SZA-CANON03, stale adoption stamp).

## 2. This repo's contracts

Pinned version is what the pointers in `docs/contracts/` say today; the second number is the catalog now.

| Contract | Role here | Pinned -> now | What moved for this repo |
| --- | --- | --- | --- |
| `PAGE-CONTENT` | consumer | 1.1 -> 1.2 | the method-page variant (path choice and minimum start open right after the hero) is now written down; a "Child pages" paragraph; a paid path is never in the primary get-it row |
| `PAGE-STYLE` | consumer | 1.0 -> 1.2 | the reference stylesheet was revised (13037 -> 13880 bytes) and every consumer re-vendors it; kit-extension mechanism; a multi-line copy may read the adjacent `<pre>` |
| `SITE-FAMILY-MAP` | consumer | 1.1 -> 1.2 | rule 4: two more contextual cross-links; a README "Related project" section promoting an unrelated sibling counts as footer duplication |
| `ICON-SET` | consumer, opted in | 0.13 -> 0.17 | 56 meanings added (0.14 to 0.17); 0.15 adds notes on `action.copy` (the copied state is the word "Copied" beside the same glyph) and `nav.scroll-top` |
| `ICON-RENDER` | consumer, opted in | 0.11 -> 0.15 | SVG subset stated; web hit-target floor stays 44 px; `state.warning` day tone is now `#EF6C00` (the site uses ok and error only) |
| `ICON-EXTERNAL` | consumer, opted in | 0.9 -> 0.11 | this repo named in the consumers line; a language is marked by its own name, never by a flag |
| `REPO-STAMP` | producer | 0.9 -> 0.11 | optional `canon.reconciledOn`; a version-only re-stamp is a hand write |
| `REPO-LAYOUT` | consumer | 0.9 -> 0.10 | only root files count; each of several agent-rules names carries the canon pointer or delegates |
| `RULE-DELIVERY` | consumer | 0.9 -> 0.11 | the 180-day staleness age runs from `reconciledOn`, else from `adoptedOn` |
| `HARNESS-PROFILE` | not bound | 0.9 -> 0.10 | rule 7: a repo that never runs the harness declares the profile not bound in its pointer and registry row |

Not bound, as before: `CHECK-VERDICT`, `CHECK-BASELINE`, `CHECK-PLACEMENT`, `BUILD-EVIDENCE` (the build check
aligns voluntarily), `INSTALL-TRUST`, `WAVE-PARTICLES`, and the desktop-app and data-format contracts.

## 3. What this repo must do

- [x] Run the canon's `adopt-canon` skill in a session started in this repo: re-sync `canon.version`,
  `canon.coreDigest` and `canon.reconciledOn`; `adoptedOn` stays 2026-09-23. Clears SZA-CANON03.
- [x] Run `contract-sync`: bump the nine pointers and the table in `docs/contracts/README.md`, the version
  numbers in the root `CLAUDE.md` "Shared contracts" section, and the table in
  `SPECIFICATION_CONTRACTS_SYNC.md`; write dated verification into this repo's own registry rows.
- [x] Re-vendor `assets/sza-kit.css` from the revised reference (the file here is 13037 bytes, SHA-256
  starting `72bd903e`; the catalog now holds 13880 bytes, starting `e544a6ce`). `.gitattributes` already
  keeps it `-text`. Rebuild with `tools/build-kit.ps1`, then walk the `PAGE-STYLE` section 11 checklist again.
- [x] Narrow the dated `PAGE-STYLE` exception row (until 2026-12-31): 1.2 now allows the `<pre>` copy and
  defines the kit-extension mechanism. Container width, `?lang=` against the contract's parameter, the
  copy-confirmation wording and the disclosure and theme glyphs stay open in the catalog's own log.
- [x] Re-verify the `PAGE-CONTENT` and `SITE-FAMILY-MAP` rows against 1.2, including the section 5 URL check.
  Checked today: `README.md` has no "Related project" section.
- [x] Declare `HARNESS-PROFILE` not bound in a pointer and in the registry row (rule 7); today only the
  contracts README says so.
- [x] Verify the five glyphs on `index.html` (download, copy, scroll to top, ok, error) against `ICON-SET` 0.17,
  in particular the copied-state note on `action.copy`, and that `NOTICE.md` still carries the attribution.

Owner decisions of 2026-10-02: advertising stays out and is only a declared exception on a product site - checked
today, no ad or analytics script on `index.html` and none declared in the stamp; colours default to the shared
kit values, which the stylesheet refresh above restores. The others (destructive-confirmation focus, window
hit targets, shell re-registration, system animation, `state.warning` day tone) do not apply to a static page.

## 4. Status: SETTLED

From this notice the rules and contracts above are settled for this repo. It synchronises to them and does not
re-open them for taste, convenience or schedule. They can still change, only through the two legal routes:
amend the contract in the catalog with a version bump, or record a dated exception in the registry. The
reason must be a weighty one, as `CONTRACTS.md` section 4 "Settled law" defines it: a defect that harms a user
or loses data; a hard platform, law or store constraint; a security or privacy exposure; or evidence from two
or more products that the rule does not hold. Taste and deadlines are not reasons. Until a change is accepted,
the settled text binds.

## 5. Evidence

2026-10-02. Derived from the canon's compliance run on this repo, the catalog registry and the contract change
logs, and a read of this repo's pointers and files. Nothing was run in the product itself.

## 6. Verification - 2026-10-09

Implemented 2026-10-09. Before the run the catalog had moved past this notice's "now" column again: the
2026-10-07 owner order sealed every contract, accepted the open proposals and published a further kit
revision, tracked in [SPECIFICATION_CONTRACT_SYNC_2026_10_07.md](SPECIFICATION_CONTRACT_SYNC_2026_10_07.md).
Both rounds were carried in one synchronisation, because the catalog is the source of truth and a version
may not be pinned to a date the catalog has already left behind. What this repo now holds:

| Contract | Pinned -> synchronized | Note |
| --- | --- | --- |
| `PAGE-CONTENT` | 1.1 -> 1.4 | "Download kit (.zip)" is now the contract's stable label, with this page as its evidence; the hero opens with the full name in display type (1.3, docs variant: the name alone) |
| `PAGE-STYLE` | 1.0 -> 1.6 | kit re-vendored byte-identical (15661 bytes, SHA-256 `27501a10..`); full width, copied word beside the `action.copy` glyph, the kit's `nav.expand` marker and labelled theme control, 44 px for every pointer |
| `SITE-FAMILY-MAP` | 1.1 -> 1.4 | footer labels corrected to the `Tool` cells "Fast Media Sorter & Organizer" and "STREAMS Player"; section 5 URL check 9/9 HTTP 200 |
| `ICON-SET` | 0.13 -> 0.29 | the copied state is the word "Copied" beside the copy glyph; `status.ok` withdrawn from the page |
| `ICON-RENDER` | 0.11 -> 0.18 | web hit-target floor 28/44 px; the kit carries the 44 px targets |
| `ICON-EXTERNAL` | 0.9 -> 0.12 | no flags anywhere; `NOTICE.md` attribution carried to 0.29 |
| `REPO-STAMP` | 0.9 -> 0.12 | `reconciledOn: 2026-10-09` written with `version` `2026.10.02.3` and the fresh digest; `adoptedOn` stays 2026-09-23 |
| `REPO-LAYOUT` | 0.9 -> 0.11 | only root files count; both root files carry the canon pointer |
| `RULE-DELIVERY` | 0.9 -> 0.12 | the 180-day clock runs from `reconciledOn` |
| `HARNESS-PROFILE` | 0.9 -> 0.11 | declared not bound in `docs/contracts/HARNESS-PROFILE.md` and in the registry row (rule 7) |

The `PAGE-STYLE` exception row in the registry is narrowed to the one question still open with the owner,
the language URL parameter's name (`?lang=` against `?l=`), until 2026-12-31; its width, copy-confirmation
and glyph items were closed by the owner's rulings of 2026-10-06/07 and the page now conforms to them.

Evidence: `pwsh -NoProfile -File <installed-sza>/tools/check-compliance.ps1` - before the run
`0 error(s), 1 warning(s)` (SZA-CANON03), after it `0 error(s), 0 warning(s)`, exit 0, canon
`2026.10.02.3`; `pwsh -NoProfile -File tools/build-kit.ps1` - `build-kit: PASS`, 45 entries, 0 mismatches,
stamped 2026-10-09; `cmp` of `assets/sza-kit.css` against the reference equal; the section 5 URL check
9/9 HTTP 200 on 2026-10-09. The `PAGE-STYLE` section 11 checklist was walked against the source; no
browser was run in this session, so the rendered walk of 2026-09-23 was not repeated.
