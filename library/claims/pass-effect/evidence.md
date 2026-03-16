# Evidence Capture

Capture this claim type in the shared Arc evidence shape: claim, context or
method, observations and raw artifacts, and verdict.

## Claim

- name the canonical local pass path
- name the artifact refs materially improved by the pass
- state the before posture and after posture in concrete terms
- state the scoped target, step, or handoff the improvement serves

## Methodology References

- record the claim type folder path
- link the pass file, `arc.md`, and the relevant step refs
- link the artifact refs the pass materially changed
- link run-ledger entries or evidence items that adopted the improved result

## Method Or Context

- explain why the pass was invoked
- record whether it ran during `Map Arc`, `Shape Step`, `Run Step`, or `Prove Step`
- explain what quality weakness the pass was meant to correct

## Observations

- record the concrete before posture
- record the concrete after posture
- record what changed in the artifact or handoff quality
- record any limits on how much the pass improved the current state

## Raw Artifacts

- before and after artifact refs or diff surfaces
- the pass file itself
- supporting step summaries, review notes, or target changes

## Verdict Guidance

- `supported`: the pass materially improved the artifact and the evidence makes
  the before-and-after posture inspectable
- `mixed`: the pass improved the artifact, but material weaknesses remain
- `open`: the pass has started to shape the artifact, but the improvement is
  not yet stable enough to claim
- `incomplete`: the pass effect likely exists, but the supporting record is not
  yet inspectable enough
- `failed`: the pass did not materially improve the artifact or introduced new
  ambiguity

## Evidence Thread Rules

- create or update the evidence item in the same Arc phase that first
  materially changed the target surface
- create a new item when a different pass or a different target surface is
  being evaluated
- enrich the existing item when the same pass continues improving the same
  target surface
- do not defer first capture to `Prove Step` when the pass effect was already
  material earlier
- do not use this thread to replace target proof, verification proof, or
  overall outcome posture

## Closeout Conditions

- the pass path is explicit
- the improved artifact refs are explicit
- the before posture and after posture are explicit
- the supporting raw artifacts make the claimed improvement inspectable
