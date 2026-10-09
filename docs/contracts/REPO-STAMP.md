# `REPO-STAMP` pointer

- Version: 0.12 (draft)
- Role: producer
- Home: `rule-adoption/README.md` in the shared contracts catalog, section 2

`.sza-canon.json` at the root is this repository's stamp: valid JSON, every required key, the optional keys
explicit, `role: portfolio`, no exemptions. It is written only by the canon's adoption skill - version from
the installed plugin, digest from the gate's `-PrintDigest` - never by hand, and a version-only re-stamp
is a hand write too (rule 8). A reconciliation writes `canon.reconciledOn` together with
`canon.version` and `canon.coreDigest`, and never moves `canon.adoptedOn` (rule 8); where neither date is
present and parseable the age is unknown and read as past the 180-day window (rule 4). Its `$comment`,
`tagRegex: null` and `ledgerShape: none` are the recorded rolling-release divergence and stay. Conformance
evidence is a gate run with no `SZA-CANON03` and the registry row.
