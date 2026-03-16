# Pass: tighten-applicability-context

## Purpose

Sharpen actors, triggers, entry conditions, and operating situation so the
current promise applies in clearly defined contexts.

## Pipeline position

- `intent/within-intent`

## Strengthens

- context precision
- applicability boundaries
- scenario usefulness

## Creates or updates

- scenario files
- feature or behavior wording when applicability has leaked upward or downward

## Use This Pass When

- the current scenario applies in ambiguous situations
- actors, triggers, or entry conditions are vague or missing
- later design or verification would otherwise assume context ad hoc

## Not for

- detailed interaction scripting
- implementation branching logic
- production environment modeling

## Inputs

- scenario files
- linked feature and behavior files
- upstream material that clarifies operating context

## Preconditions

- the scenario already exists
- the pass can improve applicability without changing the core promise

## Pass Steps

1. Rewrite actors, triggers, and entry conditions so the scenario applies in a
   well-defined situation.
2. Tighten the high-level flow only enough to preserve context, not
   implementation.
3. Make the out-of-scope boundary explicit where it prevents later confusion.
4. Recheck the scenario checks against the improved context.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves the applicability context of a
  scenario
- Before posture: the scenario context is vague, mixed, or too broad
- After posture: the scenario applies in a clearly defined situation
- Evidence this pass can supply:
  - updated actors, triggers, and entry conditions
  - before and after scenario context wording
  - clarified out-of-scope statements

## Outputs

- stronger applicability context
- fewer implicit assumptions for later work

## Hand-off

- continue with `tighten-scenario-checks` or `derive-behaviors`

## Quality checks

- the scenario context is narrow enough to guide later work
- context is product-facing, not implementation-facing
- the scenario still matches its parent feature promise

## Escalation triggers

- the scenario needs splitting into multiple situations
- the pass reveals missing higher-level scope boundaries
- the context needed is not available in the current source material

## Arc use

- usually invoked during `Map Arc`
- sometimes invoked during `Shape Step` when scenario targeting is still vague

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep implementation decision-making out of the scenario narrative.
