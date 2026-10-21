# `HARNESS-PROFILE` pointer

- Version: 0.12 (draft); read on 2026-10-21
- Role: not bound
- Home: `rule-adoption/README.md` in the shared contracts catalog, section 3

This repository never runs the shipped harness, so it has no `.sza-profile.json` for that reason - which is
a different fact from "the defaults apply" (rule 7). Its tickets live in `docs/specifications/` where the
defaults do not look; a harness run here would not fail, it would report an empty queue. The contract is
declared not bound here and in this product's registry row, and a checker treats a missing profile as
expected. The 0.12 amendment (a ledger-shape 1 or 3 repository keeps its dev-log separate and may set
`paths.changelog` empty) changes nothing for a repository with no profile and `ledgerShape` `none`.
