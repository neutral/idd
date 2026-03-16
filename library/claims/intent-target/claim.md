# Claim Type

Claim type name: `intent-target`
Summary: preserve what user request, Arc objective, or scoped work outcome the
Arc is serving.
Why this claim matters: later validation is weak if the Arc target is inferred
only from diffs or step names.
Primary trust question: did this Arc actually serve the stated user need or
success condition?
Default evidence kind: Arc target proof thread

## Use This Claim When

- the Arc objective is concrete enough to state
- a step narrows or redirects the scoped outcome inside the same Arc
- later review needs to distinguish the main target from nearby non-goals

## Claim Sentence Template

- `<Arc or scoped work>` serves `<user need or success condition>`, grounded by
  `<intent or blueprint refs>`, and excludes `<non-goals or limits>`.

## Required Inputs

- `.methodologies/idd/scratch/arc/arc.md`
- relevant step files
- relevant intent and blueprint refs

## Update These Artifacts When

- the Arc evidence index needs current target coverage
- a step summary should reference the target evidence it relied on
- target clarification changes the Arc completion path

## Related Claim Types

- `boundary-compliance`
- `layer-sync`
- `verification-posture`
