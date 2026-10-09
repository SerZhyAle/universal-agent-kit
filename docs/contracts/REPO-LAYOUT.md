# `REPO-LAYOUT` pointer

- Version: 0.11 (draft)
- Role: consumer
- Home: `rule-adoption/README.md` in the shared contracts catalog, section 4

The root carries `CLAUDE.md` (authoritative) and `AGENTS.md` (its companion, with the same canon pointer);
only root files count as agent rules, and each of several agent-rules names at the root carries the canon
pointer or delegates wholesale to a sibling that does (rule 1). `README.md` and `LICENSE` exist at the root.
`kit/CLAUDE.md` and `kit/AGENTS.md` are product payload below the root and are not this repository's rules.
Pointers live here as `<ID>.md` with this index; specifications live in `docs/specifications/` under the
`SPECIFICATION_` prefix. The stamp declares `ledgerShape: none`, and no ledger exists.
