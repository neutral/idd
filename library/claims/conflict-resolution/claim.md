# Claim Type

Claim type name: `conflict-resolution`
Summary: preserve how disagreement across user direction, Intent, Blueprint,
Code, or decisions was resolved or deferred during the Arc.
Why this claim matters: later trust depends on whether the Arc handled
conflicts explicitly rather than silently favoring one source.
Primary trust question: can a later reader inspect how the Arc resolved or
deferred a real conflict?
Default evidence kind: conflict-resolution proof thread

## Use This Claim When

- user direction and artifacts disagree materially
- intent, blueprint, code, or decisions conflict in a way that changes the Arc
- final validation needs an inspectable reconciliation path

## Claim Sentence Template

- `<Arc or scoped work>` found `<conflict>`, resolved it by `<reconciliation
  action>`, and left `<remaining open point>` as `<deferred or closed>`.

## Required Inputs

- `arc.md`
- relevant step files
- the conflicting sources and any decision refs

## Update These Artifacts When

- the Arc evidence index needs current conflict coverage
- a step proof summary should cite the conflict evidence it relied on
- a durable conflict outcome must be copied into a decision artifact

## Related Claim Types

- `authority-basis`
- `layer-sync`
- `residual-uncertainty`
