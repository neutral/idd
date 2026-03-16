# Claim Type

Claim type name: `verification-posture`
Summary: preserve what checks ran, what passed or failed, and what blind spots
remain for the Arc.
Why this claim matters: final code and final step status do not preserve the
actual boundary of trust.
Primary trust question: what verification evidence supports this Arc, and what
important limits remain?
Default evidence kind: verification-and-gap proof thread

## Use This Claim When

- the Arc defines required checks or manual review expectations
- a step runs tests, audits, builds, or review passes
- skipped or blocked checks materially limit trust in the Arc outcome

## Claim Sentence Template

- `<Arc or scoped work>` ran `<checks or reviews>`, observed `<results>`, and
  remains limited by `<blind spots or skipped verification>`.

## Required Inputs

- `arc.md`
- relevant step files
- commands, reports, review notes, or validation outputs

## Update These Artifacts When

- the Arc evidence index needs current verification coverage
- a step summary should cite the verification evidence it relied on
- final validation needs the current verification posture for closeout

## Related Claim Types

- `layer-sync`
- `residual-uncertainty`
- `outcome-posture`
