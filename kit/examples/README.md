# Worked example - one small ticket, filled in

Reference only - **do not copy this folder into a project.** It holds an imaginary project's
files, every value in it is that project's and not yours, and nothing in the kit reads it.

The imaginary project is `user-service`, set up with the "Software" column of `docs/REPLACES.md`:
tickets live in `PLAN/`, ids look like `T0042`, and the check that proves a change is `npm test`.
The ticket, T0042, lets an admin download the user list as a CSV file.

| File | Written by | Look at |
| --- | --- | --- |
| `AGENTS.filled-excerpt.md` | you, at merge time | settings filled in; the per-ticket tokens left alone |
| `PLAN/T0042_export-users-csv.md` | `/spec` (sections 1-12), `/spec-tech` (the plan link), `/spec-dev` (`## Manual checks`, the status), `/spec-check` (`## Last Audit`), a person (the ticked line) | the header tokens, §6 resolved, a status that is not `Verified` |
| `PLAN/T0042_export-users-csv/INDEX.md` | `/spec-tech`; `/spec-dev` moves the rows | the phase graph and the one open completion box |
| `PLAN/T0042_export-users-csv/PHASE_01__csv-export.md` | `/spec-tech`; `/spec-dev` ticks the steps and keeps the Step Log | `Prompt for implementer:`, static verifications, the phase check named |

Phases 02 (`export-control`) and 03 (`docs-cleanup`) are left out to keep the example short, so
`INDEX.md` names them without a link; in a real plan both files exist.

## Why it stops at `BlockNeedUserTest`

It is the state most often misread. The build is sound, the audit found nothing wrong, and the
ticket is still not done, because one thing only a person can see has not been seen yet. The ticked
line shows how a person closes a check - a date and what they saw. The open line is what holds the
ticket: the audit counts it (`MANUAL open 1`), but never ticks or rewrites it.

Next: the support lead opens the file in the spreadsheet app, ticks the line and runs
`/spec-check T0042`. The status becomes `Verified`, the `## Last Audit` block is rewritten, and the
temporary `T0042:` log lines are deleted from the code. Full flow: `docs/SPEC_LIFECYCLE.md`.
