# Pass: map-intent-to-code-impact

## Purpose

Map the likely code, description, and test surfaces implied by the current
Intent slice.

## Pipeline position

- `intent/to-blueprint`

## Strengthens

- implementation-readiness
- touched-surface planning
- layer hand-off clarity

## Creates or updates

- Blueprint notes about consumers and scope
- step planning inputs for code, description, and test surfaces
- description or verification refs when they are already knowable

## Use This Pass When

- the current Intent and Blueprint are clear but downstream touched surfaces are
  still implicit
- shaping work would benefit from a better map of likely implementation impact
- code and test scope risk is higher than the current draft admits

## Not for

- choosing exact implementation edits
- creating Arc steps by itself
- replacing code review or proof

## Inputs

- selected Intent targets
- current Blueprint artifact
- existing code, description, and test surfaces in the relevant area

## Preconditions

- the current promise and Blueprint pressure are explicit enough to project code
  impact
- the pass can stay at affected-surface level rather than implementation detail

## Pass Steps

1. Identify the code-facing surfaces the selected Intent slice is likely to
   move.
2. Distinguish likely implementation, description, and test impact.
3. Record that pressure in the narrowest durable or runtime planning surface
   that should own it.
4. Remove unjustified touched-surface assumptions.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves the predicted code-facing impact of
  the current Intent slice
- Before posture: downstream impact is implicit or overly broad
- After posture: likely implementation, description, and test surfaces are
  clearer
- Evidence this pass can supply:
  - updated Blueprint or step-planning surfaces
  - before and after impact mapping
  - narrowed or expanded touched-surface expectations

## Outputs

- clearer code-facing impact map
- better preparation for step shaping and proof planning

## Hand-off

- continue with `shape-executable-step` or `split-overloaded-step`

## Quality checks

- the impact map helps planning without freezing implementation
- code, description, and test pressure are separated clearly
- the predicted surfaces remain justified by the selected Intent targets

## Escalation triggers

- the likely impact is still too uncertain to plan safely
- the current Intent or Blueprint is too weak to support mapping
- mapping reveals a larger scope change than the current Arc should carry

## Arc use

- usually invoked during `Shape Step`
- sometimes invoked during `Map Arc` when later steps need better impact
  projection

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep exact edits in Arc and code, not in this pass.
