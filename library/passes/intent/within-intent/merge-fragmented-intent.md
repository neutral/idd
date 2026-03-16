# Pass: merge-fragmented-intent

## Purpose

Combine split surfaces that should form one durable promise.

## Pipeline position

- `intent/within-intent`

## Strengthens

- promise coherence
- artifact usefulness
- downstream targeting

## Creates or updates

- fragmented Intent artifacts in the same scope
- refs and IDs affected by the merge

## Use This Pass When

- one durable promise is spread across too many thin artifacts
- later readers must reconstruct the promise by reading several sibling files
- fragmentation is increasing drift without adding meaningful decomposition

## Not for

- flattening useful decomposition
- merging distinct scenarios or behaviors just to reduce file count
- combining artifacts across unrelated scopes

## Inputs

- fragmented Intent artifacts
- linked refs and targets
- any Blueprint or Arc surfaces already using them

## Preconditions

- the current pieces really belong to one durable owner surface
- merging will improve clarity more than it reduces decomposition value

## Pass Steps

1. Identify the fragmented surfaces that together express one durable promise.
2. Merge that content into the best surviving owner surface.
3. Remove or reduce the now-redundant fragments.
4. Repair refs and target addresses after the merge.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves a fragmented Intent slice by
  consolidating one promise
- Before posture: one promise is scattered across multiple thin artifacts
- After posture: the promise has one clearer durable owner surface
- Evidence this pass can supply:
  - merged artifact surfaces
  - removed fragments
  - repaired refs and targets

## Outputs

- a more coherent durable promise surface
- less reconstruction work for later readers and agents

## Hand-off

- continue with `tighten-feature-outcomes`, `tighten-scenario-checks`, or
  `stabilize-intent-traceability`

## Quality checks

- the merge reduces fragmentation without hiding useful decomposition
- the surviving owner is easier to target directly
- refs and IDs remain stable where meaning did not change

## Escalation triggers

- the artifacts are actually distinct promises
- merging would blur applicability or scope
- the real issue is overlapping duplication, not fragmentation

## Arc use

- usually invoked during `Map Arc`
- sometimes invoked during `Shape Step` when fragmented Intent blocks exact
  step targeting

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Preserve stable IDs where the merged meaning does not materially change.
