# `REPO-STAMP` pointer

- Version: 0.9 (draft)
- Role: producer
- Home: `rule-adoption/README.md` in the shared contracts catalog, section 2

`.sza-canon.json` at the root is this repository's stamp: valid JSON, every required key, the optional keys
explicit, `role: portfolio`, no exemptions. It is written only by the canon's adoption skill - version from
the installed plugin, digest from the gate's `-PrintDigest` - never by hand. Its `$comment`, `tagRegex: null`
and `ledgerShape: none` are the recorded rolling-release divergence and stay. Conformance evidence is a gate
run with no `SZA-CANON03` and the registry row.
