# Claim Type

Claim type name: `authority-basis`
Summary: preserve which source, owner, or prior decision the Arc treated as
authoritative when interpretation mattered.
Why this claim matters: later consistency depends on knowing why one source won
over nearby alternatives.
Primary trust question: can a later reader inspect which authority basis
controlled the Arc and why?
Default evidence kind: authority-resolution proof thread

## Use This Claim When

- the Arc chooses among competing sources or definitions
- a step relies on a decision artifact or owner direction to proceed
- later validation would otherwise have to guess why one source was treated as
  canonical

## Claim Sentence Template

- `<Arc or scoped work>` treated `<source, owner, or decision>` as
  authoritative for `<question>`, and applied that choice to `<affected refs>`.

## Required Inputs

- `arc.md`
- relevant step files
- the sources, decisions, or owner guidance in question

## Update These Artifacts When

- the Arc evidence index needs current authority coverage
- a step summary should cite the authority evidence it relied on
- a durable authority choice must be copied into a decision artifact

## Related Claim Types

- `conflict-resolution`
- `boundary-compliance`
- `governance-ownership`
