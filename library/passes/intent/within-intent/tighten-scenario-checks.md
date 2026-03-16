# Pass: tighten-scenario-checks

## Purpose

Turn scenario narrative into precise scenario-level checks.

## Pipeline position

- `intent/within-intent`

## Strengthens

- scenario targetability
- external check quality
- proof readiness

## Creates or updates

- scenario files
- linked behavior refs when tighter checks reveal missing behavior surfaces

## Use This Pass When

- scenario checks are narrative, broad, or hard to prove
- later Blueprint or step targeting would benefit from exact scenario targets
- evidence expectations are weak or missing

## Not for

- behavior-internal rules
- technical contracts
- detailed test planning

## Inputs

- scenario files
- linked feature and behavior surfaces
- any evidence expectations already implied upstream

## Preconditions

- the scenario context is already strong enough to interpret the check
- the scenario is the right owner for the check

## Pass Steps

1. Rewrite each scenario check as an externally meaningful requirement.
2. Remove implementation phrasing that belongs lower in the stack.
3. Tighten why-it-matters and evidence-expectation language.
4. Add or split checks when one narrative line carries multiple promises.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves scenario checks for later targeting
  and proof
- Before posture: scenario checks are narrative, mixed, or weakly observable
- After posture: scenario checks are precise, durable, and easier to prove
- Evidence this pass can supply:
  - updated scenario check entries
  - before and after requirement wording
  - clarified evidence expectations

## Outputs

- stronger scenario check targets
- better hand-off to Blueprint and Arc proof

## Hand-off

- continue with `derive-behaviors`, `align-blueprint-targets`, or
  `raise-verification-specificity`

## Quality checks

- each scenario check describes an externally meaningful requirement
- evidence expectations match the check, not a generic verification wish
- check granularity is small enough to target directly

## Escalation triggers

- a check belongs at behavior level instead
- one scenario contains too many unrelated checks
- evidence expectations would require technical design that does not yet exist

## Arc use

- usually invoked during `Map Arc`
- often invoked during `Shape Step` when current scenario targets are too weak

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep pure test design out of the scenario check itself.
