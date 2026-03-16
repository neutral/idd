# Pass: tighten-goal-outcomes

## Purpose

Sharpen goals into durable system outcomes with clear success signals.

## Pipeline position

- `intent/within-intent`

## Strengthens

- top-level outcome clarity
- durable why
- goal usefulness

## Creates or updates

- goal catalog entries
- linked feature goal refs when needed

## Use This Pass When

- goals are too generic to guide interpretation
- the durable why exists but success signals are weak
- features point to goals that do not clearly state the outcome they serve

## Not for

- feature-level acceptance criteria
- implementation metrics
- organizational objectives

## Inputs

- goal catalog entries
- linked features
- guardrails that constrain the goal surface

## Preconditions

- the goal already belongs at system or product-outcome level
- the pass can improve the goal without turning it into a feature

## Pass Steps

1. Tighten the goal outcome so it states a durable product result.
2. Rewrite why-it-matters language so it supports interpretation without
   becoming discovery prose.
3. Tighten success signals so later readers can tell whether the goal is being
   served.
4. Recheck linked features against the improved goal wording.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves a goal's outcome and success signal
  quality
- Before posture: goals are broad, weak, or poor guidance for downstream work
- After posture: goals clearly state durable outcomes and useful success
  signals
- Evidence this pass can supply:
  - updated goal entries
  - before and after outcome wording
  - linked feature refs that now interpret cleanly

## Outputs

- stronger goal entries
- clearer durable why for linked features

## Hand-off

- continue with `tighten-feature-outcomes` or `align-intent-decomposition`

## Quality checks

- goals stay above feature detail
- success signals help interpretation without becoming implementation metrics
- linked features still read naturally under the tightened goal

## Escalation triggers

- the goal is really a feature or scenario restated
- the system-level outcome is still not clear
- tightening would require a new durable prioritization decision

## Arc use

- usually invoked during `Map Arc`
- sometimes invoked during `Shape Step` when goal ambiguity blocks clean scope

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep temporary delivery priorities out of the goal surface.
