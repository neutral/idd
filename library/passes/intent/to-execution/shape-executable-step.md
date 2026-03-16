# Pass: shape-executable-step

## Purpose

Turn a vague Arc step into a bounded, exact-target, evidence-ready,
execution-safe step.

## Pipeline position

- `intent/to-execution`

## Strengthens

- execution readiness
- target precision
- proof readiness
- step safety

## Creates or updates

- the active step file under `.methodologies/idd/scratch/arc/`
- `.methodologies/idd/scratch/arc/arc.md` when step-register detail changes
- nearby Intent or Blueprint refs only when exact targeting must be repaired

## Use This Pass When

- the active step goal is still broad or implicit
- `Proof Target > Intent targets` are missing, vague, or too broad
- the step mixes multiple kinds of work without a clear bounded slice
- the step does not yet define concrete checks, evidence, or closeout

## Not for

- direct implementation work
- replacing Arc phase sequencing
- durable product redesign outside the current step need

## Inputs

- the active step file
- `.methodologies/idd/scratch/arc/arc.md`
- `.methodologies/idd/status.md`
- the Intent and Blueprint artifacts named by the step

## Preconditions

- the active step has been identified
- the relevant Intent and Blueprint surfaces can be opened
- the current write boundary is known from `status.md`

## Pass Steps

1. Restate the step `Goal` and `Done when` so they describe one bounded
   completed outcome.
2. Replace whole-area scope with the exact durable `Intent targets` the step
   will move.
3. Align `References` and `Planned Layer Delta` to those targets so every
   affected Intent, Blueprint, Code, description, and test surface is named
   explicitly.
4. Tighten `Constraint Envelope` to the smallest write scope and read scope
   that still lets the step land cleanly.
5. Re-evaluate `Capability Fit` and shrink the step until no more than one
   load remains `high`.
6. Rewrite `Required checks` into explicit success-path, negative-path,
   invariant or regression, and review-only categories.
7. Rewrite `Required evidence`, `Closure conditions`, and `Failure triggers`
   so proof can be assembled without guesswork.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves the active step's execution
  readiness
- Before posture: the step is broad, weakly targeted, or poor proof posture
- After posture: the step is bounded, exact-target, and evidence-ready
- Evidence this pass can supply:
  - updated step fields and target surfaces
  - before and after step posture
  - narrowed scope and clearer proof structure

## Outputs

- a step that names the exact durable `Intent targets` it serves
- a step that names every affected artifact surface for each moved layer
- a bounded constraint envelope aligned to the current scope and permissions
- proof targets, checks, and closeout criteria that match the intended slice

## Hand-off

- continue with `Run Step` or use `split-overloaded-step` if one clean slice
  still does not fit

## Quality checks

- the step serves one coherent slice of work
- every touched code, description, and test surface is justified by the named
  `Intent targets` and supporting `Blueprint refs`
- non-`(none)` layer deltas and matching refs agree on the affected surfaces
- required checks are split across success-path, negative-path, invariant or
  regression, and review-only categories
- `Done when`, `Closure conditions`, and `Failure triggers` are observable and
  specific
- the write scope is narrow enough that the step could be reviewed as one pass
- no more than one capability-fit load is `high`

## Escalation triggers

- the step needs a boundary or permission change to stay viable
- the exact durable `Intent targets` cannot be identified from current
  artifacts
- the step still carries more than one `high` load after tightening
- shaping the step would require changing product truth instead of clarifying
  step scope

## Arc use

- usually invoked during `Shape Step`
- sometimes invoked when repairing a blocked step or reslicing an open step

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep runtime logging in the step file and Arc evidence; this pass does not
  add a second logging surface
