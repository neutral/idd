# Pass: extract-blueprint-contract-pressure

## Purpose

Turn Intent pressure into concrete Blueprint contract obligations.

## Pipeline position

- `intent/to-blueprint`

## Strengthens

- contract readiness
- downstream design pressure
- implementation constraint clarity

## Creates or updates

- Blueprint contract sections
- Blueprint failure and boundary conditions
- Blueprint verification notes

## Use This Pass When

- Intent is explicit but Blueprint still under-constrains implementation
- a feature, scenario, behavior, assurance, or decision clearly implies
  contract pressure
- later code work would otherwise infer technical obligations ad hoc

## Not for

- full architecture design
- implementation decomposition
- replacing Intent with technical detail

## Inputs

- selected Intent targets
- linked assurances and decisions
- the current Blueprint artifact

## Preconditions

- the Intent pressure is already durable and explicit
- the Blueprint is the right place to hold the contract consequence

## Pass Steps

1. Identify the contract obligations implied by the selected Intent targets.
2. Translate those obligations into Blueprint contract, boundary, and failure
   language.
3. Keep the contract concrete enough to constrain code while avoiding premature
   implementation detail.
4. Recheck the resulting Blueprint against linked assurances and decisions.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves how Blueprint captures Intent
  pressure
- Before posture: Intent pressure exists but the Blueprint contract is too weak
  or generic
- After posture: the Blueprint expresses clearer contract obligations derived
  from Intent
- Evidence this pass can supply:
  - updated Blueprint contract surfaces
  - before and after contract wording
  - linked Intent, assurance, and decision refs

## Outputs

- stronger Blueprint obligations derived from Intent
- less downstream invention during implementation

## Hand-off

- continue with `derive-verification-obligations` or
  `map-intent-to-code-impact`

## Quality checks

- every new contract obligation traces back to explicit Intent pressure
- the Blueprint remains technical but not over-designed
- failure and boundary conditions reflect real product constraints

## Escalation triggers

- the Intent pressure is still too vague to translate cleanly
- the pass reveals missing durable Intent or decision work
- capturing the pressure would require a larger architectural choice

## Arc use

- usually invoked during `Map Arc`
- often invoked during `Shape Step` before code changes are planned

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep product truth in Intent and contract realization in Blueprint.
