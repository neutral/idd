# Pass: tighten-behavior-definitions

## Purpose

Sharpen behavior definitions so downstream design pressure is clear without
turning Intent into technical spec.

## Pipeline position

- `intent/within-intent`

## Strengthens

- behavior definition quality
- downstream design pressure
- boundary clarity

## Creates or updates

- behavior files
- linked scenario refs and blueprint refs when definition changes affect them

## Use This Pass When

- behavior definitions are vague or merely restate the scenario
- inputs, conditions, outputs, or effects are underspecified
- later Blueprint work would otherwise have to infer too much from behavior
  prose

## Not for

- API schemas
- algorithm design
- code structure decisions

## Inputs

- behavior files
- parent scenario files
- any linked Blueprint surfaces

## Preconditions

- behavior level is already the right owner for the rule
- the pass can improve pressure without freezing technical design

## Pass Steps

1. Tighten the summary, inputs and conditions, and outputs and effects.
2. Make the Definitions surface more useful for downstream contract work.
3. Remove behavior wording that really belongs in Blueprint or code.
4. Recheck behavior checks against the improved definitions.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves the behavior definition surface
- Before posture: behavior definitions are vague, redundant, or poor design
  pressure
- After posture: the behavior surface makes downstream contract pressure clear
- Evidence this pass can supply:
  - updated behavior definition sections
  - before and after inputs, outputs, and refs
  - reduced ambiguity for linked Blueprint work

## Outputs

- stronger behavior definition surfaces
- cleaner separation between Intent and Blueprint

## Hand-off

- continue with `tighten-behavior-checks` or
  `extract-blueprint-contract-pressure`

## Quality checks

- the behavior surface still describes product-facing rules
- downstream design pressure is clearer, but technical design remains open
- inputs and outputs materially aid later work

## Escalation triggers

- the pass needs to invent technical contracts
- the behavior should actually be split or moved
- the downstream pressure belongs in assurances or decisions instead

## Arc use

- usually invoked during `Map Arc`
- sometimes invoked during `Shape Step` when behavior surfaces are too weak for
  clean Blueprint work

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep technical spec detail in Blueprint, not here.
