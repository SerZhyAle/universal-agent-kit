# Parallel Agents - several at once, without losing each other's work

`COST.md` answers *how much* a fan-out may spend. This document answers the other half: how several
agents work the same workspace at the same time without destroying each other. The two questions
are separate, and only one of them is about money.

Nothing here is specific to code. It is specific to **shared files**, which is every kind of project
in `PROJECT_SHAPES.md` - two agents rewriting one contract bundle lose work the same way two agents
rewriting one module do, and the version-control operation that takes it away does not ask what the
files contained.

The asymmetry that organizes everything below: **extra readers cost you tokens; extra writers cost
you work.** A wave of readers that goes wrong produces a bill. A wave of writers that goes wrong
produces a tree nobody can account for, and the loss is usually noticed hours later, by which time
the evidence of what happened has been overwritten.

---

## Readers fan out freely

Independent lookups run concurrently, not in sequence. A local symbol search and an external docs
fetch answering the same question start in the same breath - never wait for one before kicking off
the other. If your runtime has subagents, fan out: one reads the local code, another reads the
framework docs, a third checks open issues. You spend wall-clock once instead of three times.

Isolation is also a **context-budget lever**, not only a parallelism enabler: run each
bulky-evidence item in a throwaway child that returns a compact verdict, so the artifacts stay in
the child instead of accumulating in the parent.

## Writers need a boundary, and disjoint files are not one

**Any whole-tree VCS operation one writer runs - in a git repository: stash, checkout, reset,
restore, clean - reverts every other writer's uncommitted edits, even on files it never touched.**
This is the failure that makes parallel writing different in kind from parallel reading, and the
reason "they are editing different files" is necessary but nowhere near sufficient.

It is also hard to diagnose from inside, because the victim sees no error. It sees its own finished
work missing. **"Something keeps reverting my files" is almost always a concurrent agent's tree
op** - so the standing instruction is: re-read from disk before redoing anything, or you will
re-apply an edit that is already there and conclude the tool is broken.

Do not count on a checkpoint to undo a wave either. Claude Code's `/rewind` restores edits its own
file tools made in the current session, not files changed by shell commands and usually not a
subagent's edits - undoing a wave is a version-control job.

Two ways out, and you must pick one explicitly:

- **The orchestrator owns VCS, build and index commands, and runs them only between waves.**
  Parallel writers are forbidden them outright. Cheapest, and enough for a small wave on one tree.
- **Give each writer its own checkout.** Required as soon as a writer needs its own branch, its own
  build, or a run longer than the orchestrator wants to hold the tree still.

## One checkout per writer - what to split and what to keep shared

If your workspace is a git repository, a linked worktree is usually the right shape: it shares the
object store, so it is cheap to create and cheap to throw away, and each writer gets its own working
tree and its own branch. A full clone works too and isolates more, at the cost of a copy.

Claude Code can do this per subagent: `isolation: worktree` in the agent's frontmatter gives each
spawn its own worktree. That worktree branches from the default branch, not from the session's
current HEAD, so in-flight uncommitted work - and anything on your feature branch - is not in it.

What must **not** be shared, or the split buys nothing:

- The working tree itself, obviously - that is the point.
- **Any single-instance resource the build touches**: one output directory, one device or emulator,
  one port, one generated catalog. Two worktrees pointed at one output directory are one writer
  wearing two hats, and they will interleave halfway through a build.

What must **stay** shared, and this is the one people get backwards:

- **The advisory lock path.** If your workspace is a git repository, **resolve it from the shared
  git directory, not from the working tree.** A per-worktree lock serializes nothing, and it does
  so *silently*: every caller takes its lock successfully, every caller believes it is the
  exclusive owner, and they all proceed at once. There is no error to notice - the queue simply
  stops being a queue. The lock discipline itself (queue rather than refuse, take it immediately before the edit, judge staleness by liveness, derive the
  domain from the changed set) lives in `COST.md`; only the path resolution is a worktree question.

## Merging back is part of the plan, not the aftermath

Decide before the wave starts how each writer's work comes home: its own branch and its own commit,
a patch handed to the orchestrator, or a direct merge into a shared integration branch. This is a
**decision to record, not a rule the kit can hand you** - it follows from your branch model, and the
kit has no measurement to offer about which is better.

What is not optional is that *somebody named* does it. A writer that finishes, reports success, and
leaves its work uncommitted in a worktree has produced an orphan: the orchestrator's central
re-validation runs against a tree that does not contain the change, and the wave scores green while
the work sits somewhere nobody is looking. If a writer cannot commit its own output, the
orchestrator's between-wave step must collect it, and that step is part of the wave definition.

## Shaping the wave

- **The budget gate precedes every wave** - count, cost, ceiling, explicit GO above it, find before
  verify, and what to do with a wave a limit killed. It lives in `COST.md`.
- **Each writer gets its exact file list, in its own prompt.** Not a folder, not "the phase 2 files",
  never a pointer into lines of one shared list. A writer left to work out its own scope reads the
  neighbour's lines, edits past its boundary, and the overlap shows up only as missing work.
- **The orchestrator re-validates centrally after the wave returns.** A child's report is a claim,
  not a verdict, and both directions of it are unproven - a reported failure is often a phantom from
  a stale incremental build, and a reported success ("compiles in isolation") was never checked
  against the merged tree. Re-run the checker over each writer's file set, so a red lands on the
  writer that owns it; a changed file that is on nobody's list is itself a finding. The delegation
  hazards in full - tail bias, non-resumable children, adversarial verification of a finding - are in
  the orchestrator role brief, `.claude/agents/rd-lead.md`.

## For unattended work, loop the process - not the session

An agent cannot reset its own context; that is a harness command a human types. So an unattended
loop that runs *inside* one session accumulates every item it has already finished: ticket 1 is
still in context while ticket 9 runs, and the run gets slower and more expensive with each item
precisely because it is working.

**Make the process boundary the reset.** A driver *outside* the session takes the next work item off
the queue, runs it in a **fresh headless process**, and repeats however that run ended. Every item
starts on an empty context, and the reset cannot be forgotten - which is exactly what a self-imposed
"I will stop at a threshold" cannot promise, because it depends on somebody noticing the threshold
and somebody restarting afterwards. The cost case for this, with the one measurement behind it, is
in `COST.md`; what follows is what the shape costs you to build.

- **Every piece of state the loop needs must live in a file, not in the context.** The skip cache
  (what was already attempted and must not be retried), the report buckets (what succeeded, what
  failed, what was skipped and why), and the queue position. State that lives in the context does
  not survive the boundary, which is the whole point of crossing it.
- **The driver must distinguish "failed" from "not attempted".** A driver that cannot tell them
  apart either re-runs finished work forever or drops work on the first crash. Write the outcome
  before moving on, not after the next item starts.
- **A run that ends badly is still an end.** The driver repeats regardless of how the item exited -
  crash, limit, refusal - because the alternative is a loop that stops at the first bad item and
  waits for a human who is not there.

Two things the boundary buys on top of the reset: you can **choose the model per item** rather than
fixing one for the whole run, and you can run **several instances at once** - the lock queue in
`COST.md` is what keeps them off each other. Keep the interactive loop for work a human is watching;
prefer the driver for anything left running unattended.

The kit ships **no driver script**: which queue format, which shell, which headless invocation is a
stack decision. The shape is the transferable part.

## Adapting it

- **No subagents in your runtime?** The whole-tree hazard still applies the moment you run two
  sessions against one checkout, and it is the same fix: one checkout each, or one owner for
  tree-wide commands.
- **No headless mode?** Keep the in-session loop, and make the halt explicit instead: stop at a
  stated threshold and hand back a resume handle, so the human's restart is a keystroke rather than
  a reconstruction.
- **One agent, always?** Read the first two sections anyway. The whole-tree revert also happens
  between one agent and a human working in the same tree, and it looks identical from both sides.
