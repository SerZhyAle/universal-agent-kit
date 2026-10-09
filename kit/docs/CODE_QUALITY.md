# Code Quality - anti-slop conventions

A short, enforceable list of the patterns an AI assistant (or a tired human) tends to emit
that look fine and quietly rot a codebase. The rule is not "review for these later" - it is
**do not write them in the first place**, and **flag them on sight** in review.

Adapt the concrete syntax to your language; the intent is universal.

**This is the code layer of the kit.** If your artifacts are documents, datasets, contracts or
procedures, the seven below have direct analogues and `PROJECT_SHAPES.md` lists the generic ones -
but write your own list from what you actually caught in review, the way this one was written. The
two sections that follow the list ("Adopting a rule on a codebase that already violates it" and
"Close the source, not just the detector") apply to any artifact and are worth reading whatever your
project is made of.

## The seven slop patterns

1. **Trivial comments.** A comment that restates the adjacent line adds noise and goes stale.
   ```
   // increment i
   i++
   ```
   Comment *why*, not *what* - and only when the code cannot express it (a non-obvious
   business rule, a handled edge case, a workaround, an invariant). If the line is obvious,
   delete the comment.

2. **Empty or broad swallowing catches.** A catch that hides the error is a bug with a delay.
   ```
   try { risky() } catch (e) { /* ignore */ }
   ```
   Every catch must do one of: recover, return a documented safe default, or log a
   plain-language degradation at the right level. Catch the narrowest type you can. If you
   truly intend to ignore, say *why* in one comment - the reason, not the fact.

3. **Hardcoded values where a token exists.** A literal color, dimension, URL, or magic
   number inlined where the project has a theme attribute / constant / config entry. It
   breaks theming, environments, and reuse. Reference the token; if none exists and the value
   recurs, create one.

4. **Lifecycle-unsafe async / global mutable scope.** Launching work that outlives or
   races its owner - a coroutine/promise tied to nothing, a subscription never cancelled, a
   module-level mutable singleton where a scoped instance belongs. Use the project's scoped
   concurrency and lifecycle-aware collection. Never reach for a global scope because it is
   shorter.

5. **Non-facade logging.** `print`, `console.log`, `System.out`, `println` in shipped code.
   Route through the project's logging facade (`<LOGGER>`) so level, format, and sink are
   controlled. Diagnostics you would be embarrassed to ship do not get committed.

6. **Shipped stubs.** `TODO()`, `throw NotImplementedError`, `fatalError("unimplemented")`,
   `raise NotImplementedError` on a path that actually runs. A stub on a live path is a crash
   waiting for a user. Either implement it or gate it so it cannot be reached, and track the
   gap in a ticket.

7. **Dead weight left behind.** A change that supersedes code/resources/config but leaves the
   old version, an orphaned key, or a build keep-rule naming a deleted symbol. Delete the
   remnant in the *same* change. Before deleting a zero-reference artifact, check it is not
   active scaffolding for an in-flight ticket. Verify "removed from the build" on the real
   target/release artifact, not a debug build.

## Structural rules

- **Dependency direction.** Respect `<ARCH_LAYERS>`. An outer layer may depend on an inner
  one, never the reverse. No cross-layer shortcuts "just this once".
- **Thin entry points.** Controllers / activities / route handlers wire and delegate; they do
  not hold business logic. Logic lives in named helper/service classes.
- **File-size budget.** Past ~`<SIZE_BUDGET>` lines, extract a cohesive helper. Size is a proxy
  for "this file does too many things".
- **Naming.** Match the codebase's existing convention exactly. Consistency beats your
  personal preference.
- **Scope of a change.** Fix the thing asked. No opportunistic refactor, no unrelated import
  cleanup, no drive-by reformatting - those drown the real diff and break `git blame`.
- **An override that narrows a shared default disables the mechanism, silently.** Where this
  project's config merges over a shared layer's defaults, widening a list adds cases the mechanism
  then handles, while narrowing one removes cases it was counting on - and nothing goes red, because
  a shorter list is a valid list. Measured 2026-09-20: a profile declared two of the six outcomes its
  shared library counts as "this run made no progress", and **52 of 54** stalled runs carried one of
  the four it had left out, so the idle counter never advanced and the queue re-issued one ticket
  **five times in a row**. Any narrowing override carries a recorded reason, or it is a defect
  waiting for a quiet week.

## Comment discipline (the one worth repeating)

A good comment explains a decision the code cannot: *why this order*, *why this guard*, *why
not the obvious approach*. A bad comment narrates the code, repeats the function name, or
describes what a reader can see. When you edit a region, read its existing comments first and
treat them as intent - do not silently invalidate them. Remove comments that have gone stale.

## Why this is a document, not a vibe

Each pattern above is greppable. A reviewer - human or agent - can scan a diff for empty
catches, inline hex, raw `print`, `TODO()`, and orphaned keys mechanically. Make the check
part of "done", not part of "someday". If your stack has a linter, encode as many of these as
rules so the gate is automatic and the assistant gets fast feedback.

## Adopting a rule on a codebase that already violates it

A zero-tolerance gate on legacy code either never merges or forces a risky mass cleanup. Gate
on NEW violations instead. Freeze the current violation count as a checked-in baseline; the
gate fails only when the count rises above it. The rule takes effect immediately - no blocking
cleanup - and the tooling may lower the baseline as you clean up but must refuse to raise it,
so debt ratchets downward only, never back up. This is the adoption mechanism for every rule
above: it is how you enforce a new invariant on legacy code without a big-bang cleanup.

**The ratchet can resurface accepted debt.** A baseline keyed by identity - file + line, or a
rule-plus-location hash - re-flags debt you already accepted when adjacent code shifts it: a
rename, a signature change, or a reformat moves the anchor, and the linter reports the same old
finding as new. Prefer a content- or count-based baseline where the tool allows it; and when a
resurfaced item is the same accepted debt, re-accept it rather than "fixing" churn just to satisfy
the gate. This trap is identical across detekt, ESLint, Ruff, and PHPStan.

## A point fix on a shared contract is half a fix

There are two kinds of defect and only one of them is local. "This code is wrong" is local. **"This
code did not pay what the platform, the API, the wire format or the template demands" is not** - the
same debt is almost certainly unpaid elsewhere, written by the same hand, on the same day, against
the same contract.

So when the finding is of the second kind, **sweep every site of that contract in the same
ticket**. The sweep is cheap, because the contract names its own call sites: grep the interface, the
annotation, the base class, the schema key. The alternative is discovering them one production
crash at a time.

Measured on one project (2026-09-20): the identical service-lifecycle contract had already been paid
**twice** in one subsystem, each time as a point fix. A third service in the same repo was never
looked at. It crashed in the field, was reported by remote diagnostics **three hours after the
release shipped**, and cost a same-day fix-release. The two earlier fixes were, between them, the
map of every place to look - and nobody read the map, because each of them had closed green.

The tell that you are in this case: your fix adds a call, an override or a field that the framework
*always* wanted. Ask immediately who else should have been calling it.

## What another project reads has one home, and it changes first

The section above is about a contract inside one project. There is a second kind: something a
**different** project reads, writes or reproduces - a file format, a wire payload, an export's
columns, an algorithm's pinned constants, what an import must never overwrite. Not only code has
these: a dataset another team loads and a template another office fills are the same thing.

- **One home, pointers everywhere else.** The contract lives in exactly one place outside both
  projects. Each project keeps a short pointer - the contract's id, its version, where it lives,
  whether this project produces or consumes it - never a copy. A copy is a fork, and describing the
  format "in our own words" is a copy too. Two copies agree only until the first edit.
- **Name the home after the function, not the first project that built it.** A folder named after a
  product quietly hands that product the shared decision, and cannot answer "how must this behave
  everywhere".
- **The contract changes before the code.** A change at the boundary starts with the contract: a
  version bump and a dated line saying what changed. Code ahead of its contract is a defect whatever
  the tests say. Never reshape silently, and keep a reader for every version that ever wrote a
  user's data.
- **Breaking is judged by the oldest reader still in use, never by diff size.** Write down what the
  oldest consumer still in use - another project, or an older install of this one - does when it
  meets what the new writer emits. If the answer contains "wrong", "silently" or "partially", it is a
  breaking change: a new major version, announced to the consumers before it ships.
- **A reader tolerates what it does not know.** Match fields by name, never by position; ignore an
  unknown field instead of failing; accept a newer minor version and skip its additions; refuse a
  newer major version cleanly, with one message naming the contract - never a partial import, never a
  guess. A reader that fails on an unknown field turns every harmless addition into a breaking change.
- **Comply or amend.** A project that finds the contract wrong either amends it at the home or
  records a dated exception with an expiry date. There is no third option, and an exception past
  its date is a violation, not a formality. Finding the defect is what creates the obligation:
  whoever finds it owes the amendment - a dated proposal to the owner, when the contract is another
  project's - and a local workaround is the third option in disguise.
- **Conformance runs against the home's copy.** Test vectors copied into the repo and edited locally
  prove only that the local copy agrees with itself.
- **Unreachable home, unknown verdict.** If the check cannot reach the home from this machine, its
  answer is *could not verify*, never PASS (`VALIDATION.md`, the four answers).

This replaced, on 2026-09-22, the practice of keeping per-repo contract copies as "frozen" files -
which is exactly what a copy stops being after the first local edit.

## Close the source, not just the detector

A gate that catches a recurring defect is only half the loop: a detector stops a human once,
but an agent re-emits the pattern every generation. When a check keeps flagging the same thing,
add the matching DON'T to the always-loaded rules file (`AGENTS.md`) and reinforce it in the
code-generating skills - substance in the canonical rule, skills as short pointers - so the
agent stops producing the defect, not merely flagging it after the fact.

## Reference docs are a build artifact

User-facing reference docs are part of the change that alters behaviour, not a follow-up: the
same change updates the doc, and a check fails when behaviour and its documented description
drift apart. If your stack can generate the doc from the source of truth, gate on the
regenerated output; otherwise gate that the doc was touched whenever the matching behaviour
was. Keep mirrored docs in lockstep, and separate an always-append developer inventory of what
shipped from any curated outward-facing summary (regenerate the latter only at release).
