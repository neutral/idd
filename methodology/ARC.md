# IDD Arc

This file is the runtime entrypoint for executing IDD in an installed repo.
Arc is the executable workflow for IDD: map the full ordered step register,
shape the active step, run it, prove it, close it, and finalize the Arc only
after step proof satisfies the Arc completion rule.

## Use This File When

- starting or resuming an IDD run
- deciding which Arc phase applies next
- checking whether the run may proceed inside `status.md` boundaries
- determining when a run must return to an earlier phase

## Authoritative Here

- the runtime status gate order
- Arc integrity requirements before product work continues
- phase selection and stage routing
- recording rules for `arc.md` and active step files
- re-entry rules when proof, boundary, or plan state changes

## Next Documents

- `arc/overview.md`: Arc stage, contract, artifact, and template map
- `arc/contracts/state-machine.md`: allowed Arc and step status transitions
- `arc/contracts/loop.md`: required Arc phase order
- `arc/contracts/step-schema.md`: step-file structure and status gates
- `arc/contracts/layer-sync-invariants.md`: proof obligations across Intent,
  Blueprint, and Code
- `arc/contracts/conflict-resolution.md`: precedence and reconciliation rules
- `../library/overview.md`: runtime library entrypoint
- `../library/claims/README.md`: runtime claim catalog for Arc evidence

## Run Unit

An IDD run is one bounded Arc against one user request.

- Arc keeps its transient runtime state under `.methodologies/idd/scratch/arc/`.
- Arc evidence lives under `.methodologies/idd/scratch/evidence/<arc-id>/`.
- `arc.md` is the authoritative Arc register and control record.
- The Arc evidence folder is the canonical claim-and-evidence surface for the
  Arc.
- The active step always has a step file.
- The active step is the execution unit inside the Arc.
- Future `planned` steps stay in `arc.md` until they become the active step.
- Any step file that exists remains part of the Arc for the full run.
- Steps create or enrich Arc evidence while work is happening.
- Final Arc closeout synthesizes Arc evidence and completed step proof summaries
  against the Arc completion rule recorded in `arc.md`.

Use the `Next Documents` section above for the detailed Arc contract surfaces.

## 0) Status Gate

Read `../status.md` before any repo read or write beyond the methodology files
needed to understand the boundary contract.

Required sections:

- `Sources`
- `Operating scope`
- `Permissions`

Boundary rules:

- `Operating scope` is the intended run boundary.
- `entire-repo` uses `.` as the only in-scope root.
- `selected-paths` requires one or more repo-relative in-scope roots.
- `Permissions` are the hard read/write enforcement boundary.
- Evaluate permission matches by most specific path first.
- If a path matches no permission bucket, treat it as `no access`.
- Reads and writes outside `Operating scope` are disallowed even if a
  permission entry exists.

If `status.md` is missing required sections or the request falls outside the
effective boundary, stop and ask for setup or boundary correction before
continuing.

## 1) Arc Integrity

Apply these Arc integrity rules:

- `arc.md` must exist before product execution begins.
- Every `Step Register` line must include the required planning bullets.
- The active step must have a matching step file.
- Any step that is not `planned` must have a matching step file.
- Future `planned` steps must keep their detail in `arc.md`, not separate step
  files.
- Every step file must have a matching `Step Register` entry.
- The active step is the lowest-numbered non-`complete` step.
- Only the active step may use `shaped`, `executing`, `proving`, or `blocked`.
- Every later step must remain `planned`.
- Step files remain in place for the full Arc. Do not move completed steps into
  a different folder.

If the Arc register, step files, or status boundary disagree with these rules,
stop and correct the Arc artifacts before continuing. Drift is invalid Arc
state, not a normal workflow phase.

## 2) Phase Selection

Use this fixed phase selection order after intake and repo-state inspection:

1. If `.methodologies/idd/scratch/arc/arc.md` does not exist, or the ordered
   step register is not fully declared -> `Map Arc`
2. If every step is `complete` and Arc closeout is still open ->
   `Finalize Arc`
3. If the active step is `planned` or `blocked` -> `Shape Step`
4. If the active step is `shaped` or `executing` -> `Run Step`
5. If the active step is `proving` and the proof or review packet is still
   being assembled -> `Prove Step`
6. If the active step is `proving` and the final outcome is ready to record ->
   `Close Step`

Missing intent or blueprint anchors are handled inside `Map Arc`, `Shape Step`,
or the active step itself. They are not separate outer workflow routes.

## 3) Phase Handling

Every Arc phase is handled inside `methodology/arc/`:

- `Map Arc` -> `arc/stages/map-arc.md`
- `Shape Step` -> `arc/stages/shape-step.md`
- `Run Step` -> `arc/stages/run-step.md`
- `Prove Step` -> `arc/stages/prove-step.md`
- `Close Step` -> `arc/stages/close-step.md`
- `Finalize Arc` -> `arc/stages/finalize-arc.md`

For direct implementation work during `Run Step`, add one or more
`Operation: direct work` entries in the step `Run Ledger` and record the
evidence IDs touched by that pass.

Open `../library/overview.md` when the Arc needs reusable local help such as
pass support or claim-catalog guidance.

## 4) Recording Rules

- Keep Arc evidence current before moving past the work that made a material
  claim active, changed, or checked.
- Keep step `Proof Target > Intent targets` current and scoped to the exact
  durable promises the step is moving.
- Keep `Working Record`, `Proof Packet`, `Review Packet`, `Outcome`, and the
  `Run Ledger` current before treating a step as `blocked` or `complete`.
- Keep step proof and review packets as summaries over the current Arc
  evidence surface. Do not use them as a second per-claim proof store.
- When a local pass materially improves the current Intent, Blueprint, or step
  surface and that improvement matters to proof or review, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass. Do not defer pass-effect capture to a later phase.
- Keep `arc.md` `Step Register`, `Final Validation`, and `Closeout` aligned
  with the current Arc posture.
- Use `arc.md` `Notes` for Arc-level context that does not belong inside a
  single step.
- If the completion path changes, update future `planned` steps immediately in
  `arc.md` and keep the full ordered step register visible.

## 5) Re-entry Rules

- If the request or authority basis is ambiguous, stop and clarify before
  continuing.
- If a step fails its target-status gate, return to the last valid prior phase.
- If direct work changes the downstream completion path, update later `planned`
  steps immediately in the same pass.
- If a material claim changes and Arc evidence is stale, return to the phase
  that produced the change before continuing.
- If proof finds same-step fix-forward work, return from `Prove Step` to
  `Run Step`.
- If proof or closeout finds a blocking issue, set the active step to
  `blocked` and return to `Shape Step`.
- If finalization finds follow-up work, add new `planned` steps immediately,
  create the new active step file immediately, and return to `Shape Step` for
  the new active step.
- If a path is outside `Operating scope` or resolves to `read-only` or
  `no access` for the intended action, stop and request a boundary update
  before proceeding.
