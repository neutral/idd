# Pass: classify-assurance-criticality

## Purpose

Sharpen assurance criticality, priority, and measurable pressure.

## Pipeline position

- `intent/within-intent`

## Strengthens

- assurance prioritization
- measurable quality pressure
- downstream risk handling

## Creates or updates

- assurance entries
- scoped assurance catalogs
- linked decision refs when criticality depends on a durable tradeoff

## Use This Pass When

- assurance entries exist but their criticality or priority is weak
- measurable targets and budgets are too vague to influence later work
- reviewers need to know which constraints matter most in the current scope

## Not for

- inventing risk categories without evidence
- operational severity processes outside repo scope
- replacing feature or scenario promises with assurance categories

## Inputs

- assurance catalogs
- linked critical paths, features, and scenarios
- any decisions that narrow acceptable tradeoffs

## Preconditions

- the relevant assurance exists already
- the pass can sharpen pressure without inventing unsupported numbers

## Pass Steps

1. Re-evaluate category, criticality, and priority for the current assurance.
2. Tighten the quality scenario and metric definition so they shape later work.
3. Tighten targets, budgets, and review-by posture where material.
4. Recheck refs so the assurance pressure is applied to the right scope.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially sharpens the pressure or priority of an
  assurance
- Before posture: the assurance exists but its criticality or measurable burden
  is weak
- After posture: the assurance exerts clearer and more inspectable pressure
- Evidence this pass can supply:
  - updated assurance fields
  - before and after targets or priority language
  - linked critical-path or decision refs

## Outputs

- stronger assurance prioritization
- more useful quality pressure for later design and proof

## Hand-off

- continue with `derive-verification-obligations` or
  `extract-blueprint-contract-pressure`

## Quality checks

- criticality and priority materially change interpretation
- targets and budgets are tight enough to shape work
- the assurance still reads as durable product or system pressure

## Escalation triggers

- the pass would invent precision without support
- criticality depends on missing incident or product context
- the resulting pressure requires a durable decision that does not yet exist

## Arc use

- usually invoked during `Map Arc`
- sometimes invoked during `Shape Step` when assurance pressure is too vague

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep unsupported operational precision out of the assurance surface.
