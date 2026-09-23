**Status:** Draft

# SPECIFICATION - Align the build check and the kit's verdict vocabulary with the automated-checks contracts

Parent: [SPECIFICATION_CONTRACTS_SYNC.md](SPECIFICATION_CONTRACTS_SYNC.md). Audit date 2026-09-23.

## Contracts

- **`CHECK-VERDICT` 0.9** - the exit-code vocabulary 0 / 1 / 2 / 3 (pass / defect / could not verify /
  advisory) and one verdict line naming its subject.
- **`BUILD-EVIDENCE` 0.9** - a build or check result is evidence about the artifact being shipped.
- `CHECK-BASELINE`, `CHECK-PLACEMENT` 0.9 - not applicable: no baselines, one check.
- Drafts, owned by FastMediaSorter Android. **This product is not a named consumer.** The work below is
  voluntary alignment, taken on because the repository touches the function from both sides: it runs one
  check of its own, and `kit/` teaches outsiders a verdict vocabulary of its own.

## Where the repository stands

**The build script as a check.** It rebuilds the zip, compares every entry's hash with its source, counts
entries and verifies the date stamp; it prints `PASS` with exit 0 or `FAIL` with exit 1, after listing
every mismatch.

| Rule | Verdict |
| --- | --- |
| `CHECK-VERDICT` 1-2: "could not verify" is its own code | deviates: a missing input throws and exits 1, which reads as a defect |
| `CHECK-VERDICT` 3: the header promises only reachable codes | holds |
| `CHECK-VERDICT` 4: detail before the verdict | holds |
| `CHECK-VERDICT` 5: the verdict line names its subject | deviates: bare `PASS` / `FAIL` |
| `CHECK-VERDICT` 9: all failures counted, no stop at the first | holds |
| `BUILD-EVIDENCE` 7: generator and verification ship together | holds; an independent recount on 2026-09-23 found 45 entries, 0 mismatches |
| Side effect | on a missing date stamp the zip is already rewritten and the page partly stamped before exit 1 |

**The kit's vocabulary** (re-expressed method; never names the contract):

- The kit's four answers are pass / defect / could not verify / **not applicable**; the contract's fourth
  is **advisory** (found, but not attributable to the caller's change). "Not applicable" does not exist in
  the contract.
- "Could not verify is never a pass" is carried correctly across the kit.
- Internal contradiction: the kit's verify command reports only PASS / FAIL, and on an unreachable target
  says "report the blocker" with no verdict word - breaking the kit's own four-answer rule.
- The hooks guide's `exit 2` is the agent runtime's block signal, a different protocol; a one-line note
  would stop a reader from conflating it with a check verdict.

## Goals

1. The build script exits 2 with a named reason when an input is missing, verifies before it writes, and
   ends with a verdict line naming itself.
2. The kit's verify command reports all four answers, including "could not verify", so the kit obeys its
   own rule.
3. The kit and the contract agree on the fourth answer, in whichever direction the owner decides - the kit
   re-expressing it in neutral words, never citing the contract.

## Changes asked of the contract (proposals to the owner)

1. **"Not applicable in this configuration"** - the contract's closed set has no place for it, and every
   outside consumer will invent one. Ask the owner to state where it folds: 0 with a `SKIPPED` word in the
   verdict line, or 2.

## Constraints

- Voluntary: nothing here enters the registry as a deviation, because this product is not bound. If it
  opts in, it declares rows then.
- A `kit/` change is a product change: authored against the observed contradiction, rebuilt into the zip
  and reflected on the page by the one build script.
- `kit/` stays stack-neutral and names neither the catalog nor any contract id.

## Done criteria

- Build script: a run with every input present prints its named `PASS` line with exit 0; a run with an
  input removed exits 2 without touching the zip or the page (both runs cited).
- The kit's verify command and its validation guide use one four-answer set, and the rebuilt zip carries
  it.
- The proposal exists beside the contract or has been answered.

## Open questions

1. Opt in formally (declare registry rows) or keep this as voluntary alignment? (Recommended: voluntary -
   one script is not a check system, and the kit's side is method, which the catalog does not govern.)
