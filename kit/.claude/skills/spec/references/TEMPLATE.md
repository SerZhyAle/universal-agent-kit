# Strategic spec template - used by /spec

```markdown
# Strategic spec: <ID> - <Feature name>

**Ticket:** <ID>
**Status:** Draft
**Priority:** <0..100>
**Date:** <YYYY-MM-DD>
**Tier:** <label>
**Blocked-by:** <ID, or "none">
**Carried-to:** <ID, or "none">
**Tactical plan:** `<PLAN_DIR>/<ID>_<slug>/` (created by /spec-tech)

> **Scope:** STRATEGIC. Goals, constraints, open questions. No class names, paths, line
> budgets, schema versions, or framework module details.

---

## 1. Problem
<2-4 sentences. What is broken or missing? Effect on the user. Affected area (module /
feature, not class names).>

## 2. Goals
<Numbered list of observable improvements: "what becomes possible / what stops happening".>

**Non-goals:**
- <explicitly out of scope>

## 3. Wishes and constraints
### 3.1 Owner wishes
<Desired but not required for the first iteration.>

### 3.2 Hard constraints
- **Platform / versions:** <or "none">
- **Performance:** <budget if critical, else "n/a">
- **Data compatibility:** <migration shape, no version numbers>
- **Localization:** <required locales, or "n/a">
- **Accessibility:** <if the feature is user-facing: the input modes and layout classes it must work in>
- **Shared boundary:** <a format, payload or behaviour another project reads that this changes, and
  where its contract lives - the contract amendment is the plan's first phase; or "none">


### 3.3 Owner inputs (Approval gate)
<Only the bullets matching detected scope; fill concrete values, no placeholders.>
- **Related tickets:** <dependencies / dependents, or "none">

## 4. Current architecture context
<1-2 paragraphs: which layers/components own the affected area, and why the problem cannot
be solved as-is. No class names.>

## 5. Proposed approach
<Architectural level: which roles appear, what reads/writes where, what responsibility
shifts. No class/file/method names.>

### 5.1 Pillars / modules
<Major logical blocks, each with a goal and requirements.>

### 5.2 Data & event flows
<High-level: "UI -> application layer -> cache -> ..". No method names.>

### 5.3 Extension points
<What must stay open to extension.>

## 6. Open questions / research items
1. **<title>**
   - **Question:** <..>
   - **Options:** <if known>
   - **To find out:** <what to check>
   - **Status:** Open / Resolved
   - **Artifact:** `<PLAN_DIR>/<ID>_<slug>/research/<NN>__<topic>.md` <if resolved by real research>

<If none: "No open questions.">

## 7. Risks
| Risk | Likelihood | Impact | Mitigation |
|------|:----------:|--------|-----------|
| <..> | Low/Med/High | <what breaks> | <how to prevent> |

## 8. User impact (docs)
<Default: "No changes to user docs." Only if this introduces a capability the user would
perceive as new: one sentence for the feature docs.>

## 9. Architecture decisions (ADR)
**ADR-1: <title>** - Decision / Alternatives / Why.
<If none: "No ADRs - decision follows established project patterns.">

## 10. Links to other specs
<List or "None.">

## 11. Done criteria (strategic)
<Numbered, observable outcomes - not architecture claims. "User sees X" / "Batch finishes
in under N minutes".>

## 12. Next step
`/spec-tech <ID>` - creates the phased tactical plan (and replaces this line with its link).
```
