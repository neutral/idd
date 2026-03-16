# Arc State Machine

This contract is normative for Arc and step lifecycle handling in IDD.
`ARC.md`, `arc.md`, and step files must not invent alternate status names or
transitions.

## Global Rules

- Arc `Status` applies only to `arc.md`.
- Step `Status` is declared in `arc.md` and, when a step file exists, must
  match that step file.
- Every step is declared in `arc.md` before execution begins.
- The active step always has a step file.
- Any step that is not `planned` has a step file.
- Later `planned` steps keep their detail in `arc.md` until they become active.
- The active step is the lowest-numbered non-`complete` step.
- Only the active step may be `shaped`, `executing`, `proving`, or `blocked`.
- Every later step remains `planned`.
- Completed steps stay in place for the full Arc.
- `finalizing` covers Arc-wide proof synthesis after every step is `complete`
  and before closeout is complete.

## Step Status Vocabulary

### Step `planned`

- Meaning: the step is declared in the ordered plan and carries its minimum
  execution contract, but direct work has not started.
- Entry criteria:
  - the `Step Register` line and mandatory planning bullets are complete,
  - if a step file exists, its `planned` gate is satisfied,
  - if the step is active, the step file exists.
- Exit criteria: the step is shaped for execution.
- Allowed transitions:
  - `planned -> shaped`

### Step `shaped`

- Meaning: the active step is bounded for execution.
- Entry criteria:
  - the step satisfies the shaped gate in `step-schema.md`,
  - the step is the active step.
- Exit criteria: direct work begins or the step is blocked.
- Allowed transitions:
  - `shaped -> executing`
  - `shaped -> blocked`

### Step `executing`

- Meaning: the active step is currently landing changes.
- Entry criteria:
  - the step satisfies the executing gate in `step-schema.md`,
  - the current pass is recorded in `Run Ledger`.
- Exit criteria: the pass moves to proof assembly or becomes blocked.
- Allowed transitions:
  - `executing -> proving`
  - `executing -> blocked`

### Step `proving`

- Meaning: the active step is assembling proof and review material for the
  current pass.
- Entry criteria:
  - the execution pass is recorded,
  - `Proof Packet` and `Review Packet` reflect the current proof posture.
- Exit criteria: the step returns to direct work, becomes blocked, or completes.
- Allowed transitions:
  - `proving -> executing`
  - `proving -> blocked`
  - `proving -> complete`

### Step `blocked`

- Meaning: the active step cannot proceed until new input, authority, or plan
  shaping resolves the block.
- Entry criteria:
  - `Outcome` uses `Decision: block`,
  - the blocking reason and next action are explicit.
- Exit criteria: the step is reshaped for execution.
- Allowed transitions:
  - `blocked -> shaped`

### Step `complete`

- Meaning: the step is complete for the Arc and its proof and review packet are
  final.
- Entry criteria:
  - prior status is `proving`,
  - every workflow phase in `loop.md` is represented,
  - `Outcome` uses `Decision: complete`,
  - `Proof Packet`, `Review Packet`, and `Run Ledger` reflect the final
    posture.
- Exit criteria: none. `complete` is terminal.
- Allowed transitions: none

## Arc Status Vocabulary

### Arc `planning`

- Meaning: the Arc register is being created or the next active step remains
  `planned`.
- Entry criteria:
  - `arc.md` exists with the ordered step register,
  - the active step is `planned`, and
  - the active step file exists.
- Exit criteria: the active step becomes `shaped`.
- Allowed transitions:
  - `planning -> shaped`

### Arc `shaped`

- Meaning: the active step is bounded and ready to execute.
- Entry criteria: the active step is `shaped`.
- Exit criteria: direct work begins or the step is blocked.
- Allowed transitions:
  - `shaped -> executing`
  - `shaped -> blocked`

### Arc `executing`

- Meaning: the active step is landing changes.
- Entry criteria: the active step is `executing`.
- Exit criteria: the active step moves to proof or becomes blocked.
- Allowed transitions:
  - `executing -> proving`
  - `executing -> blocked`

### Arc `proving`

- Meaning: the active step is assembling proof and review material.
- Entry criteria: the active step is `proving`.
- Exit criteria: the active step returns to execution, becomes blocked, closes,
  or the Arc enters finalization.
- Allowed transitions:
  - `proving -> executing`
  - `proving -> blocked`
  - `proving -> planning`
  - `proving -> finalizing`

### Arc `blocked`

- Meaning: the active step is blocked and needs reshaping before execution can
  continue.
- Entry criteria: the active step is `blocked`.
- Exit criteria: the active step is reshaped.
- Allowed transitions:
  - `blocked -> shaped`

### Arc `finalizing`

- Meaning: every step is `complete` and the Arc is synthesizing step proof
  against the Arc completion rule.
- Entry criteria:
  - every step in the `Step Register` is `complete`,
  - `Final Validation` is still open.
- Exit criteria: follow-up work is added and the Arc returns to `planning`, or
  final closeout completes.
- Allowed transitions:
  - `finalizing -> planning`
  - `finalizing -> complete`

### Arc `complete`

- Meaning: the Arc is complete and remains only as non-durable branch-local
  runtime state unless the repo maintainer handles that branch history
  differently.
- Entry criteria:
  - prior status is `finalizing`,
  - `Final Validation` passed,
  - `Closeout` records `Arc outcome: complete`.
- Exit criteria: none. `complete` is terminal.
- Allowed transitions: none

## Transition Triggers

- `planned -> shaped`: shaping satisfies the active-step gate.
- `shaped -> executing`: direct work begins.
- `executing -> proving`: the current pass stops for proof assembly.
- `proving -> executing`: proof finds same-step fix-forward work.
- `proving -> blocked`: proof or closeout finds a blocking issue.
- `proving -> complete`: closeout records a complete step.
- `blocked -> shaped`: the step is reshaped after the blocking issue is
  resolved.
- `proving -> planning`: a step completes and the next active step remains
  `planned`.
- `proving -> finalizing`: the final step completes.
- `finalizing -> planning`: finalization adds new planned follow-up work.
- `finalizing -> complete`: final validation passes and closeout is complete.
