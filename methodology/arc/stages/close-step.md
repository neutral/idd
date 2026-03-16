# Close Step

Use this phase to record the final `complete` or `block` posture for the active
step.

## Use This Phase When

- the active step is already in `proving`
- the final outcome is ready to be recorded
- `arc.md` must be updated to match the resulting step posture

## Required Inputs

- the active step file
- `.methodologies/idd/scratch/arc/arc.md`
- the Arc evidence run
- `../contracts/loop.md`
- `../contracts/layer-sync-invariants.md`
- `../contracts/state-machine.md`
- `../templates/proof-packet.md`

## Finalization Rules

- recheck `Proof Packet`, `Review Packet`, and `Outcome` against the
  methodology contracts
- recheck the cited Arc evidence before final block or complete closeout
- recheck that the cited proof still covers the selected `Intent targets`
- recheck that `Checks run` and `Results` still cover the shaped non-`(none)`
  check categories
- if the outcome is `block`, keep the step in place, set the step `Status` to
  `blocked`, set `Arc Status` to `blocked`, and make the next shaping or
  authority action explicit
- if the outcome is `complete`, set the step `Status` to `complete`, update the
  `Step Register` line, and set `Arc Status` to `planning` for the next step or
  `finalizing` when every step is `complete`
- if the outcome is `complete` and a next active step exists, create that step
  file immediately from the current `arc.md` step block
- do not create product edits in this phase

## Allowed Outcomes

This phase leaves the active step only in:

- `complete`
- `blocked`

## Recording Rules

- add one `Run Ledger` entry with `Operation: Close Step`

## Exit Conditions

- the final step `Status` is only `complete` or `blocked`
- `arc.md` `Step Register` and `Arc Status` match the final step posture
- the next active step file exists when a next active step remains
- the step file reflects the same final posture
