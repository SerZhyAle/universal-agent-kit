**Status:** Verified

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

**The build script as a check.** It verifies the kit source, merge prompt, page, sitemap and every required
date-stamp location before it rewrites a release surface. It then rebuilds the zip, compares every entry's
hash with its source, counts entries and stamps the date. Its final line names the `build-kit` subject.

| Rule | Verdict |
| --- | --- |
| `CHECK-VERDICT` 1-2: "could not verify" is its own code | holds: a missing or invalid release input ends `build-kit: COULD NOT VERIFY` with exit 2 |
| `CHECK-VERDICT` 3: the header promises only reachable codes | holds |
| `CHECK-VERDICT` 4: detail before the verdict | holds |
| `CHECK-VERDICT` 5: the verdict line names its subject | holds: `build-kit: PASS` or a named non-passing verdict is the final line |
| `CHECK-VERDICT` 9: all failures counted, no stop at the first | holds |
| `BUILD-EVIDENCE` 7: generator and verification ship together | holds: the 2026-09-23 rebuild found 45 entries and 0 mismatches |
| Side effect | holds: a missing merge prompt exited 2 and left the zip, page and sitemap byte-for-byte unchanged |

**The kit's vocabulary** (re-expressed method; never names the contract):

- The kit's four answers are PASS / DEFECT / COULD NOT VERIFY / **NOT APPLICABLE**; the contract's fourth
  is **advisory** (found, but not attributable to the caller's change). "Not applicable" does not yet have
  a contract exit-code mapping.
- "Could not verify is never a pass" is carried correctly across the kit.
- The verify command now emits all four answers, including COULD NOT VERIFY for an unreachable target and
  NOT APPLICABLE for an explicitly dry run.
- The hooks guide now says that its `exit 2` is an agent-runtime block signal, not a check verdict.

## Goals

1. The build script exits 2 with a named reason when an input is missing, verifies before it writes, and
   ends with a verdict line naming itself.
2. The kit's verify command reports all four answers, including "could not verify", so the kit obeys its
   own rule.
3. The kit uses one four-answer set internally and asks the owner to map its fourth answer without the kit
   naming the contract.

## Changes asked of the contract (proposals to the owner)

1. **"Not applicable in this configuration"** - the contract's closed set has no place for it, and every
   outside consumer will invent one. Ask the owner to state where it folds: 0 with a `SKIPPED` word in the
   verdict line, or 2.

Filed 2026-09-23 beside the contract. The owner chooses the mapping; this repository changes neither the
contract text nor its own release protocol while the proposal is pending.

## Resolution

Completed 2026-09-23. The release build now preflights all inputs and stamp locations before it writes,
reports a named PASS / DEFECT / COULD NOT VERIFY verdict, and preserves release surfaces when an input is
missing. The kit's verify command, validation guide and command index share PASS / DEFECT / COULD NOT
VERIFY / NOT APPLICABLE; the rebuilt archive carries those files. The owner proposal records the remaining
cross-product decision about the fourth answer.

## Constraints

- Voluntary: nothing here enters the registry as a deviation, because this product is not bound. If it
  opts in, it declares rows then.
- A `kit/` change is a product change: authored against the observed contradiction, rebuilt into the zip
  and reflected on the page by the one build script.
- `kit/` stays stack-neutral and names neither the catalog nor any contract id.

## Done criteria

- Build script: a run with every input present prints its named `PASS` line with exit 0; a run with an
  input removed exits 2 without touching the zip or the page (both runs cited) - done.
- The kit's verify command and its validation guide use one four-answer set, and the rebuilt zip carries
  it - done.
- The proposal exists beside the contract or has been answered - filed 2026-09-23.

## Open questions

1. Opt in formally (declare registry rows) or keep this as voluntary alignment? (Recommended: voluntary -
   one script is not a check system, and the kit's side is method, which the catalog does not govern.)
