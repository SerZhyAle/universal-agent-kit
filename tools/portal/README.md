# Portal sources

The portal of the site - `portal/**`, plus `privacy.html`, `404.html`, `assets/search-index.json` and
`sitemap.xml` - is a **render target** of this directory and of `POSITIONING.md`. Never edit a generated page;
change the source here and run

```powershell
pwsh -NoProfile -File tools/build-portal.ps1            # validate, render, write what changed
pwsh -NoProfile -File tools/build-portal.ps1 -Validate  # validate the sources only
pwsh -NoProfile -File tools/build-portal.ps1 -Check     # render in memory, fail on drift from disk
```

## When `kit/` changes

A page is written against the exact text of its kit sources. `reviewed.json` holds one digest per capability;
when a source file changes, `-Validate` fails for that capability with the list of changed files. Re-read the
sources, fix the page (all three languages), and record it with

```powershell
pwsh -NoProfile -File tools/build-portal.ps1 -Accept <capability id>[,<id>..]   # or: -Accept all
```

`-Accept` runs only after the sources validate and never edits a page. A payload file added to `kit/` must be
a source of a capability or be listed in `excluded` in `inventory.json` with a reason; a skill added under
`kit/.claude/skills/` also needs its capability and its page.

## Layout

| Path | What it is |
| --- | --- |
| `inventory.json` | the capability inventory: every user-visible capability of the kit, once, with the facts the pages render and never retype (kind, section, name, sources in `kit/`, permissions, runtime). Its ground truth is the file tree of `kit/` plus `merge-prompt.txt`: a payload file that is neither a source of a capability nor listed in `excluded` fails the build. |
| `sections.json` | the sections of the portal, in the order of the pillars of `POSITIONING.md` |
| `ui.json` | the strings of the chrome and of the pages that are not functions, guides or terms |
| `functions/<id>.json` | the content of the one page of capability `<id>` |
| `guides/<id>.json` | a guide by task |
| `glossary/<id>.json` | a glossary term, one file each |
| `privacy.json` | the copy of `privacy.html` |

## Rules for every text

- **Three languages, always**: `en`, `ru`, `ua` (the Ukrainian key is `ua`; the page language code is `uk`).
  Write each language as a native writer would, not as a word-for-word translation. Technical identifiers
  (`/spec-check`, `CLAUDE.md`, `Verified`) stay as they are in every language.
- **House text style**: `..` (two dots) and never three, a plain hyphen `-` and never an em or en dash, no
  ellipsis character, no emoji or check marks, the Russian letter `ё` where it belongs (`всё`, `идёт`). The
  validator refuses violations. Three dots are allowed only inside a code span.
- **Voice**: dry, concrete, a little wit at most once per page. No superlatives, no urgency, no marketing.
  Every sentence carries information. State the honest limit next to the thing it limits.
- **Truth**: every statement is checked against the kit file named in the capability's `sources`. Never
  invent a flag, a status, a step or a behaviour. Quote the interface's own words exactly: command names
  (`/spec-check`), status names (`Verified`, `Partial`, `Broken`), file and directory names.
- **No data claims** beyond: kit files are plain Markdown on the reader's disk. Do not say what any vendor
  does with data.
- **Markup in a text field** (everything else is plain text; HTML is refused):
  `` `code` ``, `**bold**`, `[text](fn:<capability id>)`, `[text](guide:<guide id>)`,
  `[text](term:<term id>)`, `[text](https://..)`. A `` `/command` `` that is not in the inventory is refused.

## A function page (`functions/<id>.json`)

The fixed anatomy of `SITE-REPRESENTATION` rule 7 - the generator draws these in this order; an element that
has no content is **omitted, never empty**:

| Field | Required | Meaning |
| --- | --- | --- |
| `id` | yes | equals the file name and the inventory id |
| `title` | yes | the task as a title: a verb and a result ("Make a one-line edit without ceremony"), at most 90 characters |
| `pitch` | yes | one sentence for listings, cards and search results, at most 170 characters |
| `lead` | yes | two or three sentences: what the reader will do and what they get, at most 600 characters |
| `situation` | no | when to reach for it |
| `warning` | no | something that can go wrong or cannot be undone; drawn **before** the steps |
| `steps` | yes | 2 to 8 localized instructions, each at most 500 characters. The steps happen in the agent's chat or in files, which is another vendor's interface or plain text: there are no figures |
| `outcome` | yes | what the reader should now see |
| `tips` | no | pitfalls and faster ways, each at most 400 characters |
| `related` | yes | 1 to 5 capability ids; at least one |
| `terms` | no | glossary term ids used on the page |
| `keywords` | yes | `{ "en": [..], "ru": [..], "ua": [..] }`, 2 to 8 each, the subject index and the search read them |

The page also shows, **generated from the inventory and never written by hand**: the section and the kind, the
availability, what the capability touches (permissions), the runtime, where it lives in the kit. Do not write
them in the prose of a page, and do not write a default value of a setting.

Exemplar: `functions/quick.json`. Read it first.

## A guide (`guides/<id>.json`)

A walk through a whole job that spans several functions. Fields: `id`, `title`, `pitch`, `lead`, `steps`
(3 to 9; each step names the function it uses with an `fn:` link), `outcome`, `functions` (2 to 8 capability
ids the guide uses), `terms`, `keywords`. Same rules and limits as a function page.

## A glossary term (`glossary/<id>.json`)

```json
{ "id": "park", "term": { "en": "..", "ru": "..", "ua": ".." }, "def": { "en": "..", "ru": "..", "ua": ".." }, "see": ["scratch"] }
```

`def` is one to three plain sentences, at most 420 characters, and may use the inline markup above. `see` is
optional. A term is created by the batch that owns it (see the assignment you were given); any batch may link
to any term id.
