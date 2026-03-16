# Claim Type

Claim type name: `layer-sync`
Summary: preserve whether Intent, Blueprint, and Code stayed aligned across the
Arc or were explicitly unchanged with rationale.
Why this claim matters: IDD loses its core value if one layer silently drifts
while another changes.
Primary trust question: did the Arc leave the touched layers synchronized, or
explicitly record why one stayed unchanged?
Default evidence kind: cross-layer alignment proof thread

## Use This Claim When

- the Arc updates or validates multiple IDD layers
- a layer stays unchanged and needs explicit rationale
- final validation must judge whether touched scope stayed aligned

## Claim Sentence Template

- `<Arc or scoped work>` kept `<intent refs>`, `<blueprint refs>`, and `<code
  or description refs>` aligned for `<scope>`, with `<unchanged or deferred
  rationale>` where applicable.

## Required Inputs

- `arc.md`
- relevant step files
- touched intent, blueprint, code, test, and description refs

## Update These Artifacts When

- the Arc evidence index needs current layer-sync coverage
- a step proof summary should cite the layer-sync evidence it relied on
- final validation needs the final alignment posture for closeout

## Related Claim Types

- `intent-target`
- `verification-posture`
- `conflict-resolution`
