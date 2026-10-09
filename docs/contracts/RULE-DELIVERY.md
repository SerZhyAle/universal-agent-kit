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
