# Window help - F1, a `?` button and an explanation for every window

Read this when the change adds or alters a **window or screen** of an application: a main window, a
settings window and each of its pages, a dialog, a wizard step, a viewer or editor, a window kept open
beside the user's work, a phone screen or bottom sheet. (`/surfaces` uses the word "surface" for any place
a user meets a capability; here the word is always "window or screen".)

Not covered: a web page that documents a product, a command line's `--help`, the tooltip of one control,
a first-run tour, a watch face. What the help says is the project's own; this file fixes the shape.

## Excuses seen in real runs, and the counter

Four runs built the same small windowed tool for a non-programmer. None added help; each said why.

| Excuse (actually used) | Counter |
| --- | --- |
| "Help was not in the request." | A request that lists a window's controls is not a request to leave help out. Help is part of the window, as its labels are - the person asking cannot ask for what they do not know exists. |
| "I did not think of it." | Decide it where the window is decided: one row per window in the decision table, before any code. |
| "It is a small window, and you use it yourself." | The cost is one map row and one page. A window that needs no help is `none` or `inherit` with a written reason - never silently nothing. |
| "The rules said to run `/ui-clarify`; I did not." | A new window or screen always goes through it. Running it is the step, not the exception. |

## The ask

1. **F1 asks.** F1 pressed while one of the application's own windows has the focus opens the help of that
   window. It means nothing else, is never registered system-wide, and is never taken from another program
   (an application that captures global shortcuts leaves bare F1 alone). In a browser application the handler
   runs only while the application has the focus, so the browser's own help is not shadowed elsewhere. A
   phone reaches help through the button; a hardware keyboard may use F1 too.
2. **A `?` button asks as well.** Every window that has help carries one, in the **top-right corner**,
   **added** beside what is there - it never replaces, covers or re-purposes a control that already is. Where
   the corner is taken (a close box, a search field, a trailing toolbar action) the button stands
   immediately before that group, on the reading-start side, so every existing control keeps its place.
   In a right-to-left language the corner mirrors with the layout. Its name and tooltip are "Help (F1)" in
   the user's language ("Help" where the platform has no key). On a phone it is an action of the top app
   bar, before the overflow menu; in a dialog it is the trailing end of the title row; an application that
   lives in the tray has a "Help" menu item, and every window it opens carries the button.
3. **Key and button give the same answer.** Both resolve to the same help. F1 pressed on a control that has
   its own entry goes to that entry; otherwise to the top of the window's help. A button never opens
   something the key does not.
4. **Every window has help unless the map says why not.** Allowed without one, with the reason written
   down: a message box or confirmation whose text is the whole explanation, an operating-system dialog such
   as a file picker, a splash or progress-only window, a toast, a menu, a tooltip. A dialog opened from a
   window that has help may reuse that window's help (`inherit`): it still answers F1 and carries the
   button, and both open the parent's page at the anchor its row names. Everything else - the main window, every
   settings page, every dialog that asks for a decision, every wizard step, every viewer, every companion
   window - has its own.

## The answer: two forms, chosen per window

The project chooses per window and records it in the map; it need not use one form everywhere or build both.

- **Layer.** Numbered markers drawn over the live window, read-only: one marker and a one-line label per
  significant element, the fuller text on hover, focus or tap. Showing it activates nothing and touches no
  network. Esc, F1 again, the button again and a click outside all close it and return the focus. Tab walks
  the markers, a screen reader reads each label, and it works in every state - a disabled control keeps its
  marker and says why it is disabled.
- **Page.** One HTML page per window, in this order:
  1. **Title** - the window's name exactly as the interface shows it.
  2. **What it is for** - one to three sentences, in the user's words: the job, not the architecture.
  3. **Screenshot** with numbered markers. Its alt text names the window, and everything the image shows is
     also in the text, so the page works with the image missing.
  4. **In this order** - the usual path as at most seven numbered steps naming the markers, each saying what
     to do and why it comes at that point. A window with no order (a settings page) says so and groups its
     elements instead.
  5. **The elements** - one entry per significant element, in marker order: its name and one line, and behind
     a disclosure what it does, **why and when to use it**, what happens next, whether it can be undone, and
     its shortcut.
  6. **Related** - the help of the windows this one opens and is opened from, one link to the deeper
     documentation, and the help index. A page never dead-ends.
  7. **Footer** - the version the page was captured against, the capture date, the link to the index and the
     one support path.
- A window may offer both: the layer first, ending in a "Full help" link into the page.
- Opening help closes nothing: help opened from a modal dialog leaves the dialog open and answerable.
- **Voice.** The project's one voice: what the element does and why the user would want it, never a restated
  label ("The Save button saves"). No "click here", no superlatives, no jokes where data can be lost.

## Delivery

- Pages ship inside the application and open with no network. A page makes no request: no remote font,
  script or image, no analytics.
- A page exists in every language the interface ships, is chosen by the **application's** language, and falls
  back to the source language, never to a missing page. Names and labels come from the same string source as
  the interface, so a renamed button is renamed in its help by the same edit.
- Screenshots are generated by a script from the real build, per language, with demo content - never the
  author's or a user's data, an account name, a real path or a key. Marker positions come from the window's
  own element bounds, not from a person's pointer. A screenshot is regenerated, never edited by hand. A
  project with no capture tooling yet says so in the map and keeps the page text complete without the image.
- A help id never changes once a build has shipped with it; a moved page leaves a forwarder.

## One resolver, one map

- **One resolver.** One function takes a window id (and optionally an element) and returns the target. Every F1
  handler and every `?` button calls it; no window carries help code of its own.
- **One map.** A file in the repository, named in the rules file and shipped with the application, with one row
  per window. A machine-readable file is best - the check below reads it. The columns:

  | id | name as the interface shows it | form | help id (and anchor) | parent | reason |
  | --- | --- | --- | --- | --- | --- |
  | `main` | Notes | page | `notes` | | |
  | `settings` | Settings | both | `settings` | | |
  | `confirm-delete` | Delete note | none | | | The confirmation text is the whole explanation. |
  | `add-note` | New note | inherit | `notes#add` | `main` | A one-field dialog the main page explains in step 2. |

  The form is `layer`, `page`, `both`, `inherit` or `none`. A window that takes no added control at all (a
  full-screen light that closes on any touch) is `inherit`, says so in the reason, and wires neither key nor
  button; its parent's page explains it before it opens.

## The gate

Prose is followed rarely; a check is followed. The project's own `<CHECK_CMD>` (or a check beside it, within
the same 5 seconds) counts windows instead of reading them:

- list the windows from the source of truth - the window classes, the layouts, the route table;
- diff that list against the map;
- fail on a window with no row, a row with no window, a page missing in a shipped language, a link that does
  not resolve, and a `none` or `inherit` row without a reason.

Debt accepted when the check is first adopted lives in a baseline that may only shrink. The step no script
can take is a person pressing F1 and the button once in every window, in every shipped language: a `[ ]` line
in the ticket's manual checks until someone ticks it.

## Per platform (a way, not a rule)

- **Desktop.** The framework's key-down or help-requested event on each window; the button is the trailing
  control of the first content row, so it works under the system title bar and under a custom one. Pages are
  files beside the program, opened in the default browser or an embedded browser pane; fragment anchors work
  in both.
- **Phone or tablet.** A top-bar action; the hardware-key event for F1; pages in the application's assets shown
  in an embedded browser view with scripts off (the disclosures need none), with an "open on the site" link
  and Back returning to the screen.
- **Browser application.** A key handler for F1 that cancels the browser's own help only while the application
  has the focus; the button in the header; pages as static files of the same origin.
- **Tray application.** A "Help" menu item opening the help index.
