# Pass: derive-verification-obligations

## Purpose

Derive the verification burden that Blueprint and Code must satisfy for the
current Intent slice.

## Pipeline position

- `intent/to-blueprint`

## Strengthens

- verification readiness
- proof planning
- downstream trust clarity

## Creates or updates

- Blueprint verification notes
- linked assurance evidence expectations
- step proof language when shaping is already in progress

## Use This Pass When

- the current promise and contract are explicit but the verification burden is
  still weak
- later proof would otherwise default to generic testing language
- multiple linked Intent targets need a clearer combined verification posture

## Not for

- writing test code
- replacing the proof phase
- inventing verification for vague promises

## Inputs

- selected Intent targets
- current Blueprint artifact
- linked assurances
- current step if execution planning is already active

## Preconditions

- the underlying promise and Blueprint pressure are already explicit enough to
  verify
- the pass can express obligations without specifying exact test
  implementation

## Pass Steps

1. Identify what must be verified for the selected Intent targets and linked
   assurances.
2. Translate that burden into concrete verification obligations in Blueprint
   language.
3. Align the resulting obligations with the likely step proof and evidence
   surfaces.
4. Remove generic verification language that does not support a named target or
   constraint.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves the verification burden captured
  for the current Intent slice
- Before posture: verification pressure is generic, partial, or weakly linked
- After posture: verification obligations are clearer and more inspectable
- Evidence this pass can supply:
  - updated verification notes or assurance links
  - before and after verification language
  - clearer mapping to target surfaces

## Outputs

- stronger verification obligations for Blueprint and later Arc proof
- less subjective downstream validation

## Hand-off

- continue with `raise-verification-specificity` or `shape-executable-step`

## Quality checks

- each obligation traces back to a named target or assurance
- the burden is concrete enough for later proof
- the pass does not collapse into test implementation detail

## Escalation triggers

- the promise is still too vague to verify meaningfully
- verification obligations imply missing design or assurance work
- the current repo lacks the surfaces needed to make the obligation durable

## Arc use

- usually invoked during `Map Arc`
- often invoked during `Shape Step`
- sometimes invoked during `Prove Step` when earlier verification posture was
  weak

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep detailed execution of proof in Arc, not in the pass itself.
