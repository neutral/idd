# Prove Step

Use this phase to assemble proof and review material for the active step.

## Use This Phase When

- the active step is already in `proving`
- an execution pass is ready to be evaluated for completion or fix-forward work

## Required Inputs

- `.methodologies/idd/scratch/arc/arc.md`
- the active step file
- the Arc evidence run
- the artifacts named in the active step `References`
- `../contracts/loop.md`
- `../contracts/layer-sync-invariants.md`
- `../contracts/conflict-resolution.md`
- `../templates/proof-packet.md`

## Required Updates

- refresh the active step `Proof Packet`
- refresh the active step `Review Packet`
- update Arc evidence verdicts for the current pass
- prove the current pass against the selected `Intent targets`
- record `Checks run` against the shaped success-path, negative-path,
  invariant or regression, and review-only categories
- record `Results` against those same categories
- update `Outcome` so the next phase is clear
- record any conflict handling or authority posture needed for the current pass
- create or update `pass-effect` evidence in the current Arc evidence run when
  a local pass materially improves the current Intent, Blueprint, or step
  surface during this phase
- keep `arc.md` aligned so `Arc Status` remains `proving`, returns to
  `executing`, or moves to `blocked`

## Allowed Outcomes

- `proving` when the proof packet is ready for final closeout
- `executing` when same-step fix-forward work is required
- `blocked` when the current step cannot proceed without new input or authority

## Recording Rules

- add one `Run Ledger` entry with `Operation: Prove Step`
- when a local pass materially changes the current run in this phase, create or
  update the corresponding `pass-effect` evidence item before leaving `Prove Step`

## Exit Conditions

- the active step ends only in `proving`, `executing`, or `blocked`
- the step file reflects the proof and review posture for the current pass
