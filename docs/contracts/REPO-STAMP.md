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

The installed reader (plugin `2026.1002.3`) still reads an unknown age as zero; an isolated differing-digest
stamp with neither date produces a warning, exit 0, rather than the rule 4 error. This repository produces
a stamp with both dates and implements no reader. Its use of the older reader is a dated registry exception
until 2026-12-31; the owner is asked to deliver the accepted rule by
`PROPOSAL-2026-10-09-universal-agent-kit-stamp-reader.md`. No stamp rewrite can fix a reader's fallback.
