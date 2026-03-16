# Pass: derive-goal-stack

## Purpose

Derive or refresh the goal layer that explains why the current feature promise
matters at the system level.

## Pipeline position

- `intent/from-upstream`

## Strengthens

- decomposition clarity
- durable why coverage
- top-of-stack targeting

## Creates or updates

- goal catalog entries
- feature goal refs
- related decision refs when durable tradeoffs already exist

## Use This Pass When

- the current promise has no clear goal anchor
- the feature why is present but not yet elevated into durable goals
- different features in the same area need a shared higher-level outcome

## Not for

- product strategy ideation
- backlog hierarchy
- delivery milestones

## Inputs

- upstream request or product notes
- current goals catalog
- existing features in the same scope

## Preconditions

- the enduring product why is already clear enough to state
- the current promise can be connected to a stable system outcome

## Pass Steps

1. Identify the system-level outcome that the current promise serves.
2. Decide whether an existing goal already owns that why or a new goal is
   needed.
3. Write or tighten the goal entry so its outcome and success signals are
   durable.
4. Link the relevant feature surfaces back to that goal.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves the top-of-stack why for the
  current Intent slice
- Before posture: the promise lacks a stable goal anchor or uses a weak one
- After posture: the feature is grounded in explicit durable goals
- Evidence this pass can supply:
  - updated goal entries
  - feature goal refs
  - before and after top-of-stack alignment

## Outputs

- clearer goal coverage for the current promise
- stronger durable why at the top of the Intent decomposition

## Hand-off

- continue with `tighten-goal-outcomes` or `tighten-feature-outcomes`

## Quality checks

- goals describe system outcomes, not implementation tasks
- feature refs point to the goals that actually explain the promise
- goals stay stable across implementation rewrites

## Escalation triggers

- the current promise still lacks a stable why
- multiple competing goals fit and the repo needs durable narrowing
- the resulting goal would really be just a feature outcome restated

## Arc use

- usually invoked during `Map Arc`
- sometimes invoked during `Shape Step` when current work has no durable goal
  anchor

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep temporary prioritization decisions outside the goal layer.
