# `HARNESS-PROFILE` pointer

- Version: 0.14 (draft); read on 2026-10-21 at 0.12, the 0.13 and 0.14 amendments read on 2026-11-10
- Role: not bound
- Home: `rule-adoption/README.md` in the shared contracts catalog, section 3

This repository still never runs the shipped harness - so the contract stays not bound here (rule 7), and a
checker's "the defaults apply" reading is excluded by that fact. Correction of the record (2026-11-10): an
untracked [.sza-profile.json](.sza-profile.json) exists at the root since 2026-10-29, written for the
portfolio runner's task-flow ledger (owner order) - it names the spec journal, the archive and the ticket-file
paths, not the plugin's shipped harness. Its tickets live in `docs/specifications/` (`ledgerShape: none` in
the stamp remains true; the profile is the runner's index, not a ledger shape). The 0.13
(legacy-preserving carriers and dispatch, document-to-wire mapping, staged migration) and 0.14
(`runner.instances` agent fields, never written by the portfolio) amendments are additive and bind no run
here.
