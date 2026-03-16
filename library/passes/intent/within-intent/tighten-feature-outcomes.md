# Pass: tighten-feature-outcomes

## Purpose

Turn broad feature prose into concrete required outcomes with strong
satisfaction signals.

## Pipeline position

- `intent/within-intent`

## Strengthens

- scoped promise quality
- outcome precision
- satisfaction clarity

## Creates or updates

- feature files
- linked scenario refs when feature outcomes imply missing scenarios

## Use This Pass When

- feature wording is broad, narrative, or hard to target directly
- required outcomes exist but do not yet constrain later design or proof
- satisfaction signals are too weak to guide later validation

## Not for

- scenario-specific context
- low-level behavior rules
- blueprint contracts

## Inputs

- feature files
- linked goals, scenarios, and assurances
- any upstream material needed to clarify the user-facing promise

## Preconditions

- the feature scope is already bounded
- the feature is the right level for the current promise

## Pass Steps

1. Rewrite the feature definition so in-scope and out-of-scope boundaries are
   explicit.
2. Turn broad promised results into distinct required outcomes.
3. Tighten each outcome so it is durable, user-facing, and independently
   targetable.
4. Add satisfaction signals that later proof can inspect.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves the feature outcome contract
- Before posture: the feature promise is broad or only loosely targetable
- After posture: the feature carries concrete required outcomes and satisfaction
  signals
- Evidence this pass can supply:
  - updated feature sections
  - before and after outcome wording
  - new or revised local outcome IDs

## Outputs

- clearer feature outcome contracts
- better targeting for scenarios, Blueprint, and Arc

## Hand-off

- continue with `derive-scenarios`, `tighten-scenario-checks`, or
  `align-blueprint-targets`

## Quality checks

- each outcome is user-facing and durable
- satisfaction signals make later proof easier
- the feature is still narrower than a goal and broader than a scenario

## Escalation triggers

- the feature still contains multiple unrelated promises
- scenario detail is overwhelming the feature surface
- the current promise belongs in another layer

## Arc use

- usually invoked during `Map Arc`
- often invoked during `Shape Step` when exact feature targets are weak

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep technical design out of the feature surface.
