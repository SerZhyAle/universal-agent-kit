# `RULE-DELIVERY` pointer

- Version: 0.12 (draft)
- Role: consumer
- Home: `rule-adoption/README.md` in the shared contracts catalog, section 5

The rules arrive as the `sza` plugin from the public marketplace. The stamp declares the canon version of
the installed plugin together with its core digest, never a version ahead of the published one. A differing
digest is reconciled by re-running the adoption skill: re-read the changed rule documents, then re-stamp.
The staleness ladder judges age from `canon.reconciledOn` when the stamp carries it, and from
`canon.adoptedOn` otherwise (rule 5); where neither is present and parseable the age is unknown and read as
past the 180-day window.

The installed plugin `2026.1109.1` has delivered that unknown-age reading: the probes of 2026-11-10,
documented in the closing audit of `S0001_contract-sync-20261017.md`, FAIL `SZA-CANON03` at error, exit 1,
on an absent or unparseable date, and the registry exception of the older reader closed that day. The
current stamp's valid dates and equal digest still pass the gate; the stamp is behind canon 2026.11.09.1 by
the normal post-bump staleness until the adoption skill re-stamps it.
