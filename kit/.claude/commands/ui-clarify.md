---
description: "Use to resolve user-facing ambiguity - placement, wording, visibility, fallback - before building. Triggers: 'ui-clarify', any user-visible change with an unresolved presentation decision."
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

Inspect the request and the current code, then produce one decision table across four
passes:

1. **Placement & presentation.** Where exactly does it appear? Across the relevant
   form factors (e.g. narrow vs wide, light vs dark, primary action vs overflow/secondary)?
   Inline, in a menu, in a separate view?
2. **Visibility & priority.** Under what conditions is it shown / hidden / disabled? Which
   states, flags, permissions, or data availability gate it? What happens when space or
   attention is scarce, and what outranks it?
3. **Interaction & wording.** Exact label, icon, help/tooltip text, primary action, and any
   secondary action. If wording changes, apply your copy/tone rules.
4. **State, failure UX & accessibility.** Empty / loading / error states; confirmations;
   overwrite/fallback/retry behaviour; accessibility (target size, labels for assistive
   tech, non-colour cues); discoverability when hidden.

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

### Outcome B - READY

```markdown
## Clarification Status
Status: READY

### Approved Decisions
- <placement / visibility / wording / fallback / error behaviour>

### Delegated Assumptions
- <only items the user explicitly let the agent choose>
```

## Hard rule

If the request uses non-committal wording about two or more options, treat it as unresolved
unless one option is explicitly approved or the choice is explicitly delegated. Do not infer
implementation freedom when the choice changes discoverability, placement, or behaviour
under a different form factor.
