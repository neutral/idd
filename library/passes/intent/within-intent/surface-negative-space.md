# Pass: surface-negative-space

## Purpose

Make exclusions, failure posture, and invariants explicit in the Intent slice.

## Pipeline position

- `intent/within-intent`

## Strengthens

- boundary clarity
- invariant visibility
- downstream safety

## Creates or updates

- feature out-of-scope boundaries
- scenario out-of-scope sections
- behavior outputs and effects or checks
- assurance entries when negative space is really a quality constraint

## Use This Pass When

- the current promise says what should happen but not what must not happen
- excluded flows, invariants, or failure posture are still implicit
- later agents could overbuild or regress adjacent behavior

## Not for

- temporary delivery scoping
- speculative edge-case brainstorming
- low-level exception handling design

## Inputs

- current Intent artifacts in scope
- linked assurances and decisions when they shape the negative space

## Preconditions

- the main promise is already explicit
- the pass can express the negative space without inventing new product truth

## Pass Steps

1. Identify the exclusions, invariants, and non-permitted outcomes implied by
   the current promise.
2. Route each part of that negative space to the durable owner surface.
3. Remove hidden assumptions that currently live only in prose or reviewer
   expectation.
4. Recheck the resulting boundaries against linked goals, scenarios, and
   assurances.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves the explicit negative space around
  the current promise
- Before posture: exclusions and invariants are implicit or incomplete
- After posture: the current promise states what must not be violated
- Evidence this pass can supply:
  - updated out-of-scope, invariant, or failure-posture language
  - before and after artifact wording
  - linked assurance or decision refs when added

## Outputs

- clearer exclusions and invariants
- lower risk of accidental adjacent change

## Hand-off

- continue with `route-constraints-to-assurances`,
  `raise-verification-specificity`, or `shape-executable-step`

## Quality checks

- negative space materially constrains later work
- exclusions stay durable rather than temporary
- invariants live in the narrowest correct owner surface

## Escalation triggers

- the negative space is still disputed
- the pass reveals a missing durable decision
- the new wording would freeze technical design instead of product truth

## Arc use

- usually invoked during `Map Arc`
- often invoked during `Shape Step` when safety boundaries are too implicit

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep transient execution restrictions in Arc, not in durable negative space.
