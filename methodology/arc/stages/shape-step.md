# Shape Step

Use this phase to turn the active step into a bounded execution-ready step.

## Use This Phase When

- the active step is `planned`
- the active step is `blocked` and is being repaired for another pass
- the active step needs to be resliced before direct work begins

## Required Inputs

- `.methodologies/idd/scratch/arc/arc.md`
- the active step file
- the Arc evidence index
- `../../../library/claims/README.md`
- `../../../library/passes/index.md` when authored quality or hand-off quality
  needs strengthening
- relevant intent, blueprint, and decision artifacts
- any code or description files already named in the active step

## Required Updates

- create the active step file from `../templates/step.md` first when it does
  not already exist
- complete the active step `Constraint Envelope`
- complete the active step `Capability Fit`
- complete the active step `Planned Layer Delta`, `References`, and
  `Proof Target`
- enumerate the exact touched artifact surfaces in `References` for every
  non-`(none)` layer listed in `Planned Layer Delta`
- set `Proof Target > Intent targets` to the exact durable promises this step
  will move
- shape `Proof Target > Required checks` into explicit success-path,
  negative-path, invariant or regression, and review-only categories
- set `Working Record > Evidence run` and `Active evidence` for the next pass
- refresh `Working Record` for the next pass
- create or update `pass-effect` evidence in the current Arc evidence run when
  a local pass materially improves step shape or target precision during this
  phase
- keep `arc.md` aligned so `Arc Status` becomes `shaped` when the step is
  ready, or remains `blocked` when the step stays blocked

## Operating Rules

- edit only the active step and `arc.md`
- do not implement product changes in this phase
- do not widen the boundary defined by `status.md`
- do not leave `Intent targets` at whole-file scope when a narrower durable
  target already exists
- do not leave any non-`(none)` layer delta without matching refs
- do not leave `Required checks` as one undifferentiated list
- if more than one capability-fit load is `high`, split the step before
  execution begins

## Recording Rules

- add one `Run Ledger` entry with `Operation: Shape Step`
- when a local pass materially changes the current run in this phase, create or
  update the corresponding `pass-effect` evidence item before leaving `Shape Step`

## Exit Conditions

- the active step ends in `shaped` with exact durable `Intent targets`
  recorded, or
- the active step remains `blocked` with the blocking reason and next action
  explicit
