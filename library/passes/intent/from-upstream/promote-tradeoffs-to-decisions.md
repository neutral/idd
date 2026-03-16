# Pass: promote-tradeoffs-to-decisions

## Purpose

Turn durable solution narrowing into decision artifacts.

## Pipeline position

- `intent/from-upstream`

## Strengthens

- durable narrowing
- tradeoff visibility
- downstream consistency

## Creates or updates

- decision files
- refs from Intent or Blueprint artifacts into decisions
- decision links back to current steps or evidence when live conflicts are
  being resolved

## Use This Pass When

- upstream material already contains a real durable choice
- the current draft is using implementation-specific narrowing without a
  decision surface
- later readers would otherwise need to rediscover why the space was narrowed

## Not for

- open option lists that are not yet durable
- temporary delivery preferences
- lightweight wording choices that do not constrain later work

## Inputs

- upstream source material
- current Intent and Blueprint artifacts
- any existing decision artifacts in the same scope

## Preconditions

- the tradeoff materially narrows the acceptable solution space
- the narrowing is durable enough to survive beyond the current pass

## Pass Steps

1. Identify the choice that already constrains future acceptable
   implementations.
2. Separate that durable narrowing from incidental implementation discussion.
3. Record the decision, options considered, and consequences in a decision
   artifact.
4. Link the affected Intent and Blueprint surfaces to the decision.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially preserves durable tradeoff narrowing in a
  decision artifact
- Before posture: narrowing exists only in prose, assumptions, or transient
  discussion
- After posture: the narrowing is explicit, inspectable, and reusable
- Evidence this pass can supply:
  - new or updated decision files
  - refs from affected artifacts to the decision
  - before and after tradeoff preservation

## Outputs

- durable decision records for the current scope
- reduced risk of re-litigating or forgetting the narrowing choice

## Hand-off

- continue with `tighten-decision-records`,
  `extract-blueprint-contract-pressure`, or `shape-executable-step`

## Quality checks

- the decision changes the acceptable downstream space
- the consequences and refs make the narrowing inspectable
- the decision is durable enough to justify its own artifact

## Escalation triggers

- the tradeoff is still exploratory or unresolved
- the narrowing belongs in Blueprint rather than a durable decision
- promoting it would freeze a choice that is not yet stable

## Arc use

- usually invoked during `Map Arc`
- sometimes invoked during `Shape Step` or `Prove Step` when a live tradeoff
  becomes durable

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- If the decision resolves a live Arc conflict, keep step and evidence refs
  current too
