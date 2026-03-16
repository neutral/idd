# Pass: align-blueprint-targets

## Purpose

Make Blueprint target selection exact and complete against the current Intent
slice.

## Pipeline position

- `intent/to-blueprint`

## Strengthens

- target alignment
- Blueprint legitimacy
- downstream contract precision

## Creates or updates

- Blueprint `Intent targets`
- Blueprint `Intent refs`
- linked Intent artifacts when target selection reveals missing durable targets

## Use This Pass When

- a Blueprint points only broadly at Intent
- Blueprint targets do not match the exact promise being implemented
- later code or proof would benefit from tighter Blueprint targeting

## Not for

- inventing technical contracts without Intent pressure
- replacing Blueprint design work
- broadening the Intent slice to fit an existing contract

## Inputs

- the Blueprint artifact in scope
- linked Intent artifacts
- any current Arc target selection

## Preconditions

- the relevant durable Intent targets already exist
- the Blueprint is the right contract owner for the selected promise

## Pass Steps

1. Identify the exact durable Intent targets the Blueprint should concretize.
2. Replace broad or partial targeting with the precise target set.
3. Align `Intent refs` to the same selected surfaces.
4. Remove Blueprint targeting that is no longer justified by the current
   promise.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves Blueprint targeting against Intent
- Before posture: the Blueprint is broad, partial, or weakly aligned to Intent
- After posture: the Blueprint selects the exact durable targets it should
  concretize
- Evidence this pass can supply:
  - updated Blueprint target and ref surfaces
  - before and after target alignment
  - removed or added target coverage

## Outputs

- cleaner Blueprint target alignment
- stronger downstream design legitimacy

## Hand-off

- continue with `extract-blueprint-contract-pressure`,
  `derive-verification-obligations`, or `map-intent-to-code-impact`

## Quality checks

- every selected target is real, relevant, and durable
- the Blueprint does not claim more Intent than it actually concretizes
- later Arc steps can target the Blueprint and Intent consistently

## Escalation triggers

- the required durable Intent targets do not yet exist
- the Blueprint scope is wrong for the selected targets
- exact alignment reveals a missing durable decision

## Arc use

- usually invoked during `Map Arc`
- often invoked during `Shape Step` before implementation work begins

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep step-local scoping in Arc; keep durable target selection in Blueprint.
