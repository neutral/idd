# Pass: derive-behaviors

## Purpose

Derive tighter externally meaningful behaviors under the scenario layer.

## Pipeline position

- `intent/from-upstream`

## Strengthens

- behavior-level precision
- externally meaningful rules
- downstream design pressure

## Creates or updates

- behavior files
- scenario behavior refs
- behavior blueprint refs when already known

## Use This Pass When

- scenario checks are still too broad for downstream technical design
- the current flow implies one or more durable behaviors that deserve their own
  checks
- later Blueprint work would otherwise infer behavior rules ad hoc

## Not for

- internal algorithm design
- code decomposition
- low-level API design

## Inputs

- scenario files
- upstream statements about externally visible behavior
- existing behavior files in the same scope

## Preconditions

- the parent scenario is already explicit
- the behavior being derived is externally meaningful, not just internal
  implementation detail

## Pass Steps

1. Identify the tighter externally meaningful behavior rules implied by the
   scenario.
2. Separate those rules into behavior files when they would sharpen downstream
   design pressure.
3. Record inputs and conditions, outputs and effects, and behavior checks.
4. Link the new behavior surfaces back to their parent scenario and forward to
   any known Blueprint surfaces.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially improves behavior-level precision for the
  current scenario
- Before posture: behavior rules are implicit, mixed into scenario prose, or
  too coarse for later targeting
- After posture: the behavior layer is explicit and independently targetable
- Evidence this pass can supply:
  - new or updated behavior files
  - scenario-to-behavior refs
  - before and after behavior coverage

## Outputs

- clearer behavior-level Intent under the current scenario
- stronger downstream pressure for Blueprint and proof

## Hand-off

- continue with `tighten-behavior-definitions`,
  `tighten-behavior-checks`, or `align-blueprint-targets`

## Quality checks

- the derived behavior is externally meaningful
- behavior files do not just restate internal implementation steps
- behavior checks are more precise than the parent scenario checks

## Escalation triggers

- the candidate behavior is really just one implementation idea
- the scenario is still too vague to derive behavior cleanly
- the behavior layer would become a dumping ground for technical design

## Arc use

- usually invoked during `Map Arc`
- sometimes invoked during `Shape Step` when a step needs tighter durable
  targeting than the scenario currently allows

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep pure internal design detail out of the behavior layer.
