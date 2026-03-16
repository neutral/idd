# Pass: surface-quality-constraints

## Purpose

Extract the cross-cutting constraints that should shape delivery and route them
into assurances.

## Pipeline position

- `intent/from-upstream`

## Strengthens

- quality constraint visibility
- assurance readiness
- downstream risk control

## Creates or updates

- assurance catalog entries
- scoped assurance refs from features or scenarios
- decision refs when durable overrides or weakening exist

## Use This Pass When

- upstream material implies security, privacy, reliability, performance,
  compliance, or auditability pressure
- cross-cutting constraints are being left buried in feature or scenario prose
- later Blueprint or code work could miss non-functional requirements

## Not for

- operational runbooks
- production incident analysis
- implementation pattern design by itself

## Inputs

- upstream request or notes
- relevant features and scenarios
- current assurance catalogs

## Preconditions

- the cross-cutting pressure materially affects what should be built or proven
- the relevant scope for the constraint is identifiable

## Pass Steps

1. Extract the cross-cutting constraints that materially shape delivery.
2. Decide whether they belong in the global baseline, a scoped assurance
   catalog, or both.
3. Write or tighten assurance entries so the constraint is explicit,
   measurable, and linked to the right scope.
4. Remove or reduce duplicated constraint wording from lower-value artifact
   surfaces once the assurance surface owns it.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially exposes quality constraints that should
  shape downstream design or proof
- Before posture: quality pressure is implicit, scattered, or easy to miss
- After posture: the relevant assurance surfaces make that pressure explicit
- Evidence this pass can supply:
  - new or updated assurance entries
  - refs from scoped artifacts into assurances
  - before and after constraint routing

## Outputs

- clearer assurance pressure for the current scope
- reduced chance that cross-cutting constraints are missed later

## Hand-off

- continue with `route-constraints-to-assurances`,
  `classify-assurance-criticality`, or `extract-blueprint-contract-pressure`

## Quality checks

- the surfaced constraint materially shapes design, proof, or review
- the assurance surface is more precise than the original prose
- lower-level artifacts no longer need to carry the same constraint redundantly

## Escalation triggers

- the constraint is still too vague to record durably
- the pressure is purely operational and not repository-governing
- surfacing the constraint requires a durable tradeoff decision that is missing

## Arc use

- usually invoked during `Map Arc`
- sometimes invoked during `Shape Step` when missing assurance pressure blocks
  safe execution

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep operational-only concerns out of IDD unless repository artifacts must
  respond to them
