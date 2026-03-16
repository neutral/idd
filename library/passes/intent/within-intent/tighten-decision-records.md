# Pass: tighten-decision-records

## Purpose

Sharpen durable narrowing in decision artifacts.

## Pipeline position

- `intent/within-intent`

## Strengthens

- decision clarity
- narrowing quality
- downstream consistency

## Creates or updates

- decision files
- refs from affected Intent, Blueprint, step, or evidence surfaces

## Use This Pass When

- a decision exists but its narrowing or consequences are still weak
- later readers could not tell what space the decision really closes off
- the decision's refs do not yet support downstream reuse

## Not for

- creating a decision where no durable narrowing exists
- archiving unresolved debate
- replacing Blueprint contracts with decision prose

## Inputs

- current decision files
- linked Intent and Blueprint surfaces
- step and evidence refs when live conflict resolution is involved

## Preconditions

- the decision already belongs in durable form
- the pass can improve clarity without changing the underlying choice

## Pass Steps

1. Tighten the context so the forces behind the narrowing are legible.
2. Rewrite the decision so the chosen space and excluded space are explicit.
3. Tighten consequences, implementation details, and verification language as
   needed.
4. Repair refs so later readers can locate what the decision governs and where
   it was applied.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves the clarity or reuse value of a
  durable decision
- Before posture: the decision exists but its narrowing is weak, vague, or
  poorly linked
- After posture: the decision more clearly constrains later acceptable work
- Evidence this pass can supply:
  - updated decision files
  - before and after narrowing language
  - improved refs to governed surfaces

## Outputs

- stronger decision records
- better reuse of durable narrowing in later work

## Hand-off

- continue with `extract-blueprint-contract-pressure` or
  `shape-executable-step`

## Quality checks

- the decision makes the constrained space legible
- consequences help later readers understand the cost of the choice
- refs show what the decision actually governs

## Escalation triggers

- the underlying choice is still unresolved
- the decision needs to be split because it carries multiple unrelated choices
- improving the record would require changing the decision itself

## Arc use

- usually invoked during `Map Arc`
- sometimes invoked during `Shape Step`, `Prove Step`, or `Close Step` when a
  live durable decision must stay inspectable

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- If the decision resolves a live Arc conflict, keep step and evidence refs
  current
