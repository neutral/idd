# Arc Step Schema

This contract defines the canonical shape of every Arc step file. Headings,
field names, and enumerated values are normative. It applies to every step file
that exists. Future `planned` steps stay in `arc.md` until they become active.

## Required Heading Order

Every created step file must contain these headings in this exact order:

1. `Metadata`
2. `Step Charter`
3. `Constraint Envelope`
4. `Capability Fit`
5. `Planned Layer Delta`
6. `References`
7. `Proof Target`
8. `Working Record`
9. `Proof Packet`
10. `Review Packet`
11. `Outcome`
12. `Run Ledger`

## Required Field Names

### `Metadata`

- `Step ID`
- `Title`
- `Status`
- `Owner`
- `Created at`
- `Updated at`

### `Step Charter`

- `Goal`
- `Done when`
- `Depends on`
- `Unlocks`

### `Constraint Envelope`

- `Write scope`
- `Read-only scope`
- `Forbidden scope`
- `Authority limits`
- `External dependency posture`
- `Escalation triggers`

### `Capability Fit`

- `Context load`
- `Novelty load`
- `Proof load`
- `Edit breadth`
- `Review burden`
- `Sizing rationale`

### `Planned Layer Delta`

- `Intent`
- `Blueprint`
- `Code`
- `Descriptions`
- `Tests`

### `References`

- `Intent refs`
- `Blueprint refs`
- `Code refs`
- `Description refs`
- `Test refs`
- `Decision refs`

### `Proof Target`

- `Intent targets`
- `Required checks`
- `Required evidence`
- `Closure conditions`
- `Failure triggers`

### `Working Record`

- `Evidence run`
- `Active evidence`
- `Current posture`
- `Execution notes`
- `Open questions`

### `Proof Packet`

- `Evidence refs`
- `Checks run`
- `Results`
- `Intent verdict`
- `Blueprint verdict`
- `Code verdict`
- `Residual gaps`
- `Conflict and authority handling`

### `Review Packet`

- `Change summary`
- `Artifacts changed`
- `Reviewer focus`
- `Downstream assumptions`
- `Handoff summary`

### `Outcome`

- `Decision`
- `Reason`
- `Next action`
- `Step summary`

## Machine-Checkable Intent Target Format

Under `Proof Target > Intent targets`, each item must be one backticked durable
Intent target ID:

- `goal/...`
- `assurance/...`
- `feature/...#<kebab-case-outcome-id>`
- `scenario/...#<kebab-case-check-id>`
- `behavior/...#<kebab-case-check-id>`

Examples:

- `` `goal/system/account-trust` ``
- `` `assurance/system/traceability` ``
- `` `feature/checkout/cart#cart-contract-preserved` ``
- `` `scenario/checkout/guest-cart#recalculate-before-response` ``
- `` `behavior/checkout/cart-recalculation#validate-request-model` ``

Use one target per bullet. Do not use prose in the same bullet.

## Machine-Checkable Path Item Format

Under `Constraint Envelope` and `References`, each path item the verifier checks
must use one of these shapes:

- one repo-relative backticked path, optionally followed by prose
- `(none)` as the full item when that category is not applicable

Examples:

- `` `intents/system/profile-display-name/feature.md` - feature requirement ``
- `` `src/display_name.py` - validator implementation ``
- `` `src/_display_name.py.desc.md` - description file ``
- `` `tests/test_display_name.py` - test coverage ``
- `` `src/checkout/` - active write scope ``
- `(none)`

The verifier resolves only the leading backticked path token and ignores any
prose that follows it.

## Planned Layer Delta And Reference Alignment

Every `Planned Layer Delta` field must be populated. Use `(none)` when the step
does not plan to move that layer.

Any non-`(none)` layer delta must have matching refs in `References`:

- `Intent` -> `Intent refs`
- `Blueprint` -> `Blueprint refs`
- `Code` -> `Code refs`
- `Descriptions` -> `Description refs`
- `Tests` -> `Test refs`

`References` may still include read-only supporting surfaces for layers whose
delta stays `(none)`.

## Required Check Shape

Under `Proof Target > Required checks`, use these fields in this order:

- `Success-path checks`
- `Negative-path checks`
- `Invariant or regression checks`
- `Review-only checks`

Each field must contain one or more nested bullets or the literal marker
`(none)`.

Use `(none)` only when that category genuinely does not apply to the current
step.

## Proof Reporting Shape

Under `Proof Packet > Checks run` and `Proof Packet > Results`, use the same
fields in the same order:

- `Success-path checks`
- `Negative-path checks`
- `Invariant or regression checks`
- `Review-only checks`

For `planned`, `shaped`, or `executing` steps, use `(not yet run)` placeholders
where needed.

Once proof begins, report checks and results against the same categories shaped
under `Proof Target > Required checks`.

## Allowed Values

- `Status`:
  - `planned`
  - `shaped`
  - `executing`
  - `proving`
  - `blocked`
  - `complete`
- `Owner`:
  - `user`
  - `agent`
  - `shared`
- `Capability Fit` load fields:
  - `low`
  - `medium`
  - `high`
- `External dependency posture`:
  - `none`
  - `existing-approved`
  - `needs-user-input`
- `Proof Packet` verdict values:
  - `updated`
  - `unchanged-justified`
  - `not-applicable`
- `Outcome` values:
  - `continue`
  - `block`
  - `complete`

## Capability-Fit Rule

The first five `Capability Fit` fields describe the shape of the step:

- `Context load`
- `Novelty load`
- `Proof load`
- `Edit breadth`
- `Review burden`

A step is invalid if more than one of those fields uses `high`. Split the step
instead.

## Run Ledger Contract

Every `Run Ledger` entry must record:

- `Entry ID`,
- timestamp in ISO 8601 UTC,
- `Operation`,
- `Status before`,
- `Status after`,
- `Inputs`,
- `Changes`,
- `Checks`,
- `Evidence`,
- `Next stage`,
- `Outcome`.

Use this line shape:

`- <entry-id> | <timestamp> | Operation: <workflow stage or direct work> | Status before: <status> | Status after: <status> | Inputs: <summary or none> | Changes: <summary or none> | Checks: <summary or none> | Evidence: <evidence IDs or none> | Next stage: <stage> | Outcome: <summary>`

`Entry ID` must use the step-local sequence `L01`, `L02`, `L03`, and so on.
IDs must be unique and increment by one within the step file.

`Operation` may be a workflow phase name or `direct work`.

If a concise line is not enough, add a following indented detail line.

## Minimum Ledger Policy

- Add one ledger entry for each methodology-owned Arc phase run that updates the
  step.
- Add one or more `Operation: direct work` entries for each execution pass that
  changes product artifacts or materially changes execution posture.
- The final current-pass transition to `blocked` or `complete` must appear in
  the ledger.
- No step status transition may occur without a corresponding ledger entry.

## Status Gates

### `planned`

- Canonical headings and metadata fields exist.
- `Step Charter`, `Constraint Envelope`, `Capability Fit`,
  `Planned Layer Delta`, `References`, and `Proof Target` are populated.
- `Proof Target > Intent targets` names the exact durable Intent promises in
  scope for the step.
- `Proof Target > Required checks` is shaped by explicit success-path,
  negative-path, invariant or regression, and review-only categories.
- `Status` is `planned`.

### `shaped`

- `planned` gate is satisfied.
- The step is the active step.
- The exact durable Intent promises in scope are explicit.
- `Working Record` is current enough to begin direct work.
- `Evidence run` points to the Arc evidence folder.
- No more than one capability-fit load is `high`.
- `Status` is `shaped`.

### `executing`

- `shaped` gate is satisfied.
- `Run Ledger` records the current execution pass.
- `Status` is `executing`.

### `proving`

- `executing` gate is satisfied.
- `Proof Packet`, `Review Packet`, and `Run Ledger` reflect the current pass.
- `Proof Packet` cites the Arc evidence items that support the current summary.
- `Status` is `proving`.

### `blocked`

- `Outcome` uses `block`.
- The blocking reason and next action are explicit.
- `Status` is `blocked`.

### `complete`

- Prior status was `proving`.
- `Outcome` uses `complete`.
- `Proof Packet` satisfies `layer-sync-invariants.md`.
- `Proof Packet > Checks run` and `Results` still cover the planned non-`(none)`
  check categories.
- The cited proof still matches the selected `Intent targets`.
- `Review Packet`, `Outcome`, and `Run Ledger` reflect the final posture.
- The final step summary points to the supporting Arc evidence.
- `Status` is `complete`.
