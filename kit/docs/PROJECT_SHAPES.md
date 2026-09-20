# Project Shapes - what the method assumes, and what it does not

This kit was distilled from software work, and software is where its examples are sharpest. Almost
none of it depends on a compiler. The parts that do are marked, everywhere, as the code layer - and
they are a minority.

This document is the translation table. Read it first if your project is not a codebase: it tells
you what the method's five nouns mean in your work, which rules apply unchanged, which need a
local equivalent, and which you should simply delete. Read it anyway if your project *is* a
codebase - the same table is what lets you use the method on the parts of your project that are not
code, which is most of them by the end of a year.

## The five things the method assumes

The method is not "AI for programmers". It is what you do when an agent can change your files
faster than you can read the changes. That needs five things, and only five:

1. **A workspace.** The project's files in one place, with history you can read and roll back.
   Git is the assumed shape; anything that keeps versions and can show you a diff will do. Without
   history, keep the method and add "copy the folder before a big change" - you will want it on the
   first bad day.
2. **Artifacts.** The things the work produces and a reader consumes: source files, a report, a
   contract, a dataset, a translation, a slide deck, a runbook.
3. **Work items.** One unit of work, written down, with a status that is true. The kit calls them
   tickets and keeps each as one Markdown file. Your tracker works too; the discipline is in the
   document, not the tool.
4. **Checks.** A question about an artifact that gets answered without anyone's opinion. A compiler
   is one. So is "every defined term in this contract is used at least once", "this notebook runs
   end to end", "no link in this document is dead", "the totals in the summary equal the totals in
   the source table".
5. **An agent that can read and write the workspace**, and that you can steer with text.

If you have four of the five, the method still works and you will feel the gap at exactly the point
the missing one would have covered. If you have three, start by building the fourth.

The one that people assume they lack, and almost always have, is **checks**. See below.

## The vocabulary, in five kinds of project

Read your column. Everything else in the kit is written in the left-hand one.

| The method's word | Software | Data & analysis | Writing & documentation | Legal & compliance | Operations & admin |
| --- | --- | --- | --- | --- | --- |
| The workspace | the repo | the analysis repo, notebooks + queries + outputs | the docs repo or manuscript folder | the matter folder: drafts, precedents, filings | the runbook folder: procedures, templates, registers |
| An artifact | a module, a test, a migration | a query, a notebook, a published figure, a dataset | a chapter, a page, a locale, a diagram | a clause set, an agreement, a filing, a policy | a procedure, a checklist, a register, a form |
| The map (`<INDEX_DOC>`) | README / ARCHITECTURE | a data dictionary + a table of sources | a table of contents + an owner per section | the matter index: parties, versions, governing docs | the service catalogue: who owns what, where it runs |
| A cheap check (seconds) | compile, type-check, lint | the query parses; row counts against the source | spellcheck, link check, heading structure, word budget | defined terms all used; cross-references resolve; version block present | the form validates; required fields present; the register has no gaps |
| A middling check (minutes) | targeted test | the notebook runs end to end on a sample | a render: PDF/site builds, no broken figure | a diff against the precedent; a clause-level comparison | a dry run of the procedure on a copy |
| The expensive check | full build, run and observe | the full pipeline on real data, numbers reconciled | a human read of the finished piece | a partner or counterparty review | a live rehearsal with the people who will run it |
| "Done" | the behaviour works end to end | the number in the summary can be traced to the source row | a reader who was not there can act on it | it would survive the other side reading it adversarially | someone else ran it from the text alone |
| The code layer | all of it | the parts that are code | rarely | never | scripts only |

Two things this table is saying, and both are load-bearing:

- **The rungs are the same ladder.** Cheap-and-narrow to expensive-and-broad, and the rule is
  unchanged: pick the lowest rung that actually proves *this* change (`VALIDATION.md`).
- **The top rung is usually a human, in every column.** That is not a weakness of the non-code
  columns; it is the normal case, and the method's answer to it is the same everywhere - a human
  check that has not happened yet is not a pass, it is a pending one.

## "We have no checks" is almost always false

The most common reason a non-programmer decides the method is not for them: *nothing here compiles,
so there is nothing to check.* Test that belief before you accept it. Ask the question the other
way round: **what would you be embarrassed to send?** Every answer is a check, and most are one
command or one careful grep away.

Observed shapes, in order of how often they turn out to exist already:

- **A total that must match another total.** Two places, one truth. Reconcile them mechanically.
- **A name that must exist somewhere else.** A defined term, a cross-reference, a cited source, a
  glossary entry, a file the text claims is attached.
- **A structure that must hold.** Every section present, every heading in order, every required
  field filled, every row keyed.
- **A thing that must still resolve.** A link, a path, a citation, a contact, an active version.
- **A rendering that must succeed.** The document builds, the deck exports, the sheet opens without
  a repair dialog.

None of those needs a programmer to author. Each of them needs to be written down once, given a
command or a stated procedure, and then run - which is the entire difference between a check and a
good intention. The kit's rule about that difference is measured and blunt: a directive with a
mechanical check behind it was followed about **99%** of the time; the same directive as prose was
followed **1-8%** (`AUTHORING.md`). That number does not care what your artifacts are made of.

## What transfers unchanged

These carry over with no translation at all. They are about how work is decided and proven, not
about what it is made of:

- **Research before acting**, and never state a fact you have not verified (`RESEARCH_INDEX.md`).
- **Split what from how** - the single highest-leverage habit in the kit, and the one that needs a
  compiler least. A spec that says "the report must let a regional manager see their own numbers
  without asking anyone" survives a change of tool; a spec that starts with the pivot-table layout
  does not.
- **Plan in verifiable phases**, each ending in a check anyone can run (`SPEC_LIFECYCLE.md`).
- **Status comes from reality**, never from a filename or a hope.
- **Evidence, not narration** - "should be fine" means the check has not run (`VALIDATION.md`).
- **Memory across sessions**, and the discipline of what not to save (`AGENT_MEMORY.md`).
- **Cost and fan-out**: context is re-read on every turn whatever it contains (`COST.md`).
- **Parallel work**: readers are free, writers need isolation, and one careless whole-workspace
  command reverts everyone (`PARALLEL.md`). Nothing about that is specific to code - it is specific
  to *shared files*, which is every column of the table.
- **Authoring a rule against an observed failure** (`AUTHORING.md`).

## What needs a local equivalent

- **The check commands.** `<CHECK_CMD>` is the one placeholder that every project must fill, and
  filling it is the single most valuable hour you will spend on adoption. The code-layer
  placeholders (`<BUILD_CMD>`, `<TEST_CMD>`, `<LINT_CMD>`, `<RUN_CMD>`) are refinements of it, for
  projects that have those four distinct things.
- **The quality list.** `CODE_QUALITY.md` names seven patterns an agent emits that look fine and
  rot a codebase. Non-code artifacts have their own seven, and yours will be specific enough to be
  worth writing down. The generic ones, seen in every column: text that restates its heading
  instead of saying something; a number with no source; a placeholder left in a finished document
  (`TBD`, `<name>`, `lorem`); a section kept because deleting it felt rude; a claim with a hedge in
  front of it doing the work of evidence; an inconsistency between a summary and the body it
  summarizes; and a stale cross-reference to something that has since been renamed. Write your list
  the same way the code one was written - from what you actually caught in review, not from
  imagination.
- **The index.** `RESEARCH_INDEX.md`'s code index becomes an index of your material: a data
  dictionary, a clause library, a document register, a table of sources. Same three rules -
  query it before searching, regenerate it after you change things, and measure how often it
  answers.

## What to delete outright

Delete, do not adapt. A rule kept "just in case" on a project it cannot apply to is noise that
trains everyone to skim:

- Layering and dependency direction (`<ARCH_LAYERS>`), thin entry points, the logging facade
  (`<LOGGER>`) - if nothing in your project imports anything, these have no subject.
- Verification tags (the temporary log line carrying a ticket id) - unless your artifacts produce a
  log you can grep during a manual run. Some do: a pipeline, a workflow engine, a form system.
- The compile rung of the ladder. Your ladder simply starts at the next rung up.

## The honest limits

Three, stated plainly, because a method that claims to fit everything fits nothing:

1. **Where nothing can be checked mechanically, the method degrades to a checklist with good
   manners.** It still helps - the split of what from how, the status discipline, the "no claim
   without evidence" rule all survive - but the enforcement is gone, and enforcement is where the
   99-versus-8 gap lives. If you can build one real check, build it before you adopt anything else.
2. **Where the artifact is a single flowing document with one author, the ticket machinery is
   overhead.** Take the rulebook, `/quick`, `/fix` and the memory discipline; leave the pipeline
   until the work genuinely has phases, dependencies and a second person.
3. **Where the work is not files, this kit has nothing to say.** A method that lives in a workspace
   cannot help with a conversation, a negotiation or a decision that was never written down. Write
   it down first; then it is a project.

## Adapting it

- Fill in your own column of the table above and keep it in the repo. It is ten minutes, and it is
  what lets a newcomer - or an agent - map a rule to your reality without asking.
- Where the kit's prose says "code", read "the artifacts your project is made of". Where it says
  "compile", read "the cheapest check you have". The places where that substitution does not work
  are, by construction, the code layer.
- If your project has several shapes at once - and most do, once the docs, the data and the
  contracts are counted - do not fork the rulebook. Keep one rulebook and let the check commands
  differ by area, exactly as `VALIDATION.md` scopes a gate by the change kind.
