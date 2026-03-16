# Pass: route-constraints-to-assurances

## Purpose

Move cross-cutting quality pressure into the assurance surface that should own
it.

## Pipeline position

- `intent/within-intent`

## Strengthens

- assurance ownership
- cross-cutting constraint visibility
- artifact-role clarity

## Creates or updates

- global or scoped assurance entries
- refs from features, scenarios, or behaviors into assurances
- decision refs when overrides or weakening are involved

## Use This Pass When

- features, scenarios, or behaviors carry quality constraints that really
  belong in assurances
- the same cross-cutting rule is being repeated in multiple lower-value
  artifacts
- downstream design or proof would benefit from one clear owner surface

## Not for

- removing truly local promise content from the owning artifact
- purely operational concerns that do not govern repository artifacts
- weakening assurance pressure silently

## Inputs

- current Intent artifacts in scope
- global and scoped assurance catalogs
- linked decisions when scope-specific overrides exist

## Preconditions

- the constraint is genuinely cross-cutting or quality-oriented
- the assurance surface is the right durable owner

## Pass Steps

1. Identify constraint language that belongs in assurances rather than local
   promise artifacts.
2. Move or restate that pressure in the correct assurance scope.
3. Replace duplicated lower-layer wording with refs to the owning assurance
   surface where appropriate.
4. Preserve any local promise detail that still belongs outside assurances.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves ownership of cross-cutting
  constraints
- Before posture: quality pressure is scattered across artifacts or weakly
  owned
- After posture: the assurance surface clearly owns the constraint and linked
  artifacts route to it
- Evidence this pass can supply:
  - updated assurance entries
  - reduced duplication in lower artifacts
  - new or revised assurance refs

## Outputs

- clearer assurance ownership
- less repeated quality language across Intent

## Hand-off

- continue with `classify-assurance-criticality`,
  `extract-blueprint-contract-pressure`, or `derive-verification-obligations`

## Quality checks

- the assurance surface now owns the reusable constraint
- lower-level artifacts still retain the promise content that belongs there
- overrides or weakening remain explicit and inspectable

## Escalation triggers

- the pass reveals missing scoped assurance coverage
- moving the language would erase important local promise detail
- the current repo lacks the durable decision needed for an override

## Arc use

- usually invoked during `Map Arc`
- sometimes invoked during `Shape Step` when assurance ownership is blocking
  safe execution

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep the assurance surface authoritative once ownership is moved.
