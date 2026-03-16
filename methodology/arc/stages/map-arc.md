# Map Arc

Use this phase to create or refresh the Arc register and the full ordered step
register.

## Use This Phase When

- no active Arc exists yet
- `arc.md` does not exist yet
- the ordered step register is incomplete
- future `planned` steps need to be inserted or rewritten deliberately

## Required Inputs

- `.methodologies/idd/status.md`
- `.methodologies/idd/scratch/arc/arc.md` when it already exists
- `.methodologies/idd/scratch/evidence/<arc-id>/index.md` when it already
  exists
- any existing step files under `.methodologies/idd/scratch/arc/`
- the current branch name
- `../../../library/passes/index.md` when upstream or Intent-shaping help is
  needed
- enough context to state the request served, success condition, completion
  rule, and full ordered step register

## Required Updates

- create or normalize `.methodologies/idd/scratch/arc/arc.md`
- initialize or normalize the Arc evidence run once the Arc ID is stable
- create or normalize the active step file
- keep every future step in `planned`
- make every `Step Register` line carry the mandatory planning bullets
- make every existing step file agree with the register on step identity and
  status
- make the active step file name the initial exact durable `Intent targets`
  when the slice is already known
- create or update `pass-effect` evidence in the current Arc evidence run when
  a local pass materially improves Arc structure or durable targeting during
  this phase
- keep `arc.md` in `planning` unless the active step is already `shaped`,
  `executing`, `proving`, or `blocked`

## Operating Rules

- edit only `arc.md`, step files in `.methodologies/idd/scratch/arc/`, and the
  Arc evidence run
- do not execute product changes in this phase
- do not leave the active step without a matching step file
- when a new future step is added, insert it into the register immediately
- keep future-step enrichment in the matching `arc.md` block until that step
  becomes active

## Recording Rules

- when a step file is created or materially updated in this phase, add one
  `Run Ledger` entry with `Operation: Map Arc`
- when a local pass materially changes the current run in this phase, create or
  update the corresponding `pass-effect` evidence item before leaving `Map Arc`
- when no step exists yet, record the phase result in `arc.md` `Notes`

## Exit Conditions

- `arc.md` contains the full ordered step register
- the active step file exists and matches the register
- the active step is `planned`, or the Arc is already in a later valid phase
