# Pass: sharpen-satisfaction-signals

## Purpose

Make success and evidence signals inspectable across goals, features,
scenarios, and behaviors.

## Pipeline position

- `intent/within-intent`

## Strengthens

- observability
- satisfaction clarity
- validation readiness

## Creates or updates

- goal success signals
- feature satisfaction signals
- scenario evidence expectations
- behavior evidence expectations

## Use This Pass When

- the promise is clear but later proof would still be subjective
- success language says what should happen but not how it will be recognized
- multiple Intent layers use weak or inconsistent signal language

## Not for

- test implementation steps
- metrics system design
- operational dashboards by themselves

## Inputs

- the current Intent artifact family in scope
- linked assurances and Blueprint surfaces when they affect observability
- any existing evidence expectations

## Preconditions

- the underlying promise is already explicit enough to observe
- the pass can improve observability without inventing new product truth

## Pass Steps

1. Identify where the current promise lacks inspectable satisfaction signals.
2. Rewrite success or evidence language so a later reader can recognize
   satisfaction directly.
3. Align signal language across linked Intent layers where the same promise is
   being reflected.
4. Remove weak wording that depends only on human interpretation.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves how the current promise can be
  recognized as satisfied
- Before posture: satisfaction exists mostly as interpretation or generic
  verification language
- After posture: the promise has clearer and more inspectable signals
- Evidence this pass can supply:
  - updated signal and evidence-expectation text
  - before and after observability wording
  - linked artifacts that now align better

## Outputs

- clearer satisfaction signals across the current Intent slice
- stronger preparation for later proof and validation

## Hand-off

- continue with `derive-verification-obligations`,
  `raise-verification-specificity`, or `shape-executable-step`

## Quality checks

- signals help a later reviewer recognize satisfaction without guesswork
- signals stay at the right layer
- signals do not smuggle in technical design

## Escalation triggers

- the underlying promise is still too vague to observe
- the only viable signal is purely operational and outside repository control
- the pass reveals missing assurance or Blueprint work

## Arc use

- usually invoked during `Map Arc`
- often invoked during `Shape Step` or `Prove Step` when proof posture is weak

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep raw test design and instrumentation planning outside Intent unless they
  are durable obligations
