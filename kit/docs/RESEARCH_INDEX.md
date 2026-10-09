# Research Order & the Code Index - never guess

The most expensive thing an AI assistant does is *guess*: invent a file path, assume a function
signature, recall an API that changed two versions ago, cite a clause that was renumbered last
spring, quote a figure from a table that has since been re-cut. A guess looks like progress and
costs a full wrong implementation. The cure is a fixed order for finding things, and - for a large
project - a maintained index so finding is one query instead of a blind search.

The index is called a *code index* throughout this document because that is the sharpest example.
Its non-code siblings are the same artifact under other names: a data dictionary, a clause library,
a document register, a table of sources, a service catalogue. Every rule below applies to them
unchanged.

The one rule under all of it: **if you state a path, a symbol, or an API, you have verified it.**

A name is not evidence of behaviour, either. Before reasoning about what a flag, constant, or key
*does*, confirm a live read/call site - a comment or a doc mention is a hit, not a usage. Named
symbols go dead, get renamed in meaning, or never get wired up.

## The research order

Read in this order and stop as soon as a source answers the question:

1. **The map.** The project's index/overview doc - `README`, `ARCHITECTURE.md`, an operations
   index, a feature-to-path map, a table of contents, a matter index. This tells you *where* to
   look before you look. The map is not
   just something you read - it is something you author and keep fresh: a curated
   feature-area-to-location lookup kept in step with the structure it describes, with someone
   owning its correctness. "Consult the map" presumes a map that someone maintains.
2. **The spec / plan.** If the work is ticket-bound, the spec under your plan directory holds
   the decisions and constraints already made. Don't re-derive them.
3. **The code index, then the code.** Locate symbols with your code index or grep *before*
   reading whole trees. Find the file, then read that file - not the directory.
4. **External docs.** Official framework docs, changelogs, issue trackers - when the answer is
   version-specific or about third-party behaviour. Use them freely; this is not cheating and
   needs no permission.

Each rung is cheaper to consult than the one below it is to get wrong. The discipline is to
climb, not to jump straight into reading source or - worse - straight into writing it.

## The index (for projects big enough to get lost in)

Search is fine until the tree is large, names collide, or "where does X live" takes five attempts.
At that point, maintain an **index**: a generated list of the project's units - classes, modules and
files in a codebase; tables and fields in an analysis; sections, terms and owners in a document
set - with, for each, its location and a short role, and optionally what it depends on. The agent queries the index ("show me everything matching `*Repository`",
"what plays the role `data-source`") and gets the location in one shot.

Three rules keep an index trustworthy:

- **Query it before you grep.** For "where is class/module X", the index answers faster and more
  precisely than a content search.
- **Regenerate it after you change code.** A stale index is worse than none - it sends you to a
  path that moved. Make regeneration a step in your post-change routine, or a hook, so it is
  never skipped. The index is a derived artifact: regenerate, don't hand-edit, and it can be
  git-ignored.
- **Measure how often it answers.** An index earns its place by answering, and one that returns
  nothing costs a turn and then sends the agent to grep anyway - worse than not having it. In the
  reference corpus one such registry came back empty on 57% of its queries and nobody noticed,
  because a miss looks exactly like a cheap call. Log the miss rate. Treat a high one as a defect in
  the index's coverage or in its query vocabulary, never as the caller's fault.

**A declared register is checked in both directions.** Some indexes cannot be generated: a register
of every document in a maintained area (`docs/`, say), each with its role and whether it is published,
declares what no tool can derive. Checking that every record points at a file that exists is only
half. The other half is **reverse coverage**: walk the area and fail on any file with no record and no
named exclusion - without it the register describes only what it already knew, and a new file joins in
silence. Register a file before anything links to it, and build the first register from the tree as it
is, exclusions and their reasons included, never from the tree somebody remembers.

**An index alone does not get used - pair it with a refusal.** Making the cheap path available does
not close the expensive one. A pre-filter that narrowed oversized reads was measured being retried
immediately at full width in ~32% of the reads it caught: the agent still wanted the whole file,
because nothing had told it which part it needed. The pairing that works is an index that answers
with an address and a signature, plus an event hook that refuses the unnarrowed search until the
index has been queried in this session (`HOOKS.md`). Each half is bypassable on its own.

**Expensive once, cheap every time - and that is the shape of the investment.** Building the index
and the project's knowledge base is a deliberate, heavy, one-off cost, repaid by every later task
starting from an address instead of from a warm-up. It also fixes the build order for a large shared
codebase: retrieval tooling first, knowledge base second, skills and agent roles last. Skills make a
repeated procedure cheap to invoke; they do nothing about the code an agent drags into context while
hunting for the place to apply them.

This is optional. A small or flat repo does not need it - the research *order* above still
applies. Adopt the index when "find where this lives" has become a tax.

## A capability inventory

Keep a queryable inventory of the capabilities the project already ships - not the code-unit
index above, but a list of what the product does - and scan it before designing a new feature. It
is the cheapest guard against an agent rebuilding, under a new name, something that already
exists. When a unit of work lands, record the capability it delivered so the inventory stays
current; a stale inventory hides duplicates instead of preventing them.

## Work in parallel

Independent lookups run concurrently, not in sequence - how to fan readers out is in `PARALLEL.md`
"Readers fan out freely".

Research is the safe half of parallel work; the moment a wave contains **writers** the rules change,
and why is in `PARALLEL.md` "Writers need a boundary" (the budget gate is in `COST.md`).

## Persist what you find

Research you did and then dropped on the floor gets done again next session. For anything beyond
a trivial lookup, write the findings to a scratch file (or into the spec, for ticket-bound work):
the files and symbols touched, exact locations, the relevant external references, and the open
questions. The next step - and the next session - reads the notes instead of re-grepping.

## Why this is a document, not a vibe

"Don't guess" is easy to nod at and hard to keep under time pressure. Making it a written order
turns it into something a reviewer can check: *did the change cite a verified path, or assume
one?* And making the index a generated artifact turns "I think it's over there" into a query
with an answer. The goal is that every claim in a change is one the agent could point at, not one
it hoped was true.

## Adapting it

- Replace the named docs with whatever your repo actually has as its map.
- No index tooling yet? Start with grep and the order above; add an index only when the codebase
  has outgrown search.
- If your stack has a language server or symbol index already, that *is* your code index - query
  it first and skip the custom one.
