# Authoring Rules, Skills & Agents - write the directive against a real failure

The kit gives you a rulebook (`CLAUDE.md`), skills (slash commands), and agents. The moment you
extend them - a new rule, a new command, a new gate - you are writing a directive that must change
an agent's behaviour, not just read well to you. Most hand-written rules fail at exactly that: they
describe what a careful agent already does, so they add tokens and change nothing.

This document is the discipline for writing a directive that actually lands. It is the counterpart
to `CODE_QUALITY.md` (how to write clean *code*) and `VALIDATION.md` (how to prove a change is
done): here, the artifact you are shipping *is* the instruction.

## Core principle: no rule without an observed failure first

Do not write a rule from imagination. Write it only after an agent has demonstrably done the wrong
thing without it. A rule authored to "look complete" teaches nothing the model was not already
doing; a rule authored against a real, watched failure closes a real gap. This is test-driven
development applied to instructions: see it fail red, then write the minimal rule that makes it
green.

The loop:

1. **OBSERVE** - capture the failure verbatim: the wrong action, and the *rationalization* the
   agent used to justify it ("the build looked fine", "the diff was trivial", "tests probably
   pass"). The rationalization is the load-bearing evidence - it is the exact loophole the rule
   must close. A rule that does not name the excuse will be talked around by the next excuse.
2. **WRITE minimal** - the shortest directive that would have prevented *that specific* failure.
   Do not pre-emptively generalise to failures you have not seen; add those cases only when they,
   too, are observed. Breadth you invented is breadth nobody tested.
3. **CLOSE loopholes** - list the excuses that would let an agent wriggle out, and counter each
   one explicitly. "Violating the letter violates the spirit" belongs in the rule when the letter
   is tempting to game.
4. **PROMOTE if it recurs** - if the failure is mechanically detectable and keeps happening,
   convert the prose rule into an automated gate (see `CODE_QUALITY.md` -> "Close the source, not
   just the detector", and the ratchet-baseline mechanism for adopting it on legacy code). Prose
   is advisory and the agent re-emits the pattern every generation; a gate stops it cold.

## Rationalization table

For any *discipline* rule - one the agent is tempted to skip under time pressure, sunk cost, or an
authoritative-sounding instruction - record the real excuses and their counters. Shape:

```
Excuse (actually used)                    -> Counter
"One line, no need to run the check."      -> One-line changes to gated paths still run the fast
                                              check; it costs seconds (see VALIDATION.md).
"The subagent reported the build passed."  -> A self-report is not evidence. Re-run the command and
                                              read the exit code yourself.
"Close enough on the spec."                -> "Close enough" is a fail. Return it to the spec.
```

Keep excuses that were *actually produced* in a real run, not plausible-sounding ones you invented
- invented excuses bloat the rule and bury the counters that matter.

## Description-SDO: make the trigger, not the summary

A skill / command / agent has a one-line `description` (in frontmatter, a rules table, or a menu).
That line is the surface an agent reads to decide *whether to reach for this thing at all*. Write
it as a trigger, never as a summary of the procedure inside.

Checklist for every `description`:

- Lead with **when to reach for it** - the user intents, symptoms, error messages, or file/area
  contexts that should pull this skill in. Start with "Use when.." or "Use to..".
- Do **not** pretell the process ("first does X, then Y"). An agent that can read the whole
  procedure from the description will follow *that* summary and skip the fuller body - so the steps
  documented later never run.
- Keep it short - roughly under 500 characters. A description is an index entry, not the article.
- Prefer concrete triggers ("fix a typo / one string / a colour", "a pasted stack trace") over a
  bare restatement of the title ("Quick Fix", "Log Reader") - the title is already visible; the
  description earns its place by adding the triggers the title omits.

An empty or title-only description is the common default and a real defect: the routing rulebook
then has to carry every trigger by itself, and any agent that reaches the skill list without that
rulebook in focus cannot self-route. Fill the trigger line even when a central routing section also
exists - keep it to stable trigger phrases so the two do not drift.

## Where each kind of directive lives

- **Always-loaded rule** (behavioural, applies everywhere): the rulebook - `CLAUDE.md` (and its
  `AGENTS.md` pointer). Keep exactly one canonical copy; a duplicated rulebook drifts.
- **Automated gate** (mechanical, greppable, recurring): a check wired into your "done" command /
  pre-commit hook / CI, ratcheted on new violations only.
- **Skill** (a named procedure you invoke): a slash command / saved prompt, with an SDO
  description.
- **Agent** (a role brief / mode): a subagent definition or system-prompt preamble, with an SDO
  description that says when to pick it *over its neighbours*.

Substance lives in the canonical rule or the skill body; everywhere else points to it. Do not
paste the same paragraph into three files - state it once, reference it twice.

## When NOT to add a rule

- The failure was a genuine one-off with no recurrence risk - fix it inline and move on.
- A rule or gate already covers it - sharpen the existing one instead of adding a second source of
  truth that will drift from the first.
- It is mechanically checkable and would be ignored as prose - write the gate directly, skip the
  rule.
- You have not actually seen it fail - go get the failure first. A rule with no red behind it is a
  guess wearing a uniform.

## Why this is a document, not a vibe

"Write better rules" is a vibe. *Observe the failure, write the minimal counter, name the excuse,
promote it when it recurs* is a repeatable procedure a reviewer can demand you followed: show the
red, show the rule, show the loophole you closed. It keeps the rulebook small - every line traces
to a failure it prevents - instead of accreting well-meaning advice nobody tested and nobody obeys.

## Adapting it

- Map "gate" to your stack's real enforcement point: a linter rule, a pre-commit hook, a CI job,
  the fail-closed "done" command from `VALIDATION.md`.
- If your tool has no frontmatter descriptions (it is not Claude Code), the SDO rule still applies
  to whatever one-liner indexes your saved prompts / modes - a Cursor command title, a Codex
  preamble's first line.
- Start applying this the first time you write your *own* rule or command on top of the kit - not
  before. The kit's own rules were written this way; yours should be too.
