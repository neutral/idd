# Pass: strip-unsettled-material

## Purpose

Remove brainstorming, research, and architecture speculation from durable
Intent.

## Pipeline position

- `intent/from-upstream`

## Strengthens

- durability discipline
- intent stability
- downstream trust

## Creates or updates

- any Intent artifact that currently carries unsettled material
- decision artifacts when a previously unsettled item has become durable

## Use This Pass When

- durable Intent artifacts contain open options, exploratory notes, or
  speculative architecture
- the current draft is trying to preserve too much upstream material verbatim
- later agents could mistake unsettled material for product truth

## Not for

- deleting real durable constraints
- hiding material uncertainty that still affects delivery
- removing evidence from Arc or decision artifacts

## Inputs

- current Intent artifacts
- upstream source material when needed for comparison
- current decision surfaces if some speculation has already become durable

## Preconditions

- the pass can distinguish unsettled material from real durable commitments
- any durable narrowing that should survive can be routed elsewhere

## Pass Steps

1. Identify content that is still exploratory, speculative, or provisional.
2. Remove it from the durable Intent artifact or replace it with the durable
   commitment that should survive.
3. Route still-relevant durable narrowing to decisions or Blueprint when
   appropriate.
4. Leave only stable product truth in the resulting Intent surface.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially removes unsettled material that was making
  durable Intent ambiguous
- Before posture: the artifact mixes durable commitments with unsettled
  material
- After posture: the artifact contains only stable product truth for its layer
- Evidence this pass can supply:
  - removed speculative content
  - rerouted durable narrowing
  - before and after artifact surfaces

## Outputs

- cleaner durable Intent artifacts
- lower risk that later work treats speculation as product truth

## Hand-off

- continue with `distill-durable-promises`, `tighten-decision-records`, or
  `extract-blueprint-contract-pressure`

## Quality checks

- remaining content is durable enough to target later
- removed material was truly unsettled, not merely incomplete
- any durable narrowing that mattered was preserved elsewhere

## Escalation triggers

- the pass cannot tell whether the material is speculative or durable
- removing the material would erase a real product commitment
- the unsettled material reveals a missing decision or missing research handoff

## Arc use

- usually invoked during `Map Arc`
- sometimes invoked during `Shape Step` when weak Intent is blocking clean
  targeting

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep active uncertainty in Arc or in another methodology, not in durable
  Intent by default
