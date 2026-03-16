# Pass: stabilize-intent-traceability

## Purpose

Make IDs, refs, and target addresses stable and complete across the current
Intent slice.

## Pipeline position

- `intent/within-intent`

## Strengthens

- traceability
- target stability
- graph integrity

## Creates or updates

- local outcome and check IDs
- refs across goals, features, scenarios, behaviors, assurances, and decisions
- frontmatter IDs when they are materially wrong

## Use This Pass When

- local target IDs are weak, missing, or unstable
- refs are incomplete, stale, or inconsistent
- later Blueprint or Arc targeting would be cleaner with a stronger graph

## Not for

- inventing unnecessary graph edges
- changing stable IDs without a material scope reason
- replacing local promise IDs with numeric identifiers

## Inputs

- current Intent artifacts
- shared structure contracts
- linked Blueprint or step targets when already present

## Preconditions

- the current promise structure is already durable enough to identify
- the pass can improve traceability without changing meaning accidentally

## Pass Steps

1. Tighten or add stable local target IDs where the contract requires them.
2. Rebuild refs so the current Intent slice forms one inspectable graph.
3. Remove stale or misleading refs that point to the wrong owner surfaces.
4. Recheck target addresses against downstream Blueprint or step usage where
   relevant.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves the stability or completeness of
  the current Intent graph
- Before posture: targets or refs are weak, missing, or hard to reuse
- After posture: the Intent graph is easier to target and inspect
- Evidence this pass can supply:
  - added or improved IDs
  - updated refs
  - before and after traceability surfaces

## Outputs

- stronger graph integrity for the current Intent slice
- cleaner downstream targeting for Blueprint and Arc

## Hand-off

- continue with `align-blueprint-targets`, `shape-executable-step`, or another
  tightening pass now that targeting is stable

## Quality checks

- local target IDs are stable and meaningful
- refs point to the real durable owners
- traceability reduces downstream guessing

## Escalation triggers

- a stable ID change would silently change meaning
- the graph still reflects a deeper decomposition problem
- the pass reveals missing durable artifact surfaces

## Arc use

- usually invoked during `Map Arc`
- often invoked during `Shape Step` when exact targeting is blocked by weak
  graph structure

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Preserve established stable IDs when meaning has not changed.
