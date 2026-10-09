---
name: surfaces
description: "Use when a user-visible change is about to be called done - list every place a user meets it, print the surface table before editing, and make every touched surface say the same thing under the same name, in every authored locale. Triggers: 'surfaces', 'did I forget anything', 'update the docs', 'the README is out of date', a new or renamed user-visible capability, the docs-cleanup phase of a plan."
argument-hint: "[ticket-id | one-line description of the change]"
---

# Ship-Together Surfaces

> **GLOBAL DIRECTIVES (anti-bureaucracy):**
> 1. Dry, plain prose, no filler.
> 2. Table first, edits second. Never edit a surface the table does not list.
> 3. Terse report: the final table and one line.

A change is not done when it works. It is done when every place a user meets it says the same
thing, under the same name, in every authored locale - in the same change. This is the rules
file's post-change rule ("New user-visible capability → every surface and every **authored**
locale in the same change") as a procedure; why it holds is in `docs/VALIDATION.md`.

## Usage

```text
/surfaces                          # the current diff
/surfaces <ticket-id>              # the ticket's change (read-only on the ticket)
/surfaces <one-line description>
```

## Process

**1 - Classify.** Can a user see, do, or be surprised by this change? No - an internal
refactor, a test, a build tweak → report `surfaces: not user-visible - <reason>` and stop.

**2 - List the surfaces, then print the table - before editing anything.** Every place a user
meets the capability, found in the project, never assumed: UI strings (one row per authored
locale), help and tooltips, the README and its translations, user docs, the site, the change
log, store or package listings, screenshots, examples and samples, templates. Start from the
project's surface manifest if it keeps one and extend it - never write a second one.

| Surface | Touched / not applicable | Reason |
| --- | --- | --- |

**3 - No silent "not applicable".** Each such row names its reason ("the site lists no
features", "no screenshot shows this menu"). A row without one fails the check - that is how
a forgotten surface hides.

**4 - Write the one sentence.** The change as a user would want it told, task first, in
`<ARTIFACT_LANGUAGE>`: "Invoices can be exported as PDF", not "added a PDF renderer". Its key
noun - the name of the thing - is the one name every surface uses; each authored locale renders
it with its own fixed term.

**5 - Edit.** Every "touched" row in this change, each authored locale in the same edit. A
generated surface changes in its source and is regenerated, never edited by hand.

**6 - Grep the key noun** - and any old name it replaces - across every touched surface, in
each locale's term, and read the hits. Each surface says the same thing under the same name;
every stale mention (an old name, a removed option, a screenshot of the old screen) is fixed
or listed in the report.

**7 - Report.** Re-print the table with the final state, then one line:

```text
surfaces: <sentence>. Touched N, not applicable N, stale mentions fixed N, listed N. Noun: "<noun>".
```

## Constraints

- One name per concept: a second name for the same thing is a defect, not a style choice.
- Locales nobody on the team authors by hand may fan out later where the project has a
  release boundary (`docs/VALIDATION.md`); name each one still missing in the report.
- Never publish, deploy, or submit a listing from here - edit the sources only. The
  irreversible step is the user's.
- Fix drift only in the lines you touch; report older drift as a finding, or `/park` it.
