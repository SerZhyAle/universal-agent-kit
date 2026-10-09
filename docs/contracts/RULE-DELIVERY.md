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

The installed plugin `2026.1002.3` has not delivered that unknown-age reading: the isolated probe documented
in the synchronization specification reports `WARN SZA-CANON03`, exit 0. Use of that reader is recorded in
REGISTRY section 3 until 2026-12-31, with
`PROPOSAL-2026-10-09-universal-agent-kit-stamp-reader.md` asking its owner for delivery. The current stamp's
valid dates and equal digest pass the gate; that result does not prove the missing-date branch conforms.
