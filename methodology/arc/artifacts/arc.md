# Arc — package of work

Each Arc captures one bounded implementation request as an executable plan.
Arcs keep Intent, Blueprint, and Code moving forward together for the same user
need while preserving a full ordered completion path from the start of the run
through final closeout.

Arc files are stored in `.methodologies/idd/scratch/arc/`. Each working branch
contains at most one Arc in progress. Arc evidence lives in
`.methodologies/idd/scratch/evidence/<arc-id>/`. Both are transient branch-
scoped run state governed by `../../structure/archival.md`.

Each Arc is split into one or more sequentially numbered steps. Every step is
declared from the beginning of the Arc in `arc.md`, every later step remains
visible while it is still `planned`, and only one active step may move beyond
`planned` at a time. The active step always has a step file. Later `planned`
steps stay in `arc.md` until they become active.

Arc Folder Organization:
`arc.md` contains the Arc register. Active and completed step files remain
beside it. Arc evidence stays in the sibling evidence folder. If temporary
notes are needed, keep them in the shared `.methodologies/idd/scratch/` area.

```text
.methodologies/idd/scratch/arc/
  arc.md
  step-01-insert-offer-slot.md
  step-02-integrate-pricing-api.md
.methodologies/idd/scratch/evidence/<arc-id>/
  index.md
  E001-intent-target-arc-objective.md
```

Developers and agents use Arc operations, Arc evidence, step files, and
Intent/Blueprint/Code artifacts to transform the codebase to its next state
without relying on freeform chat.

## Normative References

- `../contracts/state-machine.md`
- `../contracts/loop.md`
- `../contracts/step-schema.md`
- `../contracts/conflict-resolution.md`
- `../overview.md`
- `../../../library/overview.md`

## Operation Surface

Use the methodology-owned Arc phases under `../../arc/` for the built-in Arc
workflow:

- `../stages/map-arc.md` for initial or deliberate Arc planning passes
- `../stages/shape-step.md` for active-step preparation or blocked-step repair
- `../stages/run-step.md` for direct work on the active step
- `../stages/prove-step.md` for proof and review assembly
- `../stages/close-step.md` for final active-step close or block decisions
- `../stages/finalize-arc.md` for final Arc proof synthesis and closeout

Use `../../../library/overview.md` and `../../../library/claims/README.md` when
the Arc needs the claim catalog or other reusable local library guidance.

## Arc Register Contract

`arc.md` is the Arc register artifact and must include these sections:

- `Metadata`
- `Arc Objective`
- `Completion Rule`
- `Step Register`
- `Final Validation`
- `Closeout`
- `Notes`

### Metadata

`Metadata` must include:

- `Arc ID`
- `Branch`
- `Arc Status`
- `Updated at`

Allowed `Arc Status` values are:

- `planning`
- `shaped`
- `executing`
- `proving`
- `blocked`
- `finalizing`
- `complete`

### Arc Objective

`Arc Objective` must include:

- `Request served`
- `Success condition`

### Completion Rule

`Completion Rule` must include:

- `Completion standard`
- `Required step proof coverage`
- `Failure posture`

### Step Register

Use one deterministic line per step in this shape:

`- <step-id> | Title: <title> | Status: <status> | Depends on: <step-id or (none)> | Unlocks: <step-id list or (none)> | Done when: <end condition>`

Immediately under each step line, include these required bullets in this order:

- `Goal: <concise objective>`
- `Constraint envelope: <write/read/forbidden/authority summary>`
- `Planned layer delta: <Intent/Blueprint/Code/Descriptions/Tests summary>`
- `Proof target: <checks/evidence/closure summary>`
- `Capability fit: Context <low|medium|high>; Novelty <low|medium|high>; Proof <low|medium|high>; Edit breadth <low|medium|high>; Review burden <low|medium|high>; Rationale <summary>`

After the required bullets, the step block may include short additional
indented notes or bullets when future-step detail needs to be clarified before
the step becomes active.

The `Step Register` is the authoritative ordered plan for the Arc. Its line
order must match step ordering. Every declared step must carry the mandatory
planning bullets. The active step must have a matching step file, and any step
that is not `planned` must have a matching step file. Future `planned` step
detail stays in the step's `arc.md` block until that step becomes active.

Use `Unlocks` with a comma-separated list of later step IDs or `(none)`.

### Final Validation

`Final Validation` must include:

- `Validation status`
- `Checks run`
- `Proof synthesis`
- `Outstanding gaps`
- `Follow-up action`

Use `Final Validation` to synthesize the Arc evidence run and completed step
proof packets against the Arc `Completion Rule`.

### Closeout

`Closeout` must include:

- `Arc outcome`
- `Carry-forward obligations`
- `Reset and retention`

Use `Closeout` for the final Arc outcome, any carry-forward obligations, and a
brief note about the branch-local Arc retention posture if the repo maintainer
wants one recorded.

`Arc Status: complete` is valid only after every step in the `Step Register` is
`complete`, `Final Validation` has passed, and `Closeout` records
`Arc outcome: complete`.
