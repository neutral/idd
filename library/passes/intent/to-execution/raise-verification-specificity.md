# Pass: raise-verification-specificity

## Purpose

Turn weak verification language into concrete checks, evidence, and closure
conditions.

## Pipeline position

- `intent/to-execution`

## Strengthens

- verification specificity
- evidence planning
- closure quality

## Creates or updates

- step proof targets
- Blueprint verification notes
- nearby Intent evidence-expectation wording when it is still weak

## Use This Pass When

- a step, Blueprint, or Intent-adjacent draft says only “test this” or
  “verify this”
- checks are listed without expected result, proof surface, or failure posture
- closeout would depend on human interpretation instead of explicit criteria

## Not for

- generating test code
- replacing proof assembly
- inventing verification for vague targets

## Inputs

- the current step, Blueprint, or verification-bearing draft
- the selected Intent targets
- available code, test, review, or evidence surfaces

## Preconditions

- the underlying promise or contract is already explicit enough to verify
- the relevant verification surfaces can be named

## Pass Steps

1. Replace generic verification language with concrete checks or review methods.
2. For each check, state what surface will be checked and what result should be
   observed.
3. Add or tighten evidence expectations so the proof surface is explicit.
4. Rewrite closure conditions and failure triggers so they can be evaluated
   without guessing.
5. Remove checks that do not support a named target or contract.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves verification specificity for the
  current work
- Before posture: verification language is generic, weak, or hard to prove
- After posture: checks, evidence, and closure are more explicit
- Evidence this pass can supply:
  - updated verification text
  - before and after proof language
  - clearer closure and failure posture

## Outputs

- more concrete verification and closure language
- stronger preparation for proof and review

## Hand-off

- continue with `shape-executable-step` or `Prove Step`

## Quality checks

- every check supports a named target, contract, or assurance
- expected results are explicit
- closure can be evaluated from artifacts or check results

## Escalation triggers

- the target is still too vague to verify meaningfully
- required verification surfaces do not exist yet
- stronger verification would materially change scope or authority

## Arc use

- often invoked during `Shape Step`
- sometimes invoked during `Prove Step` when proof language is still weak

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep final proof results in Arc artifacts and evidence, not in the pass.
