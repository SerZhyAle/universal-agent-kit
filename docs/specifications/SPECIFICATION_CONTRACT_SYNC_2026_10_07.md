**Status:** Draft

# SPECIFICATION - Contract synchronization - universal-agent-kit, round 2026-10-07

Parent: [SPECIFICATION_CONTRACTS_SYNC.md](SPECIFICATION_CONTRACTS_SYNC.md). Opened 2026-10-07, on the portfolio
owner's order, by the canon session; owner of the work: the session that owns this repository. Phase: open -
nothing synchronized yet. Acceptance: the "Definition of done" section below, in full.

Written by the canon session on 2026-10-07, on the owner's order, from the shared contracts catalog's registry and
the contracts' document logs. Hand it to the session that owns this product: that session files it as its own
ticket, edits its own registry rows and its own code, and nobody does either on its behalf. Contracts are cited
by id and section, never linked; the catalog moves before the code (CONTRACTS.md).

**What happened.** On 2026-10-07 the owner sealed every contract in the catalog (only the contract's owner edits it;
every other product files a `PROPOSAL-<date>-<topic>.md`) and had all open proposals accepted. Each accepted
proposal raised the version of the contract it changed and left a dated document-log row. This spec lists
what that asks of this product. A proposal that still needs the owner's choice is **not accepted yet** - where a
log row below says so, the question is open and the text does not bind on that point.

Registry surfaces covered: universal-agent-kit.

## In short - what this round asks of this product

- `PAGE-STYLE` 1.4-1.6 (your page-style proposal, accepted in part): the `Copied` state is a localized word; the
  expand marker is `nav.expand` and the theme button carries a text label (`ICON-SET` ownership of the glyphs);
  44px targets for any pointer. Drop your local override of the expand marker and the theme button and your
  `min(1640px, 94vw)` width **once the hub replaces `sza-kit.css`** - until then the current kit is canonical.
- **Not accepted:** `status.ok` beside the confirmation word - the active `ICON-SET` record `action.copy` needs
  its own copy glyph. The `nav.expand` part matches variant A of `iconography/PROPOSAL-2026-09-24-fms-page-style-kit-symbols.md`;
  if the iconography owner picks variant B the two decisions diverge.
- `PAGE-CONTENT` 1.4: a documentation/method page whose only artifact is a repository-hosted ZIP labels it
  **Download kit (.zip)**; the repository action stays **Source code**.
- `PAGE-STYLE` 1.6: a non-landing page may use a language picker. The language URL parameter name (`?lang=` is
  yours) is an open question for the hub; so is the footer of a non-landing page.
- `ICON-SET` 0.19 (hub controls) is read-only for you; `INSTALL-TRUST` 1.2 if a page carries trust wording.

## Contracts changed on 2026-10-07

| Contract | Surface | Synchronized with | Current | Verified |
| --- | --- | --- | --- | --- |
| `PAGE-CONTENT` | universal-agent-kit | 1.1 | 1.4 | 2026-09-24 |
| `PAGE-STYLE` | universal-agent-kit | 1.0 | 1.6 | 2026-09-24 |
| `REPO-LAYOUT` | universal-agent-kit | 0.9 | 0.11 | 2026-09-24 |
| `REPO-STAMP` | universal-agent-kit | 0.9 | 0.12 | 2026-09-24 |
| `RULE-DELIVERY` | universal-agent-kit | 0.9 | 0.12 | 2026-09-24 |
| `SITE-FAMILY-MAP` | universal-agent-kit | 1.1 | 1.3 | 2026-09-24 |

### `PAGE-CONTENT` - 1.1 to 1.4

Home: domain `product-web-pages/`, status active, owner sza.od.ua hub. Read the domain README at the current version, then the documents it names.

| Date | Version | Kind | What changed | Owed |
| --- | --- | --- | --- | --- |
| 2026-10-02 | 1.2 | additive | `PAGE-CONTENT`, `PAGE-STYLE` and `SITE-FAMILY-MAP` each go to 1.2; `PAGE-CONTENT-VISION` stays 1.1 (a record). Folded from the five proposals in this folder (a `Decision 2026-10-02` section appended to each states what was folded and what stays open). Rule 2 now cites `PAGE-CONTENT` for the order and rule 3 states the stored locale values; section 2 checks the served kit file and requires `-text`. **`reference/sza-kit.css` was revised** (13037 -> 13880 bytes, SHA-256 `e544a6ce47160f827dc97379c3e4814d4aece763593c5a9420e681f1f4e4eb48`, previously `72bd903e7edd4d883106eb296c50b64a6e11731125fab89017320b250332593f`): 44px coarse-pointer targets for `.copybox .copy`, `.to-top` and `.tools-grid a`, .. | Review - adopt it, or record a dated exception saying why not |
| 2026-10-06 | 1.3 | additive, with one correction | `PAGE-CONTENT` and `PAGE-STYLE` go to 1.3 on the owner's ruling of 2026-10-06; `SITE-FAMILY-MAP` stays 1.2 and is only cited (its `Tool` column is the source of the full name; its rule 3 is the author's contact). Rules 2, 8 and 11 are reworded and rules 13 (every page fills the screen) and 14 (the landing always carries seven things) are new. Section 2 gains the width measurement. **`reference/sza-kit.css` was revised** (13880 -> 14521 bytes, SHA-256 `aea958f805249d300b7417373e4cad18b44d7eed9765954df19ed710276c4c9e`, previously `e544a6ce47160f827dc97379c3e4814d4aece763593c5a9420e681f1f4e4eb48`): `--wide` is `100%` instead of `1100px`, a new `--gutter`, the container, the sticky header and th .. | Review - adopt it, or record a dated exception saying why not |
| 2026-10-07 (this round) | PAGE-CONTENT 1.4 | additive | From `PROPOSAL-2026-09-23-documentation-method-start-and-actions.md` item 2: a documentation/method page whose only distribution artifact is a repository-hosted ZIP labels it **Download kit (.zip)**; the repository action stays **Source code**. Items 1 and 3 of the proposal were already folded or closed (1.2, 1.3). | Review - adopt it, or record a dated exception saying why not |

### `PAGE-STYLE` - 1.0 to 1.6

Home: domain `product-web-pages/`, status active, owner sza.od.ua hub. Read the domain README at the current version, then the documents it names.

| Date | Version | Kind | What changed | Owed |
| --- | --- | --- | --- | --- |
| 2026-10-02 | 1.2 | additive | `PAGE-CONTENT`, `PAGE-STYLE` and `SITE-FAMILY-MAP` each go to 1.2; `PAGE-CONTENT-VISION` stays 1.1 (a record). Folded from the five proposals in this folder (a `Decision 2026-10-02` section appended to each states what was folded and what stays open). Rule 2 now cites `PAGE-CONTENT` for the order and rule 3 states the stored locale values; section 2 checks the served kit file and requires `-text`. **`reference/sza-kit.css` was revised** (13037 -> 13880 bytes, SHA-256 `e544a6ce47160f827dc97379c3e4814d4aece763593c5a9420e681f1f4e4eb48`, previously `72bd903e7edd4d883106eb296c50b64a6e11731125fab89017320b250332593f`): 44px coarse-pointer targets for `.copybox .copy`, `.to-top` and `.tools-grid a`, .. | Review - adopt it, or record a dated exception saying why not |
| 2026-10-06 | 1.3 | additive, with one correction | `PAGE-CONTENT` and `PAGE-STYLE` go to 1.3 on the owner's ruling of 2026-10-06; `SITE-FAMILY-MAP` stays 1.2 and is only cited (its `Tool` column is the source of the full name; its rule 3 is the author's contact). Rules 2, 8 and 11 are reworded and rules 13 (every page fills the screen) and 14 (the landing always carries seven things) are new. Section 2 gains the width measurement. **`reference/sza-kit.css` was revised** (13880 -> 14521 bytes, SHA-256 `aea958f805249d300b7417373e4cad18b44d7eed9765954df19ed710276c4c9e`, previously `e544a6ce47160f827dc97379c3e4814d4aece763593c5a9420e681f1f4e4eb48`): `--wide` is `100%` instead of `1100px`, a new `--gutter`, the container, the sticky header and th .. | Review - adopt it, or record a dated exception saying why not |
| 2026-10-07 (this round) | PAGE-STYLE 1.4 | additive | From `PROPOSAL-2026-09-23-universal-agent-kit-page-style.md` (items 4 second half and 7, the 44px defect widened) and `PROPOSAL-2026-09-28-doc-html-translate-page-sync.md` ask 7: the copy button's done state is the localized word for "Copied" (it was "✓ Copied"; the one in-place wording change); section 9 defers to `ICON-SET`, so the disclosure marker is `nav.expand` and the theme control is labelled; `.btn`, `.seg button`, `.theme-btn` and `.to-top` are 44px for every pointer. **A revision of `reference/sza-kit.css` is owed** (section 2); the file here is unchanged and remains canonical until then. | Review - adopt it, or record a dated exception saying why not |
| 2026-10-07 (this round) | PAGE-STYLE 1.5 | correction | From `PROPOSAL-2026-10-06-kit-reduced-motion-pseudo-elements.md`: motion disabled under `prefers-reduced-motion` includes `::before` and `::after`. The prose already said so; the kit's rule did not reach pseudo-elements. The kit revision owed above carries the fix. | Read - code changes only if it relied on the older wording |
| 2026-10-07 (this round) | PAGE-STYLE 1.6 | additive | From `PROPOSAL-2026-10-06-multi-page-site-and-portal.md` asks 1 and 3: a page that is not the landing may carry a language picker (endonym with code, RU EN UA first) instead of the segmented control; section 2 gains the role **Documentation portal**. Rule 3 above notes the picker. | Review - adopt it, or record a dated exception saying why not |

### `REPO-LAYOUT` - 0.9 to 0.11

Home: domain `rule-adoption/`, status draft, owner sza-unified-rules. Read the domain README at the current version, then the documents it names.

| Date | Version | Kind | What changed | Owed |
| --- | --- | --- | --- | --- |
| 2026-10-02 | 0.10 (`REPO-LAYOUT`) | additive | Rule 1: only root files count, and where several of the three names are at the root each carries the canon pointer or delegates wholesale to a sibling that does. Rule 3: a spec-id scheme declared in the agent-rules file is outside the type-prefix requirement wherever it lives. Rule 6: `done/` is an archive spelling beside `archive/`, and the harness default archive folder is unchanged. Closes the contract/canon-prose disagreement that three repositories met; widens no tool behaviour. | Review - adopt it, or record a dated exception saying why not |
| 2026-10-07 (this round) | 0.11 (`REPO-LAYOUT`) | additive | Rule 3 gains a third exception to the type-prefix requirement: the release package files that section 8 of the canon's `RELEASE_AND_DISTRIBUTION` names, under the default names `PLAN/RELEASE_QUEUE.md`, `PLAN/RELEASE_READY.md`, `PLAN/RELEASE_QUEUE_DONE.md` or under whatever names the repository writes into its agent-rules file. Closes the item the spec-scheme proposal left open and the third bullet of CyrFlip's seconding (`PROPOSAL-2026-09-23-own-spec-scheme.md`, `PROPOSAL-2026-09-25-cyrflip-rule-adoption.md` section 1). Documents what the canon prose already allows; no gate checks the prefix, so no reader changes. Not covered: a free-form backlog file such as CyrFlip's `Contract_Conformance_ .. | Review - adopt it, or record a dated exception saying why not |

### `REPO-STAMP` - 0.9 to 0.12

Home: domain `rule-adoption/`, status draft, owner sza-unified-rules. Read the domain README at the current version, then the documents it names.

| Date | Version | Kind | What changed | Owed |
| --- | --- | --- | --- | --- |
| 2026-10-02 | 0.10 (`REPO-STAMP`) | additive | Rule 4 writes the absence meaning of six optional keys it did not name (`ledgerFile`, `versionShape.editionTagPrefixes`, `site.root`, `site.pages`, `privacy.page`, `privacy.sensitiveAccess`; `canon.adoptedOn` deliberately excluded and recorded as open), documents `exemptions[].path` (absent means every path; a case-insensitive wildcard pattern otherwise) and the two keys `docRegistryShape` and `docRegistryFile` already in use, and states the `channels` vocabulary and what an unknown value degrades to; `shapes` is free text. Rule 8 says outright that a version-only re-stamp is a hand write. Every addition describes what readers and stamps already do; no key changes meaning and no stamp must c .. | Review - adopt it, or record a dated exception saying why not |
| 2026-10-07 (this round) | 0.12 (`REPO-STAMP`) | breaking | Rule 4 writes the meaning of an absent or unparseable `canon.adoptedOn`, which 0.10 and 0.11 left open: with `canon.reconciledOn` also absent or unparseable the age is unknown, and an unknown age is read as past the 180-day window, so a differing digest is an error - never an age of zero. An absent date draws no finding of its own. Oldest-consumer test: the reader that shipped before reads such a stamp as age zero, so it silently judges a warning where this says error - hence `breaking`, although no key changes and no stamp has to change (the adoption run always writes `adoptedOn`); only a reader moves, and section 6 says so. Closes the first of the three items the stamp-defaults proposal le .. | MUST adapt - an implementation on the older shape does something wrong against this one |

### `RULE-DELIVERY` - 0.9 to 0.12

Home: domain `rule-adoption/`, status draft, owner sza-unified-rules. Read the domain README at the current version, then the documents it names.

| Date | Version | Kind | What changed | Owed |
| --- | --- | --- | --- | --- |
| 2026-10-02 | 0.10 (`RULE-DELIVERY`) | clarification | Rule 4 states that an equal digest owes nothing, including a stamp write, and that the version moves only through an adoption run. Left open: which run moves `canon.adoptedOn` and how rule 5's 180-day rung is judged (`PROPOSAL-2026-09-23-adoption-date.md`). | Read - code changes only if it relied on the older wording |
| 2026-10-07 (this round) | 0.12 (`RULE-DELIVERY`) | breaking | Rule 5 carries the same reading at the rung where it takes effect: where neither `canon.reconciledOn` nor `canon.adoptedOn` is present and parseable, the age is unknown and read as past the window, so a differing digest is an error. The ladder was silent on that case and the canon's reader filled the silence with age zero (`PROPOSAL-2026-09-23-stamp-defaults.md`). Kind and effect as in the `REPO-STAMP` row above: a reader changes, a stamp does not. | MUST adapt - an implementation on the older shape does something wrong against this one |

### `SITE-FAMILY-MAP` - 1.1 to 1.3

Home: domain `product-web-pages/`, status active, owner sza.od.ua hub. Read the domain README at the current version, then the documents it names.

| Date | Version | Kind | What changed | Owed |
| --- | --- | --- | --- | --- |
| 2026-10-02 | 1.2 | additive | `PAGE-CONTENT`, `PAGE-STYLE` and `SITE-FAMILY-MAP` each go to 1.2; `PAGE-CONTENT-VISION` stays 1.1 (a record). Folded from the five proposals in this folder (a `Decision 2026-10-02` section appended to each states what was folded and what stays open). Rule 2 now cites `PAGE-CONTENT` for the order and rule 3 states the stored locale values; section 2 checks the served kit file and requires `-text`. **`reference/sza-kit.css` was revised** (13037 -> 13880 bytes, SHA-256 `e544a6ce47160f827dc97379c3e4814d4aece763593c5a9420e681f1f4e4eb48`, previously `72bd903e7edd4d883106eb296c50b64a6e11731125fab89017320b250332593f`): 44px coarse-pointer targets for `.copybox .copy`, `.to-top` and `.tools-grid a`, .. | Review - adopt it, or record a dated exception saying why not |
| 2026-10-06 | 1.3 | additive, with one correction | `PAGE-CONTENT` and `PAGE-STYLE` go to 1.3 on the owner's ruling of 2026-10-06; `SITE-FAMILY-MAP` stays 1.2 and is only cited (its `Tool` column is the source of the full name; its rule 3 is the author's contact). Rules 2, 8 and 11 are reworded and rules 13 (every page fills the screen) and 14 (the landing always carries seven things) are new. Section 2 gains the width measurement. **`reference/sza-kit.css` was revised** (13880 -> 14521 bytes, SHA-256 `aea958f805249d300b7417373e4cad18b44d7eed9765954df19ed710276c4c9e`, previously `e544a6ce47160f827dc97379c3e4814d4aece763593c5a9420e681f1f4e4eb48`): `--wide` is `100%` instead of `1100px`, a new `--gutter`, the container, the sticky header and th .. | Review - adopt it, or record a dated exception saying why not |
| 2026-10-07 (this round) | SITE-FAMILY-MAP 1.3 | correction | Recorded here for the synchronization spec, which reads this log: the version was reached earlier the same day in the contract's own log (there marked `corrective`) and was missing from this page, whose header block still said 1.2. The Android row's `Tool` cell reads **Fast Media Sorter & Organizer**, the application's own name, instead of the repository's working name; URL and type unchanged. A sibling footer with the old label links the right page and misstates only the label. | Read - code changes only if it relied on the older wording |
| 2026-10-02 | 1.2 | additive | Rule 4: CyrFlip and OneClickRunner (the absorbed launcher and its standalone original) join the list of contextual cross-links, and a README "Related project" section promoting an unrelated sibling is named as footer duplication (CyrFlip proposal of 2026-09-26, item B7). No row of section 2 changed. Not folded, still open: which pages carry the footer grid (rule 1 against CyrFlip B6 and doc-html-translate ask 2), and a convention for a product with two public entry points. | Review - adopt it, or record a dated exception saying why not |
| 2026-10-07 (this round) | 1.3 | corrective | The Android row's `Tool` cell reads **Fast Media Sorter & Organizer**, the application's own name (`app_name` of the app, its launcher label and its Play listing title), instead of *FastMediaSorter v2*, the repository's working name. `PAGE-CONTENT` 1.3 "The landing always carries" item 1 makes this cell the full name a landing shows in its identity block, so the cell had to be a name a user meets in the product; nobody installs an app called *FastMediaSorter v2*. The URL and the type are unchanged. A sibling footer that still shows the old label links the right page and misstates only the label; it takes the new one at its next re-read (FastMediaSorter S4106). | Read - code changes only if it relied on the older wording |

## Behind from earlier rounds

These contracts did not change today, but the registry shows this product behind them. They are the same
obligation as above, older. The full log range for one contract: run
`pwsh -File tools/contract-lag.ps1 -Product "<name>" -EmitSpec` from the canon repo.

| Contract | Surface | Synchronized with | Current | State | Log entries in range |
| --- | --- | --- | --- | --- | --- |
| `ICON-EXTERNAL` | universal-agent-kit | 0.9 | 0.11 | behind | 4 |
| `ICON-RENDER` | universal-agent-kit | 0.11 | 0.17 | behind | 9 |
| `ICON-SET` | universal-agent-kit | 0.13 | 0.27 | behind | 4 |

## Definition of done

1. Each contract above is read at its current version and cited by id and section, never by catalog path.
2. The implementation matches it, or a dated exception (reason, `until` date) is in REGISTRY section 3. A
   deviation that nothing records is a violation (CONTRACTS.md section 4).
3. The product's own suite runs the catalog's conformance vectors at the current version where the contract has
   any; the command and its exit code are cited. Where it has none, the row says so.
4. The product's own rows in REGISTRY section 2 carry `Implements`, `Reads`, `Verified` (today) and a one-line
   note, in the cell format of that section, one contract id per row. A row that cannot be verified honestly
   stays `pending` with a note naming what is missing.
5. Each `docs/contracts/<ID>.md` pointer names the current version.
6. **No contract document is edited by this product, drafts included - every contract is sealed.** A needed
   change, or a disagreement with an accepted text, is a `PROPOSAL-<date>-<topic>.md` beside the contract in
   its domain folder; the owner decides. Another product's registry rows are not edited either.
