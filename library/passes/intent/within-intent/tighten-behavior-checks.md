# Pass: tighten-behavior-checks

## Purpose

Turn behavior notes into observable behavior checks.

## Pipeline position

- `intent/within-intent`

## Strengthens

- behavior targetability
- observability
- downstream proof quality

## Creates or updates

- behavior files
- linked Blueprint refs when behavior checks imply concrete contract pressure

## Use This Pass When

- behavior checks are implicit or mixed into narrative
- later design or proof needs more exact behavior targets
- evidence expectations are weak or not aligned to the behavior

## Not for

- scenario-level applicability
- API contract details
- test implementation recipes

## Inputs

- behavior files
- linked scenario and Blueprint surfaces
- any implied observability or evidence expectations

## Preconditions

- the behavior surface is already the right owner for the rule
- the pass can define observable checks without freezing technical design

## Pass Steps

1. Rewrite each behavior check as an observable requirement.
2. Tighten why-it-matters language so the check still reads as product truth.
3. Add evidence expectations that will help later proof.
4. Split mixed checks until each is independently targetable.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves the observable behavior contract
- Before posture: behavior checks are vague, mixed, or weakly observable
- After posture: behavior checks are precise, targetable, and easier to prove
- Evidence this pass can supply:
  - updated behavior check entries
  - before and after requirement wording
  - clarified evidence expectations

## Outputs

- stronger behavior check targets
- better hand-off to Blueprint, tests, and proof

## Hand-off

- continue with `extract-blueprint-contract-pressure`,
  `derive-verification-obligations`, or `shape-executable-step`

## Quality checks

- checks are observable from outside the implementation
- each check exerts meaningful downstream pressure
- evidence expectations are concrete enough for later proof

## Escalation triggers

- the check really belongs at scenario or assurance level
- behavior scope is overloaded and should be split
- making the check observable requires missing product decisions

## Arc use

- usually invoked during `Map Arc`
- often invoked during `Shape Step` when current behavior targets are too weak

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep detailed verification implementation outside the behavior file.
