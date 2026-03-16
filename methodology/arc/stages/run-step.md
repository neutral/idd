# Run Step

Use this phase for direct implementation work on the active step.

## Use This Phase When

- the active step is `shaped`
- the active step is already `executing`

## Required Inputs

- `.methodologies/idd/scratch/arc/arc.md`
- the active step file
- the Arc evidence run
- the product artifacts named in the active step `References`
- any local library guidance that materially helps the current pass

## Required Updates

- update product artifacts for the current pass
- create or enrich Arc evidence as material claims appear or change
- keep the active step `Working Record` current
- record direct work in the active step `Run Ledger`
- update later `planned` steps immediately if the downstream completion path
  changes
- keep direct work and evidence scoped to the selected `Intent targets`
- create or update `pass-effect` evidence in the current Arc evidence run when
  a local pass materially improves the current Intent, Blueprint, or step
  surface during this phase
- keep `arc.md` aligned so `Arc Status` matches the active step posture

## Operating Rules

- direct work must use one or more `Run Ledger` entries with
  `Operation: direct work`
- every execution pass must record the evidence IDs it created or updated
- move the active step to `executing` before product edits land if it is still
  `shaped`
- when a pass pauses for proof assembly, move the active step to `proving`
- when a local pass materially changes the current run in this phase, create or
  update the corresponding `pass-effect` evidence item before leaving `Run Step`
- if a blocking issue is discovered, record it and move the active step to
  `blocked`

## Exit Conditions

- the active step ends in `executing`, `proving`, or `blocked`
- the active step file reflects the latest execution posture
