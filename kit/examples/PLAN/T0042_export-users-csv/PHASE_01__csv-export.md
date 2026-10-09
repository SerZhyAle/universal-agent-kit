# Phase 01 - CSV export

**Strategic spec:** [`../T0042_export-users-csv.md`](../T0042_export-users-csv.md)
**Tactical index:** [`INDEX.md`](INDEX.md)
**Status:** ✅ Done
**Depends on:** none - foundation phase
**Steps done:** 3 / 3

## Objective
The service returns the whole filtered user list as one CSV file, to admins only.

## Prerequisites
- [x] All "Depends on" phases are ✅ Done.
- [x] Strategic §6 items blocking this phase are Resolved.
- [x] Working tree clean or on a feature branch.

## Files touched
| File | New / Modified | Line budget |
|------|:--------------:|------------:|
| `src/api/user-export.js` | New | ≤ 500 |
| `src/api/routes.js` | Modified | ≤ 500 |
| `src/api/user-export.test.js` | New | ≤ 500 |

> Backup any file over ~500 lines before editing; split anything heading past your
> file-size budget via a helper/extraction step.

## Steps

### Step 01.1 - Add the CSV builder
**Files:** `src/api/user-export.js`
**Depends on:** - start of phase

**Prompt for implementer:**
> Create `src/api/user-export.js` exporting `toUserCsv(users)`. It returns a UTF-8 byte-order
> mark, the header row `id,name,email,team,created`, then one row per user in that column order.
> Quote any field holding a comma, a quote or a line break, doubling inner quotes; prefix any field
> starting with `=`, `+`, `-` or `@` with an apostrophe.

**Verification:**
- File `src/api/user-export.js` exists.
- `export function toUserCsv(` matches exactly once (declaration, not comment).
- `'id,name,email,team,created'` present exactly once.

**Status:** `[x]` done

---

### Step 01.2 - Serve the export behind the list's admin check
**Files:** `src/api/routes.js`
**Depends on:** Step 01.1

**Prompt for implementer:**
> In `src/api/routes.js`, register `GET /admin/users/export` beside the existing `GET /admin/users`,
> behind the same `requireAdmin` guard and reading the same filter parameters. Collect every page
> with the existing `listUsers(filters, page)` until it returns an empty page, then respond with
> `toUserCsv(users)` as `text/csv; charset=utf-8`, an attachment named `users-` plus today's date
> as `YYYY-MM-DD` plus `.csv`.

**Verification:**
- `'/admin/users/export'` matches exactly once in `src/api/routes.js`.
- That registration line names `requireAdmin`.
- `import { toUserCsv } from './user-export.js'` present exactly once.

**Status:** `[x]` done

---

### Step 01.3 - Cover the export with tests
**Files:** `src/api/user-export.test.js`
**Depends on:** Step 01.2

**Prompt for implementer:**
> Create `src/api/user-export.test.js` with three cases against `/admin/users/export`: a non-admin
> request is refused and returns no file; a filtered list spanning two pages exports every listed
> user once, in list order; a user named `=SUM(A1)` is exported as `'=SUM(A1)`.

**Verification:**
- File `src/api/user-export.test.js` exists.
- `test(` declarations: exactly three.
- `'/admin/users/export'` present in the file.

**Status:** `[x]` done

## Phase done criteria
- [x] Every `Step 01.*` is `[x] done`.
- [x] Narrowest meaningful check for this phase passes: `npm test`, the three new cases included.
- [x] Grep for `TODO(phase-01)` returns zero hits.
- [x] The ticket's one changelog entry lists every file in "Files touched".

## Handoff notes
- `GET /admin/users/export` returns the whole filtered list as CSV, to admins only.
- The column order is defined in `toUserCsv` and nowhere else.
- Phase 02 consumes the route and nothing else from this phase.

## Rollback plan
Revert phase commit(s). The route is additive; no stored data changed.

## Step Log
- 2026-04-14 Step 01.1 - expected: 3 predicates PASS | actual: 3 PASS.
- 2026-04-14 Step 01.2 - expected: 3 predicates PASS | actual: 3 PASS.
- 2026-04-14 Step 01.3 - expected: 3 predicates PASS | actual: 3 PASS.
- 2026-04-14 Phase check `npm test` - expected: exit 0 | actual: exit 0.
