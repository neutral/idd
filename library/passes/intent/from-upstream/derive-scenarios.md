# Pass: derive-scenarios

## Purpose

Derive scenario surfaces from the scoped promise and the operating situation in
which that promise matters.

## Pipeline position

- `intent/from-upstream`

## Strengthens

- applicability context
- scenario coverage
- user-visible flow clarity

## Creates or updates

- scenario files
- feature scenario refs
- scenario blueprint refs when already known

## Use This Pass When

- a feature promise exists but the situations in which it applies are still
  implicit
- later design or execution would otherwise reason directly from feature prose
  alone
- different user or system situations need distinct scenario treatment

## Not for

- UI scripting
- detailed interaction design
- implementation sequencing

## Inputs

- feature drafts
- upstream context about users, triggers, and entry conditions
- existing scenarios in the same feature scope

## Preconditions

- the feature promise is already bounded
- there is enough context to distinguish meaningful situations

## Pass Steps

1. Identify the distinct situations in which the feature promise must hold.
2. Separate those situations into scenario surfaces rather than burying them in
   feature prose.
3. Record actors, triggers, entry conditions, and high-level flow for each
   scenario.
4. Add scenario-level checks that capture the externally visible promise for
   each situation.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially adds or improves scenario-level applicability
  context for the current promise
- Before posture: the feature promise has weak or implicit operating situations
- After posture: scenarios make the relevant situations and checks explicit
- Evidence this pass can supply:
  - new or updated scenario files
  - feature-to-scenario links
  - before and after applicability coverage

## Outputs

- clearer scenario coverage under the current feature
- stronger context for later Blueprint and execution work

## Hand-off

- continue with `tighten-applicability-context`,
  `tighten-scenario-checks`, or `derive-behaviors`

## Quality checks

- each scenario represents a meaningfully different situation
- the scenario checks are externally meaningful
- the feature promise no longer carries scenario detail that belongs lower in
  the stack

## Escalation triggers

- the feature promise is still too broad to derive clean scenarios
- the situation differences are actually implementation differences, not
  scenario differences
- deriving scenarios would require inventing user context not present upstream

## Arc use

- usually invoked during `Map Arc`
- occasionally invoked during `Shape Step` when execution is blocked by missing
  scenario structure

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep implementation-specific workflow detail out of the scenario layer.
