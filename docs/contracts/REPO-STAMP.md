# `REPO-STAMP` pointer

- Version: 0.13 (draft); 0.12 read on 2026-10-21, the 0.13 amendment read on 2026-11-10
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

The accepted unknown-age reading is delivered: installed plugin `2026.1109.1` (canon 2026.11.09.1, updated
2026-11-09) is the reader of the 2026-11-10 probes, and an absent or unparseable date now FAILs
`SZA-CANON03` at error, exit 1, 'unknown age, treated as past 180 days' (probes against isolated scratch
stamps: a differing digest with both dates absent, a differing digest with invalid dates, and a copy of
the real stamp, which reports no CANON03 finding; the real stamp keeps valid dates and an equal digest).
The registry exception of the older reader closed on 2026-11-10. The stamp itself is 20 days behind canon
2026.11.09.1 - the normal after-a-bump staleness - and its re-stamp belongs to the adoption skill, never a
hand write; no stamp rewrite can fix a reader, and none is needed now that the reader conforms.
