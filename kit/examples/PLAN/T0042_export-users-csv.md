# Strategic spec: T0042 - Export the user list as CSV

**Ticket:** T0042
**Status:** BlockNeedUserTest - one manual check open: the file in the support team's spreadsheet app.
**Priority:** 50
**Date:** 2026-04-13
**Tier:** Easy
**Blocked-by:** none
**Carried-to:** none
**Tactical plan:** [`PLAN/T0042_export-users-csv/`](T0042_export-users-csv/INDEX.md)

> **Scope:** STRATEGIC. Goals, constraints, open questions. No class names, paths, line
> budgets, schema versions, or framework module details.

---

## 1. Problem
Support staff who need the user list outside the admin console copy it by hand, one screen page at
a time, into a spreadsheet. It is slow, rows get lost between pages, and the copy holds what the
screen showed rather than what is stored. Affected area: the user list in the admin console.

## 2. Goals
1. An admin gets the whole user list, as currently filtered and across every page, as one CSV file.
2. The file opens in a common spreadsheet app with names in any alphabet shown correctly.
3. Only an admin can produce the file.

**Non-goals:**
- Scheduled or emailed exports.
- Any format other than CSV.
- Deactivated users - the list hides them today, and the export follows the list.

## 3. Wishes and constraints
### 3.1 Owner wishes
Let the admin choose which columns to export - a later iteration.

### 3.2 Hard constraints
- **Platform / versions:** none
- **Performance:** n/a
- **Data compatibility:** none - the export reads and stores nothing.
- **Localization:** n/a - the admin console ships in English only.
- **Accessibility:** the export control is reachable and operable by keyboard alone, and has a name
  a screen reader announces.
- **Shared boundary:** none - people read the file; no other project does.

### 3.3 Owner inputs (Approval gate)
- **Related tickets:** none
- **Copy/tone policy:** the control reads "Export CSV", like the console's other verb-first buttons.
- **Validation level:** automated tests for the file's content and the access rule; one human pass
  in the spreadsheet app the support team uses.
- **Owner sign-off:** the support lead, on the manual checks.

## 4. Current architecture context
The admin console draws the user list one page at a time, asking the service for one page per
request. Nothing can ask for the whole filtered list at once, and nothing turns the list into a
file. Access to the list is already limited to admins at the service boundary, so a new way in must
reuse that limit rather than add its own.

## 5. Proposed approach
The service gains a read-only export that returns the filtered list as CSV in one response, behind
the list's own admin check. The user list gains one control that requests the export and saves the
result as a file.

### 5.1 Pillars / modules
1. **Export** - the whole filtered list as one CSV. Same filters and admin check as the list; a
   column order defined once; UTF-8 with a byte-order mark; a cell that would start a formula is
   written as text.
2. **Export control** - one action on the user list. Keyboard-operable and named; the saved file's
   name carries the export date.

### 5.2 Data & event flows
User list (current filters) -> export request -> admin check -> filtered list, every page -> CSV ->
file saved by the browser.

### 5.3 Extension points
The column list lives in one place, so the column chooser of 3.1 changes data, not structure.

## 6. Open questions / research items
1. **Separator and encoding**
   - **Question:** which separator and encoding make the file open correctly in the spreadsheet
     app the support team uses, accented names included?
   - **Options:** comma and UTF-8; comma and UTF-8 with a byte-order mark; semicolon.
   - **To find out:** open one sample file per option in that app.
   - **Status:** Resolved - comma, UTF-8 with a byte-order mark; without the mark the app misread
     accented names.
   - **Artifact:** none - a sample-file trial by the owner on 2026-04-13, recorded here.

## 7. Risks
| Risk | Likelihood | Impact | Mitigation |
|------|:----------:|--------|-----------|
| A cell starting with `=`, `+`, `-` or `@` runs as a formula when opened | Med | a crafted user name executes in the support team's spreadsheet | write such cells as text; a test feeds one in |
| The export skips the list's admin check | Low | anyone can download every user | reuse the list's check; a test proves a non-admin is refused |

## 8. User impact (docs)
Admins can download the user list, as filtered, as a CSV file with "Export CSV".

## 9. Architecture decisions (ADR)
**ADR-1: Build the file in the service, not in the page** - Decision: the service returns the
finished CSV. Alternatives: the page fetches every list page and assembles the file itself. Why: one
request and one admin check, and the column order and escaping live where the tests reach them.

## 10. Links to other specs
None.

## 11. Done criteria (strategic)
1. On the user list, an admin activates "Export CSV" and receives one file holding every user the
   current filter shows, across all pages.
2. The file's name carries the date of the export.
3. A request without admin rights is refused and yields no file.
4. A user name starting with `=`, `+`, `-` or `@` reads as text in the opened file.
5. The file opens in the spreadsheet app the support team uses, accented names shown correctly.
6. The control is reached and activated with the keyboard alone.

## 12. Next step
Tactical plan: [`T0042_export-users-csv/INDEX.md`](T0042_export-users-csv/INDEX.md) - executed by
`/spec-dev T0042`.

## Manual checks

- [x] Export with the keyboard alone, filter "team: Support" applied, the list longer than one page - 2026-04-15, one file `users-2026-04-15.csv`; every user the filtered list showed, once each.
- [ ] Open that file in the spreadsheet app the support team uses: accented names read correctly, and the test user `=SUM(A1)` shows as text.

## Last Audit

**Date:** 2026-04-15
**Mode:** full
**Outcome:** BlockNeedUserTest
**Counts:** PASS 29 · WARN 0 · FAIL 0 · UNCHECKABLE 0 · MANUAL open 1 · EXEMPT 5
