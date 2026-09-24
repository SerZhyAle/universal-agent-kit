**Status:** Verified

# SPECIFICATION - Align the repository with the shared contracts (umbrella)

Opened 2026-09-23 from a read-only audit of the repository against the shared contracts catalog. The
catalog's location is named in exactly one place, the root `CLAUDE.md`; this document cites contracts by id
only.

## Problem

The root `CLAUDE.md` states that this repository "implements no contract and consumes none, checked on
2026-09-22", and the catalog's registry repeats it ("no contract of any kind"). Both are wrong:

- the catalog names `universal-agent-kit` as a consumer of `PAGE-CONTENT`, `PAGE-STYLE` and
  `SITE-FAMILY-MAP`, assigns the site the "Informational / Docs" page type, and lists its URL in the family
  map - and the site already breaks `SITE-FAMILY-MAP` rule 1;
- the repository produces a canon stamp (`REPO-STAMP`) and consumes `REPO-LAYOUT` and `RULE-DELIVERY`,
  which the catalog covers under its 2026-09-22 carve-out for the machine-readable side of a rule set;
- the new iconography domain (`ICON-SET`, `ICON-RENDER`, `ICON-EXTERNAL`) binds "every product with a user
  interface" once it opts in, and the site shows six icon-like glyphs, five of which conflict with it.

The 2026-09-22 reasoning was right in the narrow sense - no byte format a second product parses, and
`kit/` is method, which the catalog excludes - but it missed that a public page and a stamp file are
contracts too.

## Goals

1. Every contract that touches this repository has one specification here, and each one says both what
   the repository must change and what the catalog must change (by proposal, never by edit of another
   owner's text).
2. The agent-rules file tells the truth about the contracts this repository consumes and produces.
3. Each touched contract has a pointer under `docs/contracts/` - id, version, role, what conformance
   requires - and nothing more.
4. The registry carries this product's own rows with an honest verified date, and every deviation that is
   not fixed at once becomes a dated exception with an `until` date.
5. Contracts that do *not* apply are declared as such, so the next run does not re-litigate them.

## The contracts and their specifications

| Contract | Version | Role here | Specification |
| --- | --- | --- | --- |
| `PAGE-CONTENT` | 1.1 active | consumer | [SPECIFICATION_CONTRACT_PAGE_CONTENT.md](SPECIFICATION_CONTRACT_PAGE_CONTENT.md) |
| `PAGE-STYLE` | 1.0 active | consumer | [SPECIFICATION_CONTRACT_PAGE_STYLE.md](SPECIFICATION_CONTRACT_PAGE_STYLE.md) |
| `SITE-FAMILY-MAP` | 1.1 active | consumer | [SPECIFICATION_CONTRACT_SITE_FAMILY_MAP.md](SPECIFICATION_CONTRACT_SITE_FAMILY_MAP.md) |
| `ICON-SET`, `ICON-RENDER`, `ICON-EXTERNAL` | 0.13 / 0.11 / 0.9 draft | consumer on opt-in | [SPECIFICATION_CONTRACT_ICONOGRAPHY.md](SPECIFICATION_CONTRACT_ICONOGRAPHY.md) |
| `REPO-STAMP`, `REPO-LAYOUT`, `RULE-DELIVERY`, `HARNESS-PROFILE` | 0.9 draft | producer of the stamp; consumer of the rest; profile not used | [SPECIFICATION_CONTRACT_RULE_ADOPTION.md](SPECIFICATION_CONTRACT_RULE_ADOPTION.md) |
| `CHECK-VERDICT`, `BUILD-EVIDENCE` (+ `CHECK-BASELINE`, `CHECK-PLACEMENT`) | 0.9 draft | not bound; voluntary alignment | [SPECIFICATION_CONTRACT_AUTOMATED_CHECKS.md](SPECIFICATION_CONTRACT_AUTOMATED_CHECKS.md) |

## Declared not applicable (no specification)

| Contract | Why |
| --- | --- |
| `INSTALL-TRUST` 1.0 | The only download is the zip: 45 entries, 43 Markdown files, one `settings.json` with permissions and a commented-out hook example, one `merge-prompt.txt`. Nothing installs, executes or asks for elevation, so no operating-system warning exists to answer. The existing registry row stays; its note should name the `.txt` entry too and drop "no contract of any kind". |
| `WAVE-PARTICLES` 0.10 | The site has no canvas, keyframes or animation loop, and this product is not a named consumer. |
| `APP-BEHAVIOUR`, `APP-STYLE` 0.9 | No desktop application. |
| `STREAM-BANK`, `LIVE-BROADCAST`, `FDSEC-*`, `FMSCFG`, `SHARE-SESSION`, `WORKER-IPC`, `CLI-EVENT-STREAM`, `LAYOUT-*`, `SCENARIO-FILE`, `OCR-*` | Functions this repository does not perform. |
| `kit/` content | Agent method. The catalog excludes it by name; the canon owns it. It stays scrubbed: no contract id, no catalog name, no portfolio path ever enters `kit/`. |

## Constraints

- **Contract before code.** Where a specification concludes the contract is wrong, the proposal is filed
  in the catalog first; the site does not ship ahead of it.
- **Another owner's contract is amended by proposal only** - a `PROPOSAL-<date>-<topic>.md` beside the
  contract. This repository owns none of the contracts above.
- **Own registry rows only.** Placeholder rows ("the eight product pages", "every canon-adopting
  repository") are left for their owners; this product declares its own rows beside them.
- **No catalog path in a tracked file** outside the one place in `CLAUDE.md`.
- **`index.html` changes land in all three locales in one edit**, and the zip plus the page date are
  rebuilt with the one build script, never by hand.
- The gate must exit 0 before any commit at the root or under `kit/`.

## Work items owned by this specification

1. Rewrite the "Shared contracts" section of `CLAUDE.md`: list the consumed and produced contracts by id,
   keep the catalog named there and nowhere else, and keep the rule that `kit/` never names it.
2. Create `docs/contracts/` with one pointer per contract id this repository touches, plus a short index.
3. Declare this product's registry rows for `PAGE-CONTENT`, `PAGE-STYLE`, `SITE-FAMILY-MAP`, `REPO-STAMP`,
   `REPO-LAYOUT`, `RULE-DELIVERY`, and - once opted in - the three icon contracts; correct the note on the
   existing `INSTALL-TRUST` row.
4. Record a dated exception for each deviation a per-contract specification leaves open.

## Done criteria

- `CLAUDE.md` names every touched contract by id and names the catalog once.
- `docs/contracts/` holds one pointer per id in the table above that has a role here, each under a page.
- The registry has a row per contract with a role, dated, with a note; every open deviation has an
  exception with an `until` date.
- Each per-contract specification is at `Verified` or carries a `Block*` status with a one-line reason.
- Gate run cited with exit code and output.

## Open questions - answered 2026-09-23

1. **Iconography opt-in.** The icon contracts are drafts and bind only products that opt in. Opt in now,
   or wait until the conflict with `PAGE-STYLE` section 9 is settled? (Recommended: opt in now and file
   the conflict as a proposal - the site gains a coherent glyph set either way.)
2. **Visual identity.** Full `PAGE-STYLE` conformance replaces the site's own indigo-violet palette and
   fonts with the shared kit. Adopt, or record a dated exception? See the `PAGE-STYLE` specification.

Both were answered as recommended: the site opted in to the iconography contracts (see the iconography
specification) and adopted the shared visual identity with no exception on palette, fonts or favicon (see
the `PAGE-STYLE` specification).

## Verification - 2026-09-23

| Done criterion | Result |
| --- | --- |
| `CLAUDE.md` names every touched contract, the catalog once | The "Shared contracts" section lists the six site contracts, the three rule-adoption contracts with their roles, `HARNESS-PROFILE` as having no role, and the not-applicable set. The catalog path appears in that section only; the gate's contracts check agrees. |
| One pointer per id with a role | `docs/contracts/` holds `PAGE-CONTENT`, `PAGE-STYLE`, `SITE-FAMILY-MAP`, `ICON-SET`, `ICON-RENDER`, `ICON-EXTERNAL`, `REPO-STAMP`, `REPO-LAYOUT`, `RULE-DELIVERY`, each short and naming id, version, role and home, plus a `README.md` index. |
| Registry rows and exceptions | Rows for all nine, dated 2026-09-23. The `INSTALL-TRUST` note now names the 45 entries including `merge-prompt.txt`; the phrase "no contract of any kind" was already gone. The one open deviation, the `PAGE-STYLE` page layer, is an exception until 2026-12-31. The `PAGE-CONTENT` zip-download label is an owner question filed as a proposal, not a deviation. |
| Per-contract specifications | `PAGE-CONTENT`, `PAGE-STYLE`, `SITE-FAMILY-MAP`, iconography, rule adoption and automated checks: all `Verified`. |
| Gate | `check-compliance: universal-agent-kit - 0 error(s), 0 warning(s) (overlay ?, canon 2026.09.22.2)`, exit 0. |
