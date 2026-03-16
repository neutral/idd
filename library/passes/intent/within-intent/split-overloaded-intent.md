# Pass: split-overloaded-intent

## Purpose

Divide one overloaded artifact into cleaner durable promise units.

## Pipeline position

- `intent/within-intent`

## Strengthens

- scope discipline
- target precision
- decomposition quality

## Creates or updates

- overloaded Intent artifacts
- new sibling artifacts created by the split
- refs and target IDs affected by the split

## Use This Pass When

- one artifact carries several promises, situations, or behaviors at once
- the current surface is hard to target cleanly in Blueprint or Arc
- later work would otherwise edit one artifact for unrelated reasons

## Not for

- splitting just to make files smaller
- breaking apart already-coherent promise units
- replacing necessary context with isolated fragments

## Inputs

- the overloaded Intent artifact
- linked refs and targets
- surrounding decomposition surfaces

## Preconditions

- the overload is real and material
- the split can produce clearer durable owner surfaces

## Pass Steps

1. Identify the distinct promise units currently packed into one artifact.
2. Decide the right layer and scope for each resulting unit.
3. Move content into new sibling artifacts or new local targets as needed.
4. Repair refs, target IDs, and linked downstream surfaces after the split.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves an overloaded Intent surface by
  splitting it into cleaner units
- Before posture: one artifact carries too many distinct promises
- After posture: the promise units are easier to target, review, and prove
- Evidence this pass can supply:
  - split artifact surfaces
  - new or revised target IDs
  - repaired refs after the split

## Outputs

- cleaner durable promise units
- stronger downstream targeting and review surfaces

## Hand-off

- continue with the tightening pass that matches each resulting new surface

## Quality checks

- each resulting unit carries one coherent durable promise
- the split improves targeting more than it adds coordination cost
- refs and local target IDs remain inspectable after the split

## Escalation triggers

- the overload is actually unresolved scope, not artifact shape
- the split would require a missing durable decision
- the current artifact should really move to another layer instead

## Arc use

- usually invoked during `Map Arc`
- often invoked during `Shape Step` when the current target surface is too
  broad for one step

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- If the split changes stable meaning, update downstream targets explicitly.
