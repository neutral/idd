# Step Proof Invariants

This contract defines the non-negotiable Intent / Blueprint / Code rules for
any step that leaves `proving`.

## Invariants For Every Proved Step

- Every step must record `Proof Target > Intent targets` to name the exact
  durable Intent promises in scope.
- Every step must identify the touched product scope in `References` using:
  - `Intent refs`
  - `Blueprint refs`
  - `Code refs`
  - `Description refs`
  - `Test refs`
  - `Decision refs`
- Every step must declare its intended layer movement in `Planned Layer Delta`.
- Every non-`(none)` layer entry in `Planned Layer Delta` must have matching
  refs in `References`.
- Every step must shape `Proof Target > Required checks` by explicit
  success-path, negative-path, invariant or regression, and review-only
  categories.
- Every step in `proving`, `blocked`, or `complete` must point to the Arc
  evidence items that support the current step summary.
- Every step in `proving`, `blocked`, or `complete` must record `Intent
  verdict`, `Blueprint verdict`, and `Code verdict` in `Proof Packet`.
- Every step in `proving`, `blocked`, or `complete` must record `Checks run`
  and `Results` against the same required-check categories shaped earlier.
- Every proving pass must update `Proof Packet` and `Review Packet` before a
  final block or complete decision is recorded.

## Completion Invariants

- A step may not move from `proving` to `complete` unless every workflow phase
  in `loop.md` is represented in the step file.
- A `complete` step may not leave `Residual gaps` open.
- A touched layer marked `unchanged-justified` must remain consistent with the
  touched scope and product artifacts.
- The selected `Intent targets` must still be satisfied by the final product
  state or be explicitly recorded as blocked.
- Every touched implementation, description, or test change must be traceable
  to at least one selected `Intent target` and one relevant entry under
  `Blueprint refs`, unless the step is blocked before implementation lands.
- A `complete` step may not omit a planned non-`(none)` check category from
  `Checks run` or `Results`.
- If a conflict affected durable product truth, the reconciliation path must be
  linked from the relevant decision artifact before the step completes.
- The supporting Arc evidence must be current before the step is treated as
  `blocked` or `complete`.
- `Proof Packet`, `Review Packet`, `Outcome`, and the `Run Ledger` must reflect
  the final step posture before the step is treated as `blocked` or `complete`.

## Blocked-Step Invariants

- A blocked step must still record current proof, review, and outcome posture.
- A blocked step may leave product updates partially landed only when the proof
  and outcome explain the residual risk explicitly.

## Detecting Drift From Artifacts Alone

A reviewer must be able to detect drift from the step file and the linked
product artifacts without using chat history. At minimum:

- the touched scope is explicit,
- the exact durable `Intent targets` are explicit,
- the planned layer delta is explicit,
- each core layer has a proof verdict,
- the proof posture is recorded,
- the supporting Arc evidence can be located from the step file,
- the review packet names downstream assumptions,
- any conflict path is linked to decisions.

## Failure Conditions

Treat the proof contract as broken when any of the following is true:

- a touched layer is missing from the `Proof Packet`,
- a final step summary cites no supporting Arc evidence,
- a completed step leaves `Residual gaps` open,
- touched code-layer refs have no selected `Intent targets` or linked
  `Blueprint refs` entries,
- a durable conflict outcome exists only in Arc and not in the relevant
  decision artifact,
- the step `Proof Packet`, `Review Packet`, or `Outcome` is stale relative to
  the final decision.
