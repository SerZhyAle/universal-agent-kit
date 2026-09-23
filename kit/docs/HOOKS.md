# Event Hooks - a verdict on an event, not a place to wire a gate

Everywhere else in this kit, "hook" means a *place*: a pre-commit hook, a CI job, "bundle these
into one routine (a script, a hook, a checklist)". This document is about the other thing - a
program your runtime runs **on an event**, inside a tool call nobody is reading, which returns a
**verdict**. It is the fifth kind of directive in `AUTHORING.md`'s "Where each kind of directive
lives", and it is the only kind whose behaviour a reader cannot discover by reading the repo.

Reach for one only when `AUTHORING.md` says to: the failure is real, observed, recurring, and
mechanically detectable, and prose has already failed to stop it. A hook is the most expensive
directive to get wrong, because a wrong one is invisible.

## First question: does this event see the population you care about?

Before the verdict, before the script, count. **Two questions decide whether a hook can work at
all, and they are separate: is this event where the decision happens, and how many of the
occurrences I care about actually pass through it.** A hook that answers only the first is not
advisory-but-weak. It is inert - and an inert hook reads, in every later audit, exactly like a rule
nobody needed.

This document used to recommend one without asking the second question, so the correction is worth
having in full. The reasoning was sound: a command ladder documented in prose alone was measured at
**0 uses of its cheapest tier over 434 invocations**, and routing is decided the moment the human
types - so nudge at prompt submit, where that decision is made. The event was right about *when*.
Then the hook's own window was measured (2026-09-20):

- **Not one of the owner's 17 free-text prompts** in the window matched its pattern lists - because
  entering the pipeline means typing `/`, and the hook skips slash prompts by design.
- **69% of pipeline entries (64 of 93) were headless processes**, where a prompt-submit event does
  not exist at all.

The population that still types free text was not the population doing the work. Where a queue or a
driver enters the pipeline, the routing decision belongs at **that** entry point - the driver picks
the tier as it picks the item - and the prompt-submit nudge covers only what a human types by hand,
which is worth building only if that population is large enough to matter in your project.

So, before writing any hook: name the event, then count the occurrences it will see over a real
window, and compare that to the total you are trying to influence. If the ratio is small, the hook
is not the mechanism - move the decision to the entry point that carries the volume.

## Which verdict - the decision you make first

A hook has more verdicts than "block" and "allow", and picking between them is a design decision,
not a formality. Seven verbs, so that anyone reading your inventory can tell at a glance what a
hook will do to them:

| Verb | Event shape | What the caller experiences |
| --- | --- | --- |
| refuses | before a tool call | the call does not happen; a non-zero exit and the reason on the error stream |
| rewrites | before a tool call | the call happens with corrected input, plus a notice saying what changed |
| injects | at session start | context arrives that was never requested |
| observes | after a tool call | the result stands; context may be attached to it |
| warns | any advisory event | a message, no verdict |
| nudges | at prompt submit | a suggestion aimed at the next decision, not at this call |
| arms | at session start | nothing visible; a marker is set that a companion gate reads |

## The preference order - correct the input, refuse only when you cannot

**Correct the input where the correct input is knowable; refuse only where no correct input
exists.** This is the load-bearing rule of the whole document, and it is the one most guards get
backwards.

A block cannot fix and retry. It can only cost the caller a round trip and hope they choose better
the second time. Measured on a reference machine: a blocking guard on uncapped file reads fired
**381 times in one week**, and **31.8% of those blocks were answered by re-issuing the same read
with an explicit limit large enough to pull the whole file anyway.** No context saved, a turn
spent. That generalizes to every guard whose objection is *"your parameters are wrong"* rather than
*"this call must not happen"*.

The same instinct applies one level earlier: **prefer making a name work over guarding it.** A
missing interpreter or an unresolvable command is cheaper to put on `PATH` than to guard, because
no hook can fix and retry a failed command - a guard can only refuse it before it starts.

## Contracts, by verdict

**Refusing.** Non-zero exit blocks, zero allows, and the reason goes to the error stream where the
caller reads it. **Fail open on any parse, path or IO error** - a schema change in your runtime
must never make a tool unusable.

**Rewriting.** Two mechanics are easy to get wrong, and both are worth establishing by probing your
runtime rather than guessing:

- The replacement must carry the **complete** input object, not just the field you changed. A
  partial object drops every field it omits.
- Only one channel actually reaches the model, and it is the **context** channel - not the
  permission-decision reason. Put the notice where the model reads it, or do not bother writing it.
  (Field names are your runtime's and they date; the shape is what travels.)

And a rewriting hook must **fail open harder** than a blocking one: when it errs it corrupts what
the model *reads*, rather than merely gating a call. Attach a notice only when something actually
changed - a notice on an untouched call is noise, and noise is what gets a hook turned off.

**Observing.** An after-the-call hook **cannot change the result** the model sees; it can only
attach context. Say this out loud in your own docs, because the natural assumption is the opposite.
The constraint is also what makes the shape safe, and it comes with a design rule: **an observing
hook must be built so that being wrong is structurally impossible**, not merely unlikely. The
shape that achieves it: speak only when you hold a counter-example in hand - re-run the thing you
doubt, and stay silent unless the wider run actually finds something. Nobody audits a hook that is
merely usually right.

**Arming.** A session-start hook that resets a marker a companion gate reads, so a gate can be
"once per session" rather than "always" or "never". Trivial mechanically; worth naming because the
pair breaks silently if one half moves. Always exit zero - a session start is never worth blocking.

**Refusing the end of a turn** is a distinct category, and the only one that guards neither a call
nor a prompt. Everything above answers *"may this call proceed"*; this answers *"may you consider
yourself done"* - the one decision an agent otherwise makes entirely alone. If you build one:

- **Exit zero always**; the verdict travels in the output, not the exit code. A session must never
  fail to end because a hook errored.
- **Silence means allow.** Every allow-path writes nothing at all.
- **Every allow-path is a liveness question** - no marker, a stale marker past a ceiling, a
  background waiter genuinely in flight, or an operator who disarmed it.
- **Escalate on repeated bouncing.** A refusal that repeats identically is a loop: the agent did
  not understand the first one, so change the message to a specific named next action.
- **Give it a sanctioned way to be idle**, or it is a trap. Launching a background waiter and then
  ending the turn is the usual one.

**Every escape hatch is unconditional**, and so is the off switch. A guard with a conditional
bypass gets bypassed by other means.

## Skeletons - the four contracts as programs

**Do not confuse a hook runtime signal with a check verdict.** In the refusal example below, `exit 2`
means "block this tool call" in that runtime. It is not the `COULD NOT VERIFY` outcome a check may report;
the surrounding hook protocol, not this kit's four-answer check vocabulary, gives that exit code its meaning.

Everything above is a decision; below is what the decision looks like once it runs. These are
**illustrative shapes, not drop-in scripts**: the event names, the field names and the shape of the
event object are your runtime's, they change between versions, and the only reliable way to learn
them is to probe your runtime with a hook that prints what it received. POSIX shell and `jq` are
used for brevity - any language with a JSON reader does the same job.

Read them for the control flow, which is the part that travels: where the fail-open sits, what
happens on an unparseable input, and which channel the message goes out on.

**Refusing, with a cheap pre-filter.** The pre-filter is a second program with its own bugs; give it
must-reach and must-skip cases (see below) and run them in the shell that actually evaluates it.

```sh
#!/bin/sh
# PreToolUse guard. Non-zero exit blocks the call; the reason goes to stderr.
input=$(cat) || exit 0                      # fail open: no input, no verdict
case "$input" in *"$TRIGGER_SUBSTRING"*) ;; *) exit 0 ;; esac   # cheap pre-filter
target=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null) || exit 0
[ -n "$target" ] || exit 0                  # fail open: field absent or renamed
if is_forbidden "$target"; then
  echo "Blocked: <what is wrong> - do <the specific allowed alternative> instead." >&2
  exit 2                                    # the only path that blocks
fi
exit 0
```

**Rewriting.** Two mistakes are fatal and both are visible here: the replacement carries the
**whole** input object, and the notice goes on the context channel where the model reads it.

```sh
input=$(cat) || exit 0
fixed=$(printf '%s' "$input" | jq -c '.tool_input |= correct_it' 2>/dev/null) || exit 0
[ "$fixed" = "$(printf '%s' "$input" | jq -c '.')" ] && exit 0   # unchanged: say nothing
printf '%s' "$fixed" | emit_replacement_with_context "Adjusted <field>: <why>."
exit 0
```

**Arming.** A session-start marker its companion gate reads, so a gate can be once-per-session.

```sh
: > "$STATE_DIR/armed.$SESSION_ID"    # create, never fail
exit 0                                # a session start is never worth blocking
```

**Refusing the end of a turn.** The one gate whose verdict does *not* travel in the exit code.

```sh
exit_zero_always() { exit 0; }
trap exit_zero_always EXIT            # a session must never fail to end because this errored

marker="$STATE_DIR/pending.$SESSION_ID"
[ -f "$marker" ] || exit 0                            # no marker: silence means allow
owner_still_alive "$marker" || { rm -f "$marker"; exit 0; }   # liveness, not a clock
older_than_ceiling "$marker" && { rm -f "$marker"; exit 0; }  # absolute ceiling
waiter_in_flight "$marker" && exit 0                  # a sanctioned way to be idle

bounces=$(bump_counter "$marker")
if [ "$bounces" -gt 1 ]; then
  emit_refusal "Still not done. Run: $(named_next_action "$marker")"   # escalate, do not repeat
else
  emit_refusal "Not done: <what is outstanding>."
fi
```

Note what is *not* in any of them: a conditional escape hatch. Every bypass is unconditional, and so
is the off switch - a guard that can only be disabled by knowing a trick gets disabled by other
means, and then nobody knows it is off.

## The hook inventory

**Registering, removing or re-registering a hook requires editing an inventory in the same
change.** A hook is invisible by construction - it fires inside a tool call nobody is reading - so
an undocumented one is indistinguishable from a bug in the tool, and a *removed* one is
indistinguishable from a rule that was never enforced.

The inventory is a **table** with the fixed verdict vocabulary above, one row per hook: what it is,
which event, which verdict, what it does, and which rule it enforces. Write it before you write the
second hook, not after the sixth.

If you put a gate over that inventory, two limits keep it from crying wolf, and both were learned
by shipping the versions without them:

- **Find the table by its heading, not by a filename.** The first version hard-coded a path and
  reported a missing inventory against a repo that had a complete one.
- **Parse the table only, never the surrounding prose.** The first version read script names out of
  a description field and invented three registrations that did not exist.
- **Compare in one direction only:** something registered must appear in the inventory. A row the
  gate cannot match is *not* a failure - a per-machine registration is real, live, and unreadable
  to the gate. Judge what is readable; degrade rather than guess.
- **A hook file on disk that is registered nowhere is an advisory, not a failure.** Dead weight is
  not a documentation gap.

## Test the registered pre-filter, not only the hook

A hook wired to a frequent event should pre-filter cheaply in the runtime's own shell and start the
real interpreter only on a payload that could possibly trip it. That pre-filter is a second program
nobody remembers to test, and when it is wrong the hook simply never runs - which looks exactly
like a hook that was never needed.

The concrete regression: a pattern intended to catch names of the form `Word-Word` matched **no
real name at all**, because the character immediately before the hyphen is lowercase in every
example it was written for. The hook was correct. It just never fired.

So: give the pre-filter **its own must-reach and must-skip cases**, and run them in the shell that
actually evaluates it - not a lookalike shell that happens to be on `PATH`. And smoke every refusal
**from both sides**, payloads it must refuse *and* payloads it must allow. The allow cases are the
load-bearing ones: a guard that over-blocks gets turned off, and then nothing is enforced. A hook
that always exits zero cannot be asserted on its exit code at all - assert its output.

The rule the pre-filter must never break: **it may only skip calls the real check would have
allowed.** The hook stays authoritative.

## Why a false PASS is the worst thing a hook can cause

A gate that cannot run and is backgrounded still reports success, so a refused build comes back
green. That is the `VALIDATION.md` "A green can lie" failure, reached through the enforcement layer
rather than through the build - and the false green is what gets read and reported. The rule lives
there; it is named here because a hook is a common way to arrive at it.

## The one already in this kit, deliberately not wired

`.claude/settings.json` carries a `//hooks-example` key describing a prompt-submit nudge for the
skill-routing ladder (`CLAUDE.md` section 4). It is **left as an example, not wired**, for two
reasons that are worth keeping apart. The mechanical one: a hooks entry pointing at a script you
have not written yet fails on every prompt - the preference order in miniature, since a broken guard
costs more than the miss it prevents. The measured one: that hook's reach was zero on the project
that built it (above), so it is shipped as a **worked example of the population question**, not as a
recommendation to wire it. If your own work is entered by hand rather than by a driver, it may earn
its place. Count first.

## Why this is a document, not a vibe

"Add a hook" sounds like a one-line decision, and it is four: which event, which verdict, what
happens when the hook itself errs, and who can find out it exists. Writing those four down turns an
invisible program into something a reviewer can point at - which is the only way an enforcement
layer stays honest, because the layer's whole job is to run where nobody is looking.

## Adapting it

- Map the event shapes to your runtime's real events. If it has only one hook point (a pre-commit
  hook, a CI job), you still have the verdict question: does this thing correct, or refuse?
- No event hooks at all? The preference order still applies to every gate you *do* have, and the
  inventory rule applies to every gate wired somewhere a reader will not look.
- Keep the inventory wherever you document tooling. The rule is that it exists, is a table, and is
  edited in the same change as the registration - not that it lives in a file with a particular
  name.
