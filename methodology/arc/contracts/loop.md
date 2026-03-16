# Arc Workflow Contract

This contract defines the fixed Arc workflow. A step may revisit earlier phases
where the contract allows it, but it may not skip required phases or complete
without the required proof and review artifacts.

## Ordered Phases

1. `Map Arc`
2. `Shape Step`
3. `Run Step`
4. `Prove Step`
5. `Close Step`
6. `Finalize Arc`

## Phase Mapping

| Phase | Artifact surface | Required output |
| --- | --- | --- |
| `Map Arc` | `arc.md`, active step file, Arc evidence index | full ordered step register and Arc evidence surface declared up front |
| `Shape Step` | active step `Step Charter` through `Proof Target`, `Working Record`, Arc evidence index | bounded active step ready for execution |
| `Run Step` | active step `Working Record`, `Run Ledger`, Arc evidence run, product artifacts | direct work recorded against the active step and Arc evidence |
| `Prove Step` | active step `Proof Packet`, `Review Packet`, `Outcome`, Arc evidence run | proof and review posture for the current pass |
| `Close Step` | active step `Outcome`, `Run Ledger`, `arc.md` `Step Register`, Arc evidence run | final `complete` or `blocked` posture recorded |
| `Finalize Arc` | `arc.md` `Final Validation` and `Closeout`, Arc evidence run | Arc proof synthesis and final outcome |

## Phase Rules

### Map Arc

- Must create the full ordered step register before execution begins.
- Must keep `arc.md` authoritative whenever future `planned` steps are adjusted
  or newly inserted.
- Must initialize the Arc evidence run once the Arc ID is stable.
- Must create the active step file before leaving the phase.
- Must not execute product changes.

### Shape Step

- Must shape only the active step.
- May update later `planned` steps when the completion path is improved.
- Must create the active step file first if it does not already exist.
- Must enforce capability-fit sizing before direct work starts.
- Must not widen the `status.md` boundary.

### Run Step

- Must record what changed in the current pass.
- Must record the concrete inputs used for the change.
- Must use one or more `Run Ledger` entries for `direct work`.
- Must create or enrich Arc evidence before moving past a material claim
  change.
- May update later `planned` steps when execution changes the downstream plan.

### Prove Step

- Must assemble `Proof Packet` and `Review Packet` for the current pass.
- Must update Arc evidence verdicts before treating the step summary as final.
- Must record failures, residual gaps, and conflict handling.
- Must route the step back to `Run Step`, to `blocked`, or to final closeout.

### Close Step

- Must use only `continue`, `block`, or `complete` in `Outcome`.
- Must use `block` when the step leaves the workflow blocked.
- Must use `complete` only when the proof and review material are final.
- Must update `arc.md` `Step Register` and `Arc Status` to match the resulting
  posture.
- If a step completes and a new active step exists, that new active step must
  have a step file before the phase ends.

### Finalize Arc

- Must begin only when every step in the `Step Register` is `complete`.
- Must synthesize the Arc evidence run and completed step proof packets against
  the Arc `Completion Rule`.
- Must add new `planned` follow-up steps immediately if the Arc is not ready to
  close.
- Must create the new active step file immediately when follow-up work returns
  the Arc to execution.
- Must set `Arc Status: complete` only after final proof passes and closeout is
  complete.

## Valid Step Completion Path

`proving -> complete` is valid only when:

- all required workflow phases are represented,
- `Proof Packet` satisfies `layer-sync-invariants.md`,
- `Proof Packet` cites the relevant Arc evidence items,
- `Review Packet` is complete,
- `Outcome` uses `complete`,
- `arc.md` has been updated to reflect the new step posture.

If the completed step is not the last open step in the Arc, `arc.md` must
return to `planning`, not `complete`.

## Arc Continuation After The Final Step

When every step in the `Step Register` is `complete`, the Arc still has one
required Arc-level phase left:

1. `Finalize Arc`

`Finalize Arc` must:

- review the Arc evidence run,
- review the completed step proof packets,
- evaluate them against the Arc `Completion Rule`,
- record any outstanding gaps or follow-up work,
- return the Arc to `planning` if more work is required.

## Re-entry Rules

- If execution changes the downstream completion path, update later `planned`
  steps immediately.
- If proof reveals fix-forward work inside the same step, return from
  `proving` to `executing`.
- If proof reveals a blocking condition, move to `blocked` and record the
  reason before reshaping the step.
