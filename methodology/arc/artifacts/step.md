# Step

A step defines one bounded unit in the Arc executable plan. Each step file must
follow the canonical schema in `../contracts/step-schema.md` and the lifecycle
in `../contracts/state-machine.md`.

Size a step small enough for reliable model runs and focused human review. Each
step keeps Intent, Blueprint, and Code aligned for one concrete objective and
must never exceed one `high` capability-fit load.

Step files live in `.methodologies/idd/scratch/arc/` and serve as the
run-local handoff surface between Arc planning, direct work, proof assembly,
review, and closeout. The active step always has a step file. Completed steps
keep their step files in place for the full run. Future `planned` step detail
stays in `arc.md` until the step becomes active.

A step is the transient selection of exact durable Intent targets plus the
Blueprint, Code, description, test, and decision surfaces needed to move them.

Step files are not the canonical per-claim proof store. Arc evidence lives in
`.methodologies/idd/scratch/evidence/<arc-id>/`, and each step records the
current summary and evidence references for the pass it just completed.

## Normative References

- `../contracts/state-machine.md`
- `../contracts/loop.md`
- `../contracts/step-schema.md`
- `../contracts/layer-sync-invariants.md`
- `../contracts/conflict-resolution.md`
- `../overview.md`
- `../templates/step.md`
- `../templates/proof-packet.md`
- `../../../library/overview.md`

## Operation Surface

Use this split:

- `../stages/shape-step.md` for `planned` or `blocked` step preparation
- `../stages/run-step.md` for direct work on the active step
- `../stages/prove-step.md` for proof and review assembly
- `../stages/close-step.md` for the final complete or block decision

## Naming And Ordering

- Steps are sequenced and worked in order.
- Step files begin with a zero-padded sequence: `step-01-`, `step-02-`, and so
  on.
- Use a short slug that summarizes the intended change.
- Intermediate steps discovered later may use an alphabet suffix on the step
  number.
- The active step is the lowest-numbered non-`complete` step.
- Every created step file remains part of the Arc once it exists.

## State Handling

- Allowed states are:
  - `planned`
  - `shaped`
  - `executing`
  - `proving`
  - `blocked`
  - `complete`
- A step may move only through the transitions defined in
  `../contracts/state-machine.md`.

## Required Structure

Every created step file must use the exact heading order and field names
defined in `../contracts/step-schema.md`. At minimum the step must include:

- `Metadata`
- `Step Charter`
- `Constraint Envelope`
- `Capability Fit`
- `Planned Layer Delta`
- `References`
- `Proof Target`
- `Working Record`
- `Proof Packet`
- `Review Packet`
- `Outcome`
- `Run Ledger`

Use `../templates/step.md` as the starting point for new steps and
`../templates/proof-packet.md` while the step is in `proving`.

## Working Record And Run Ledger

- `Working Record` keeps the running context for the current pass
- `Working Record` must name the Arc evidence run and the evidence threads that
  are active for the current pass
- `Proof Target` must name the exact durable `Intent targets` in scope for the
  step
- `Planned Layer Delta` and `References` must stay aligned so every non-`(none)`
  layer delta names matching touched surfaces
- `Required checks`, `Checks run`, and `Results` must stay aligned across
  success-path, negative-path, invariant or regression, and review-only
  categories
- Every `Run Ledger` entry must include:
  - `Entry ID`
  - timestamp
  - `Operation`
  - `Status before`
  - `Status after`
  - `Inputs`
  - `Changes`
  - `Checks`
  - `Evidence`
  - `Next stage`
  - `Outcome`
- `Entry ID` must use the step-local sequence `L01`, `L02`, `L03`, and so on
- `Operation` may be a workflow phase name or `direct work`
- Each methodology-owned Arc phase run that updates the step must add one
  ledger entry
- Each execution pass that performs `direct work` must add one or more ledger
  entries
- `Proof Packet` verdicts must use only:
  - `updated`
  - `unchanged-justified`
  - `not-applicable`
- `Proof Packet` must cite the Arc evidence items that support the current step
  summary
- `Outcome` decisions must use only:
  - `continue`
  - `block`
  - `complete`

## Completion Rule

`proving -> complete` is valid only when the full workflow in
`../contracts/loop.md` is represented in the step file and the final step
posture is reflected in the structured fields and ledger.
