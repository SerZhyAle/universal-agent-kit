---
name: ui-clarify
description: "Use to resolve user-facing ambiguity - placement, wording, visibility, fallback - before building. Triggers: 'ui-clarify', any user-visible change with an unresolved presentation decision."
argument-hint: "<short task description>"
---

# Clarification Gate (user-facing decisions)

Block implementation until every meaningful **user-facing** decision is explicit. "UI" here
means any surface a user perceives: a screen, a CLI flag and its help text, an API response
shape, an error message, an email template. If your product has no user-facing surface,
this skill rarely fires.

## Usage

```text
/ui-clarify <short task description>
```

- `/ui-clarify add a "Save Frame" action to the player`
- `/ui-clarify change the error returned when the upload exceeds the size limit`
- `/ui-clarify add a --format flag to the export command`

## Goal

Before design or implementation, surface every ambiguity that could change behaviour,
placement, discoverability, wording, or user expectations. Do NOT implement while any
important item is unresolved.

If the task touches user-visible wording (labels, help text, errors, empty states,
confirmations, CTAs), treat your project's copy/tone policy (if any) as a mandatory input.

## Required checklist

Inspect the request and the current code, then produce one decision table across five
passes:

1. **Placement & presentation.** Where exactly does it appear? Across the relevant
   form factors (e.g. narrow vs wide, light vs dark, primary action vs overflow/secondary)?
   Inline, in a menu, in a separate view?
2. **Visibility & priority.** Under what conditions is it shown / hidden / disabled? Which
   states, flags, permissions, or data availability gate it? What happens when space or
   attention is scarce, and what outranks it?
3. **Interaction & wording.** Exact label, icon, help/tooltip text, primary action, and any
   secondary action. If wording changes, apply your copy/tone rules and the message formulas
   below. One name per concept: a thing keeps the name it already has on every screen, help
   page and doc - a new synonym is a decision to ask about, not a wording detail.
4. **State, failure UX & accessibility.** Empty / loading / error states; confirmations;
   overwrite/fallback/retry behaviour; accessibility (target size, labels for assistive
   tech, non-colour cues); discoverability when hidden.
5. **Persona pass.** Walk the change once as each kind of reader it serves - a first-time
   user, a returning one, someone on assistive tech or the narrowest form factor, a script or
   operator running it unattended, whichever apply. Each reaches the result with no dead end.
   For a destructive action the pass condition inverts: the reader must be stopped or warned,
   not helped through. A force flag (`--force`, `-y`, "don't ask again") skips the prompt,
   never the safety checks behind it.

## Message formulas

Every message the change adds or edits takes the shape of its kind. Put the exact proposed
text in the decision table; a message off its shape stays unresolved.

| Kind | Says | Example |
| --- | --- | --- |
| Error | what happened + **one** next step; never a raw code as the headline | "Couldn't save the report - the disk is full. Free some space and try again." |
| Empty state | the reason + an invitation to act | "No invoices yet. Import a statement to create the first one." |
| Destructive confirmation | what will happen + whether it can be undone | "This deletes 12 drafts for good - there is no undo." |

## Process

**Step 1 - Read context.** The request/spec; the relevant views/handlers/templates/strings;
the architecture doc if canonical patterns are affected; the copy/tone policy if wording is
affected.

**Step 2 - Build the ambiguity list.** Separate explicit decisions from implicit
assumptions. Mark every unresolved item as blocking.

**Step 3 - Ask or propose.** Ask only the questions needed to unblock. Where a choice can be
delegated, present 2-3 concrete options with trade-offs rather than an open question.

**Step 4 - Produce one outcome.**

### Outcome A - BLOCKED

```markdown
## Clarification Status
Status: BLOCKED

### Confirmed
- <explicitly confirmed items>

### Unresolved
1. <question>
2. <question>

### Why implementation is blocked
<1-3 sentences>
```

When this runs for a ticket, BLOCKED also lands in the ticket: set `**Status:** BlockQuestions`
with the unresolved list as its one-line note, so `/spec-all` stops there and `/backlog` reports it
under "Needs you" instead of re-selecting it. Standalone, the block lives in the chat only.

### Outcome B - READY

```markdown
## Clarification Status
Status: READY

### Approved Decisions
- <placement / visibility / wording / fallback / error behaviour>

### Delegated Assumptions
- <only items the user explicitly let the agent choose>

### Persona pass
- <reader>: reaches the result | stopped or warned (destructive action)
```

## Hard rule

If the request uses non-committal wording about two or more options, treat it as unresolved
unless one option is explicitly approved or the choice is explicitly delegated. Do not infer
implementation freedom when the choice changes discoverability, placement, or behaviour
under a different form factor.
