# Pass: bound-scope-and-non-goals

## Purpose

Separate what belongs in the current durable promise from what stays out.

## Pipeline position

- `intent/from-upstream`

## Strengthens

- scope clarity
- non-goal clarity
- future implementation boundaries

## Creates or updates

- feature files
- scenario files
- goal catalog entries
- decision files when a durable narrowing must be recorded

## Use This Pass When

- upstream material mixes the main promise with adjacent wants
- the current draft is likely to trigger solution sprawl
- future agents could reasonably overbuild because the exclusions are missing

## Not for

- task slicing inside Arc
- API boundary design
- temporary delivery scoping

## Inputs

- upstream source material
- any current feature, scenario, or goal drafts
- adjacent promises already represented in Intent

## Preconditions

- the main promise is already identifiable
- nearby work can be distinguished from the in-scope promise

## Pass Steps

1. Mark the exact promise that belongs in the current Intent slice.
2. Identify nearby requests, flows, or quality concerns that are not part of
   that slice.
3. Move in-scope and out-of-scope statements into the artifact families that
   own them.
4. Ensure the resulting boundaries would constrain later Blueprint and code
   generation.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially narrows the current durable promise and its
  exclusions
- Before posture: in-scope and out-of-scope material are mixed or implicit
- After posture: the promise boundary and non-goals are explicit and usable
- Evidence this pass can supply:
  - updated in-scope and out-of-scope surfaces
  - removed adjacent work from the current slice
  - before and after scope wording

## Outputs

- explicit in-scope and out-of-scope boundaries
- reduced chance of overbuilding or accidental drift

## Hand-off

- continue with `derive-scenarios`, `surface-negative-space`, or
  `shape-executable-step`

## Quality checks

- a later agent could tell what to avoid building
- excluded work is concrete enough to prevent scope bleed
- the bounded promise still remains meaningful on its own

## Escalation triggers

- the current scope cannot be bounded without a product decision
- adjacent work is coupled tightly enough that the promise may need splitting
- the exclusions are mostly temporary delivery concerns instead of durable
  non-goals

## Arc use

- usually invoked during `Map Arc`
- often invoked during `Shape Step` when a step or Intent draft is too broad

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep temporary execution scoping in Arc, not in the durable non-goal surface.
