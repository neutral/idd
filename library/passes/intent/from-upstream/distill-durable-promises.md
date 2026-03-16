# Pass: distill-durable-promises

## Purpose

Turn upstream material into durable product promises that belong in Intent.

## Pipeline position

- `intent/from-upstream`

## Strengthens

- promise durability
- product commitment clarity
- downstream Intent readiness

## Creates or updates

- goal catalog entries
- feature files
- scenario files
- behavior files
- assurance catalog entries
- decision files when durable narrowing already exists

## Use This Pass When

- upstream material mixes durable commitments with conversation, analysis, or
  loose notes
- the current request says what the team wants generally but not what the
  product must durably keep
- agents or reviewers would otherwise need to infer the real promise from chat
  or issue text

## Not for

- architecture design
- implementation planning
- open-ended brainstorming

## Inputs

- the current user request or upstream artifact
- any existing Intent artifacts in the same scope
- clarified scope limits for the current work

## Preconditions

- there is enough upstream material to identify at least one durable promise
- the target product scope is known well enough to avoid accidental drift

## Pass Steps

1. Separate durable product commitments from transient notes, options, and
   background material.
2. Extract the promises that the product must keep across implementations.
3. Normalize those promises into language suitable for goals, features,
   scenarios, behaviors, assurances, or decisions.
4. Remove wording that depends on one implementation idea unless that idea is
   already a durable narrowing decision.
5. Route each extracted promise to the narrowest Intent artifact family that
   should own it.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially converts mixed upstream material into stable
  Intent promises for the current scope
- Before posture: the current source material is not durable enough to target
  directly
- After posture: durable promises are explicit, scoped, and ready for Intent
  decomposition
- Evidence this pass can supply:
  - before and after artifact refs or diff surfaces
  - extracted durable promise list
  - removed non-durable material or rerouted notes

## Outputs

- durable promise statements suitable for Intent artifacts
- cleaner separation between durable commitments and transient material
- a clearer starting point for downstream Intent passes

## Hand-off

- continue with `derive-goal-stack`, `derive-scenarios`,
  `surface-quality-constraints`, or another narrower from-upstream pass

## Quality checks

- every retained promise should survive an implementation rewrite
- no retained promise depends on chat context to be interpreted
- the output is specific enough to route into concrete Intent artifacts

## Escalation triggers

- upstream material is still too vague to identify any durable promise
- the request is mostly research, discovery, or ideation instead of a product
  commitment
- extracting durable promises would require inventing product truth

## Arc use

- usually invoked during `Map Arc`
- sometimes invoked during `Shape Step` when execution is blocked by missing
  durable Intent

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep the durable promise itself in Intent artifacts, not in the pass record.
