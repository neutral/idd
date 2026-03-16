# Pass: split-overloaded-step

## Purpose

Detect when one step carries too much novelty, scope, or proof burden and
rewrite it into smaller steps.

## Pipeline position

- `intent/to-execution`

## Strengthens

- step sizing
- execution safety
- review quality

## Creates or updates

- the active step file under `.methodologies/idd/scratch/arc/`
- `.methodologies/idd/scratch/arc/arc.md`
- new future step detail when the split creates later steps

## Use This Pass When

- one step still carries more than one `high` load
- the step mixes unrelated targets or touched surfaces
- proof burden or review burden is too large for one pass

## Not for

- splitting work only to increase ceremony
- replacing decomposition work that belongs in Intent
- creating a fake step sequence without reducing real risk

## Inputs

- the active step file
- `.methodologies/idd/scratch/arc/arc.md`
- selected Intent targets and Blueprint refs
- current capability-fit assessment

## Preconditions

- one coherent active step already exists
- the overload is real enough to justify multiple steps

## Pass Steps

1. Identify which parts of the current step are making it unsafe or too large.
2. Separate the current work into smaller steps that each preserve one coherent
   slice.
3. Assign exact targets, refs, and layer deltas to each resulting step.
4. Update `arc.md` so the ordered completion path remains explicit.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves execution safety by splitting an
  overloaded step
- Before posture: one step carries too much novelty, scope, or proof burden
- After posture: resulting steps are smaller, clearer, and safer to execute
- Evidence this pass can supply:
  - before and after step structures
  - updated capability-fit posture
  - new or revised step targets and register entries

## Outputs

- a safer ordered step sequence
- improved capability-fit posture for the active work

## Hand-off

- continue with `shape-executable-step` on the new active step

## Quality checks

- each resulting step still serves one coherent slice
- the split reduces actual execution or review risk
- later steps remain planned while the active one stays focused

## Escalation triggers

- the overload really reflects missing Intent or Blueprint work
- the split requires a boundary change or new authority
- the resulting steps would still each be too large

## Arc use

- usually invoked during `Shape Step`
- sometimes invoked after `Prove Step` when same-step fix-forward is no longer
  the right move

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep the ordered completion path explicit in `arc.md` after the split.
