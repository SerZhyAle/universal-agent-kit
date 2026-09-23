**Status:** Draft

# SPECIFICATION - Conform to the rule-adoption contracts

Parent: [SPECIFICATION_CONTRACTS_SYNC.md](SPECIFICATION_CONTRACTS_SYNC.md). Audit date 2026-09-23.

## Contracts

All four are **0.9 drafts**, owned by the canon repository, and describe the machine-readable interface
between a rule set and a repository that adopts it.

| Id | Role here | Verdict |
| --- | --- | --- |
| `REPO-STAMP` | producer of `.sza-canon.json` | holds except rule 8: the stamp is stale |
| `REPO-LAYOUT` | consumer of the names | holds; rule 2 becomes due once `docs/contracts/` is created |
| `RULE-DELIVERY` | consumer of the plugin | holds; rule 5 asks for the stale-stamp reconciliation |
| `HARNESS-PROFILE` | none | no profile file, which rule 7 defines as "the defaults"; the packaged harness is not run here |

## Where the repository stands

- **Gate** (canon plugin 2026.922.2, run from the repository root on 2026-09-23): exit 0, 0 errors, 1
  warning - `SZA-CANON03 .sza-canon.json: adoption is stale: stamp digest sha256:cdf49be6.. vs canon
  sha256:13abcb8a.. (canon 2026.09.22.2, adopted 2026-09-11)`.
- **`REPO-STAMP`:** one file at the root, valid JSON, every required key present, optional keys explicit,
  `role: portfolio` from the closed list, no exemptions, the contrib record resolves. Rule 8 deviates:
  `canon.version` is 2026.09.08.2 against a current 2026.09.22.2, and the core digest differs. Twelve days
  old against a 180-day error threshold, so a warning, not a failure.
- **`REPO-LAYOUT`:** the agent-rules file is the root `CLAUDE.md` only (the `kit/` copies are payload and
  not at the root); `README.md` and `LICENSE` at the root; `ledgerShape: none` and no ledger. There is no
  `docs/` tree yet; this specification set creates `docs/specifications/`, and the umbrella specification
  creates `docs/contracts/`, both under the names the contract fixes.
- **`RULE-DELIVERY`:** the plugin arrives from the public marketplace at a version derived from the canon
  version; the declared version does not run ahead of the published one.

## Goals

1. The stamp matches the current canon: the rule documents changed between 2026.09.08.2 and 2026.09.22.2
   are read and reconciled, and the stamp is rewritten by the adoption skill, never by hand.
2. The layout the contract names is what the repository keeps: pointers under `docs/contracts/`,
   specifications under `docs/specifications/` with the `SPECIFICATION_` prefix.
3. This product declares its own registry rows for `REPO-STAMP`, `REPO-LAYOUT` and `RULE-DELIVERY` instead
   of sitting inside the "every canon-adopting repository" placeholder.
4. `kit/` stays free of the stamp, the plugin name and the catalog: an outsider's copy of the kit carries
   no adoption interface.

## Changes asked of the contract (proposals to the owner)

1. **Gate summary for roles without an overlay** prints `overlay ?`; `overlay none` would say what is true
   for `role: portfolio`.
2. **A repository whose product is a template** (this one ships `kit/CLAUDE.md` and `kit/AGENTS.md` as
   payload) - `REPO-LAYOUT` rule 1 is silent on agent-rules files below the root. Ask for one sentence
   saying only the root's files count, so a future gate change does not read the payload as a second
   rules file.

## Constraints

- The stamp's `$comment` and the rolling-release fields (`tagRegex: null`, `ledgerShape: none`) are the
  recorded divergence from the canon's version-shape rule and stay.
- The canon re-sync is its own commit, separate from site changes.

## Done criteria

- Gate: exit 0 with no `SZA-CANON03`, output cited.
- `docs/contracts/` and `docs/specifications/` exist with correctly prefixed files.
- Registry rows for the three contracts written with the date of the gate run.
- The two proposals exist beside the contract or have been answered.

## Open questions

None needing the owner: the re-sync path is the adoption skill's.
