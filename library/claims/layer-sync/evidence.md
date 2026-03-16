# Evidence Capture

Capture this claim type in the shared Arc evidence shape: claim, context or
method, observations and raw artifacts, and verdict.

## Claim

- state the intent, blueprint, and code scope being aligned
- record any unchanged or deferred layer and why
- record any limit on the alignment claim

## Methodology References

- record the claim type folder path
- link `arc.md`, relevant step refs, and the evidence index
- link the touched intent, blueprint, code, test, and description refs

## Method Or Context

- explain how alignment was checked or maintained
- record whether the claim is Arc-wide or limited to a scoped slice

## Observations

- record the relevant refs in each layer
- record unchanged rationale where a layer did not move
- record any observed drift or fragility that limits the claim

## Raw Artifacts

- touched intent and blueprint files
- changed code, description, and test files
- decisions that explain unchanged or reconciled layers

## Verdict Guidance

- `supported`: the touched layers are aligned or explicitly justified
- `mixed`: most alignment holds, but a material gap or fragility remains
- `open`: the Arc is still resolving layer alignment
- `incomplete`: the thread exists but the evidence is not yet inspectable
- `failed`: a material layer drift remains or was hidden

## Evidence Thread Rules

- create a new item when an independent layer group needs separate treatment
- enrich the existing item when the same scope gains more alignment support
- do not mix true conflict resolution with steady-state alignment posture

## Closeout Conditions

- the touched scope is explicit
- the layer posture is inspectable
- unchanged or deferred rationale is preserved where needed
