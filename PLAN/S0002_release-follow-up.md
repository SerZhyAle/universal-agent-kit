# S0002 - Release follow-up

**Done 2026-11-11 (S0009, owner's order "do 1,2,3,4").** `assets/sza-kit.css` re-vendored at `PAGE-STYLE`
3.8; canon re-synced to `2026.11.10.1` (compliance 0 errors, 0 warnings); the second pre-flight
`PASS: publish pre-flight`, exit 0, 290 s (browser check 16383 checks, 0 failed); a rendered pass of the
`SITE-CHECKLIST` boxes the gates do not run, 73 checks, 0 failed, with 15 screenshots reviewed; generated files
committed with their sources and `main` pushed. The paragraph below is the first run of the same day.

**State on 2026-11-11, first run (S0009, an owner-named pre-flight, nothing committed or published).** The portal
sources were corrected and all 23 changed capabilities re-read and accepted; `-Validate` exits 0.
`tools/check-release.ps1 -Catalog <catalog-root>` ran once: `build-kit: PASS` (56 entries, 0
mismatches, stamped 2026-11-10), `build-portal: PASS` (56 targets written), `build-portal: VALID`,
`-Check` PASS (0 drifted), `check-site: PASS - dimension 'all'`, compliance 0 errors and 1 warning
(`SZA-CANON03`, the canon stamp is stale), browser check **FAIL**: 16383 checks, 1 failed -
`kit: assets/sza-kit.css is byte-identical to the catalog reference`. The catalog reference was
amended after this repository's copy was taken (line 331, `--acc` became `--acc-strong`). **The
pre-flight verdict is FAIL and the publish is blocked** until the contracts side takes the new
stylesheet revision with its pointer (`docs/contracts/PAGE-STYLE.md`) and the browser check is
re-run. Still owed after that: the rendered `SITE-CHECKLIST`, the screenshots of the changed
landing, the review and commit of the generated files, the publish. The text below is the record
as S0002 left it.

**RELEASE:** Review the changed portal sources against the kit and accept their capability digests
with `pwsh -NoProfile -File tools/build-portal.ps1 -Accept <capability-ids>`. Then run
`pwsh -NoProfile -File tools/check-release.ps1 -Catalog <catalog-root>`: it rebuilds the zip and
date stamps, generates and validates the portal, checks generated drift and the site, runs the
compliance gate, and runs the browser check. The build also publishes the S0001-closing source
changes of 2026-11-10 to the render targets: the `hreflang` alternates (`DOC-EXTERNAL-QUALITY`
0.13 item S) in every page head and the sitemap, and the `SITE-FAMILY-MAP` 1.9 Windows label in
the footer grids. Perform and record the rendered `SITE-CHECKLIST`,
review and commit the generated files, then publish.

**NOT APPLICABLE - release tier:** Those commands were not run for S0002. The zip, portal and
site were not regenerated; release gates and browser checks were not run. Not built, not tested
until the release. A decision is still needed before placing a stale source commit on `main`, which
publishes immediately.

The pre-flight includes these deferred commands:

- `pwsh -NoProfile -File tools/build-kit.ps1`
- `pwsh -NoProfile -File tools/build-portal.ps1`
- `pwsh -NoProfile -File tools/build-portal.ps1 -Validate`
- `pwsh -NoProfile -File tools/build-portal.ps1 -Check`
- `pwsh -NoProfile -File tools/check-site.ps1`
- `pwsh -NoProfile -File <sza-install-path>/tools/check-compliance.ps1`
- `python -I tools/ui-check/run.py --catalog <catalog-root>`

Capture and review screenshots of the changed landing page at release.

**RELEASE - S0008 browser exit behavior:** Run `python -I tools/ui-check/run.py --catalog <catalog-root>`
and record its exit and verdict. Verify separately that an unavailable Playwright package, an unreadable
catalog or page set, and an unlaunchable Chromium return exit 2 / `COULD NOT VERIFY`; an unreachable
control after checks start remains exit 1 / `FAIL`. The release pre-flight blocks both nonzero exits.
Use isolated `--out` paths for failure probes so normal evidence is preserved.
