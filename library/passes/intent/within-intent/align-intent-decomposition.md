# Pass: align-intent-decomposition

## Purpose

Reconcile goals, features, scenarios, and behaviors into one clean durable
decomposition.

## Pipeline position

- `intent/within-intent`

## Strengthens

- decomposition coherence
- ownership clarity
- downstream targeting

## Creates or updates

- goal catalog entries
- feature files
- scenario files
- behavior files
- refs between those surfaces

## Use This Pass When

- the current Intent stack overlaps or skips levels
- feature, scenario, and behavior content are mixed together
- Arc or Blueprint targeting would be clearer if decomposition were cleaner

## Not for

- technical architecture decomposition
- step planning
- artificial hierarchy for its own sake

## Inputs

- current goal, feature, scenario, and behavior artifacts in the same scope
- any relevant upstream material if ownership is unclear

## Preconditions

- the current promise area is already bounded enough to organize
- the pass can tell which information belongs at which Intent level

## Pass Steps

1. Identify what belongs at goal, feature, scenario, and behavior level.
2. Move misplaced content to the narrowest durable owner.
3. Remove duplication that exists only because decomposition was weak.
4. Rebuild refs so the stack reads cleanly from top to bottom.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves the decomposition of the current
  Intent stack
- Before posture: the current stack is overlapping, uneven, or hard to target
- After posture: each layer owns the right information and links cleanly to the
  next
- Evidence this pass can supply:
  - before and after artifact structures
  - moved content across layers
  - updated refs and target surfaces

## Outputs

- a cleaner durable Intent stack
- clearer layer ownership for later work

## Hand-off

- continue with whichever tightening pass matches the now-clean owner surface

## Quality checks

- each artifact answers a distinct question
- downstream targeting no longer depends on guessing which layer owns what
- decomposition reduces duplication instead of adding it

## Escalation triggers

- the current scope is still too broad to decompose coherently
- the content belongs in Blueprint instead of Intent
- the pass would invent a hierarchy not justified by the product promise

## Arc use

- usually invoked during `Map Arc`
- sometimes invoked during `Shape Step` when weak decomposition blocks exact
  targeting

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Preserve durable content while moving it; do not hide it in transient notes.
