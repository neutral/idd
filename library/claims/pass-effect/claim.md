# Claim Type

Claim type name: `pass-effect`
Summary: preserve when a local pass materially improved an authored artifact or
handoff surface during the current Arc.
Why this claim matters: later review is weaker when a pass materially changed
authoring quality but the improvement survives only in a diff or in chat
history.
Primary trust question: did the named pass materially improve the artifact from
its before posture to its after posture for the current scoped work?
Default evidence kind: authoring-improvement proof thread

## Use This Claim When

- a local pass materially improved an Intent artifact, Blueprint artifact, or
  Arc step
- later proof, review, or validation would benefit from the recorded
  before-and-after posture
- the pass changed target precision, scope quality, verification posture, or
  another trust-relevant authored property

## Claim Sentence Template

- `<pass path>` materially improved `<artifact refs>` from `<before posture>`
  to `<after posture>` for `<scoped target or current step>`.

## Required Inputs

- the canonical local pass path under `.methodologies/idd/library/passes/`
- the artifact refs materially changed by the pass
- the before posture
- the after posture
- the current step or Arc context

## Update These Artifacts When

- Arc evidence should preserve how a pass materially strengthened the current
  draft
- create or update the evidence item in the same Arc phase that used the pass
- a step summary or review packet should cite the evidence item that records
  the improvement
- later proof or validation depends on the improved authored posture

## Related Claim Types

- `intent-target`
- `verification-posture`
- `outcome-posture`
