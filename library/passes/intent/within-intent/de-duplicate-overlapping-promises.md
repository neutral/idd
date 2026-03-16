# Pass: de-duplicate-overlapping-promises

## Purpose

Remove duplicate or competing promise surfaces from the current Intent slice.

## Pipeline position

- `intent/within-intent`

## Strengthens

- promise uniqueness
- reader confidence
- downstream clarity

## Creates or updates

- any overlapping Intent artifacts in scope
- refs that should point to the surviving owner surface

## Use This Pass When

- two or more artifacts restate the same promise as if they were separate
- later readers could target different artifacts for the same commitment
- duplication is causing drift or review confusion

## Not for

- collapsing legitimately different promises
- deleting useful decomposition
- replacing one good artifact with a weaker combined one

## Inputs

- overlapping Intent artifacts
- the surrounding refs and target usage
- any linked Blueprint or Arc targets already using the surfaces

## Preconditions

- the overlap is real and material
- the pass can identify one surviving durable owner surface

## Pass Steps

1. Identify where multiple artifacts claim the same promise.
2. Pick the narrowest durable owner surface for that promise.
3. Remove or rewrite duplicate statements in the non-owner surfaces.
4. Repoint refs and targets toward the surviving owner where needed.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially removes overlapping promise surfaces
- Before posture: the same promise is represented in multiple competing places
- After posture: one clear owner surface remains and downstream targeting is
  cleaner
- Evidence this pass can supply:
  - before and after overlapping artifacts
  - removed duplicate language
  - updated refs to the surviving owner

## Outputs

- less duplicated promise content
- stronger confidence in which surface is authoritative

## Hand-off

- continue with `align-intent-decomposition` or
  `stabilize-intent-traceability`

## Quality checks

- only real duplication was removed
- the surviving owner is the best durable layer
- downstream targets can no longer select the wrong duplicate

## Escalation triggers

- the overlap reveals a missing decomposition change instead
- both surfaces still carry distinct durable value
- removing duplication would erase useful context that belongs elsewhere

## Arc use

- usually invoked during `Map Arc`
- sometimes invoked during `Shape Step` when overlapping Intent is blocking
  exact targeting

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Preserve useful context while removing competing promise ownership.
