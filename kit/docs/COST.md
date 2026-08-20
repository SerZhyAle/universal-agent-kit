# Agent Cost & Fan-out - spend the budget where it pays

Agents burn two budgets: tokens and wall-clock. The method's autonomy multiplies both - a
research order that fans out, a pipeline that re-audits, a reviewer that spawns skeptics. This
document is the discipline that keeps the spend proportional to the value. It is not a cap; it is
a policy for deciding *when the spend is worth it*.

## Where the spend actually is - do not optimise the visible half

The intuitive levers are the visible ones: the agent's answers look long and the rulebook looks
long, so both look like the place to cut. Mined over the reference corpus, neither is:

- **Re-read context dominates.** Cached input was ~72% of the bill. Everything the agent *wrote* -
  prose, code, specs, every produced artifact - was ~12%.
- **The always-loaded preamble is a fifth of everything.** System prompt plus rulebook plus tool
  descriptions ride on every single request and accounted for ~23% of total spend.
- **A small minority of sessions carries half the bill.** ~7% of sessions accounted for 50% of all
  cached-input spend, nearly all of them long unattended pipeline runs that compacted repeatedly
  instead of resetting.

Two consequences are worth stating out loud, because both contradict the reflex:

- **"Answer more briefly" is not a cost lever.** Output is roughly a ninth of the bill. Brevity is a
  legibility decision - argue it as that, and never sell it as savings.
- **Trimming the rulebook's prose is not one either.** One deliberate pass cut the always-loaded
  preamble by 2.5% and moved the bill by 0.23%, two orders of magnitude below the corpus's own daily
  variance and therefore unmeasurable by construction. Write each directive at the length that makes
  it hold, and buy the savings from session boundaries instead (`Context hygiene`, below).

Culling artifacts is still worth doing, for the reader's sanity and the agent's signal-to-noise. Just
not on the token argument.

## Inline vs subagent - when to spawn

Do the work **inline by default**. A subagent is not free: it costs a full context spin-up plus
its own tokens, and its report is a claim you must re-validate. Spawn one only when it buys
something inline cannot:

- **Parallelism** over genuinely independent questions - local code and external docs at once.
- **Isolation** of bulky evidence - run a task with a large, noisy artifact trail in a throwaway
  agent that returns one compact verdict, so the raw material stays in the child instead of
  swelling your context.
- **A fresh context** the main thread should not have to carry.

For a quick lookup, an inline grep beats a spawned reader every time.

## Tool budget per subagent

Scope is a budget too. Give a subagent only the tools its job needs: a read-only
investigator gets read/search, never edit or UI-automation; an implementer gets the editor,
not the deploy keys. Beyond safety, unused capability costs real overhead - an attached tool
server (MCP or similar) can spin up its own process and context for every agent that carries
it, so a reader with automation tools enabled is pure waste. The kit's role briefs declare
their tool lists in frontmatter; keep that discipline when you author new ones
(see `AUTHORING.md`).

## Context hygiene

- The context window fills fast, and cost is accumulated context multiplied by turns - inside one
  unbroken block it is quadratic, because every turn re-reads everything before it. Between unrelated
  tasks, start fresh (compact / clear) rather than dragging a stale context forward. Argue this on
  **cost**, which you can measure; do **not** argue it on answer quality unless you have actually
  measured quality degrading with context size. Attaching a real practice to a rationale you cannot
  show is how the practice gets reverted the first time someone challenges it.
- **Offload raw artifacts** - full build logs, grep dumps, large file bodies - to `<SCRATCH_DIR>/`
  and reference them by path. Never paste them into the running context or a durable doc; keep the
  proof available, keep the context scannable.
- Journal at the grain of the logical change (see `VALIDATION.md`), not per file, so the narrative
  stays short.

## Measure before you rule

Every claim about what agent behaviour costs is a guess until it is measured, and the naive measurement
is wrong by a lot. If your runtime keeps session transcripts, mine them - and correct for all four of
these before you believe a number, because each one was found by a measurement that disagreed with
itself:

- **Deduplicate by request id.** One model response is written to a transcript as several records -
  thinking, text, one per tool call - and each repeats the same usage object. Summing records instead of
  unique requests inflated token totals roughly threefold in the reference corpus.
- **Walk nested subagent sessions**, not only the top-level ones, and report the tiers separately as well
  as pooled. Subagent conversations are structurally shorter, so a pooled average corrupts the per-turn
  headline.
- **Classify a hard tool failure by the runtime's error flag, never by a regex over the result body.** A
  source file containing the word `error` otherwise scores as a failed read.
- **Never count consumption by tool name.** "Is this file ever read again", answered by scanning read
  calls, is invalid for any artifact that is also written, searched, or opened through the shell - and
  shell reads (`head`, `sed`, `cat`, `Get-Content`) carry no file path at all, so no tool-name scan sees
  them. One such count moved from 42% to **3.8%** once every channel was included. Enumerate the
  channels, report the sensitivity across them, and define the population by what the artifact *is*, not
  by the directory it sits in.

A single-channel count is not evidence. And a number nobody can reproduce is worse than no number,
because it still gets acted on.

## The fan-out budget gate

Before spawning a wave of parallel agents, gate it:

- **Estimate** the agent count and the rough token cost. A handful of readers is cheap; a dozen
  writers each dragging bulky evidence is not.
- **Keep a small default ceiling** (~6-8 agents per run). Above it, get an explicit GO - state the
  count, the cost, and why fewer will not do.
- **Stage the work: find first, then verify.** Do not fan out verification over findings you have
  not deduplicated - you will pay to check the same thing three times.
- **Never silently resume a run a limit killed.** A limit-killed fan-out leaves partial,
  unverified results. Report what completed and what did not, then decide - do not paper over the
  gap and call it done.

## Serializing a shared resource - a queue, not a refusal

Fan-out and unattended multi-ticket runs (`/backlog`) mean several agents work the same tree at
once, and some operations cannot overlap: a build that owns one emulator or one output directory, a
multi-file edit, a catalog regeneration. Serialize those with an advisory lock. The discipline below
is what a one-line "take a lock" rule grows into the first time agents actually contend for it -
every rule here replaces a shape that was tried and failed. The kit ships **no lock script**: which
file, which shell, which liveness API is a stack decision. The shape is the transferable part.

- **A busy lock queues the caller; it does not refuse them.** Refusal makes the loser retry on its
  own schedule, which is a busy-wait dressed up as a rule. A queue gives an order, and the order is
  what makes several agents fair to each other.
- **The waiter needs a distinct exit code meaning "queued, not yours yet"**, separate from both
  success and failure. "Done" and "you are third in line" are different instructions to the caller,
  and one code cannot carry both.
- **Queued is not idle - and this is the half no script can enforce.** Say explicitly what a queued
  agent does instead: the work that needs no lock - reading, research, writing a spec, updating the
  index, documentation, log analysis. Without that sentence the queue only relocates the stall.
- **Take the lock immediately before the edit and release it right after - never for a whole
  task.** Everyone behind you waits exactly as long as you hold it. The observed failure that
  produced this rule: one lock held for **479 seconds** across an entire implementation phase.
- **Judge staleness by liveness, not by a clock, and pick the signal per lock kind.** A build lock
  is held by a *process*, so process liveness answers it. An edit lock is held by a *session*, which
  is not a process and needs a heartbeat - a live owner keeps its lock for however long the edit
  legitimately takes.
- **"Cannot determine liveness" is never grounds for eviction.** Treating unknown as dead evicts
  live waiters, and that destroys trust in a queue faster than anything else. Evict on a positive
  liveness answer, or on an absolute ceiling - never on an unreadable one.
- **A re-entrant call returns success without queueing.** A caller that already holds the lock must
  not queue behind itself; that is a self-deadlock with a timeout attached.
- **A background waiter reports its verdict in a marker file, never in its exit code.** A
  backgrounded task's exit code is the exit of the last command in its launch line, so a refused
  build comes back looking green - the `VALIDATION.md` "A green can lie" failure, in its most
  expensive form. Give the marker a closed set of outcome values the reader can branch on
  exhaustively.

Every window, ceiling and grace period such a queue needs is a **tuning constant, not a
measurement**: set it from your own contention and state it once, the way `COST.md` asks you to
state the fan-out ceiling. The one number above is an observation, which is why it travels.

## Model-tier routing - per skill, and per spawn

Route each skill to the cheapest model that still does its job well:

- **Mechanical leaf skills** - `/quick`, `/caveman-commit`, a status flip, a changelog line -
  run fine on a small, cheap model.
- **Diagnosis, review, orchestration, and spec design** - `/spec`, `/spec-check`, `/review`, the
  rd-lead orchestrator - stay on a strong model. A cheap model here costs more in wrong turns than
  it ever saves in tokens.
- The routing is a dial, not a law: when a "mechanical" skill meets real ambiguity, it escalates
  rather than guessing cheaply.

Then route the **spawn**, which is the half everyone skips. A harness's built-in
general-purpose agent has no definition file, so it **cannot carry a model pin at all** - it takes
the session default, and the session default is the most expensive tier you have. The remedy is
therefore not "pin that agent" but **name the tier at the call site, or route through a
purpose-defined agent that already pins one**. And give every agent you *do* define an explicit
tier, for the same reason a script lists its exit codes: **the default is invisible, and nobody
audits an invisible default.** Mechanical work - search, lookup, doc reading, running a gate and
reporting its verdict - names a light tier; the strong tier is for design judgement, review, and
orchestration. The kit's four role briefs are pinned this way in their frontmatter; copy the
pattern, not the tier names - those are your runtime's, and a downloader on another runtime maps
them.

**No saving is claimed**, and this section is the place to prove that the "Measure before you rule"
discipline above applies to the kit's own rules. What was *observed*, on one machine over a 14-day
window: the unpinnable built-in was the most-spawned subagent type, at 182 spawns in those 14 days,
while output tokens over the same window ran 82.8% on the expensive tier. That those spawns are what
carried that split is a **deduction, not a measurement** - the instrument records a spawn's type and
a message's authoring model separately and never correlates the two. Two further cautions before you
quote any tier number: a tier split is an *output* figure while cached input often dominates the
bill, so a tier saving is not a bill saving without both; and the honest re-measurement is a fresh
mining pass taken after the rule has been live, not the same pass read again.

This is the operational half of the "Any model" idea - the method does not change with model
power, but *which* model you point at *which* skill does.

## Verification is not free either

Adversarial verification - several skeptics per finding - is the right spend on a claim that
would be expensive to get wrong, and waste on a trivial one. Match the depth to the cost of the
finding being false: a one-line typo fix earns a grep; a security or data-safety claim earns
independent skeptics who each address the named mechanism. Spending the same effort on both is how
a review gets slow, then gets skipped.

## Why this is a document, not a vibe

Cost discipline is easy to nod at and easy to blow past mid-task, when a fan-out "might help" and
the agents are one call away. Making it a written gate - estimate, ceiling, explicit GO - turns
"spawn a dozen agents" from a reflex into a decision a reviewer can point at. The goal is spend
that tracks *value*, not *activity*.

## Adapting it

- Set the ceiling to your runtime's real shared limits (rate limits, token budgets, concurrent-
  agent caps). One number, stated once.
- No subagents in your runtime? The inline-vs-spawn section is moot - keep context hygiene and the
  journal rule; they still pay.
- One writer at a time, always? Skip the lock queue - there is nothing to serialize. Adopt it the
  first time two agents contend, not before.
- Map the tiers to the models you actually have (frontier / mid / small-or-local), per the
  "Any model" section of the method.
