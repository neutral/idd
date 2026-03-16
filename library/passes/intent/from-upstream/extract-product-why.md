# Pass: extract-product-why

## Purpose

Distill the enduring product reason behind the current promise so Intent keeps
the durable why, not only the surface request.

## Pipeline position

- `intent/from-upstream`

## Strengthens

- durable motivation
- goal clarity
- outcome interpretation

## Creates or updates

- goal catalog entries
- feature files
- decision files when durable narrowing depends on the why

## Use This Pass When

- a request says what should happen but not why it matters
- the current feature or goal language is technically plausible but easy to
  misinterpret
- later prioritization, tradeoff, or assurance decisions need the durable why

## Not for

- user-research synthesis
- market exploration
- roadmap prioritization

## Inputs

- upstream request or product notes
- existing goals and features in the same scope
- any known guardrails or system priorities

## Preconditions

- the product reason can be stated without recreating the full discovery trail
- the pass can tie the why to the current durable promise

## Pass Steps

1. Identify the durable product reason that should survive implementation
   changes.
2. Strip away timing, delivery, and organizational context that should not live
   in Intent.
3. Place the why in the narrowest durable location that should own it.
4. Align feature or goal language so the promise and its why reinforce each
   other.

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when: this pass materially clarifies the durable product reason behind
  the current promise
- Before posture: the promise is stated without a stable why or with only
  transient rationale
- After posture: the enduring product reason is explicit and connected to the
  promise
- Evidence this pass can supply:
  - updated goal or feature sections
  - removed transient rationale
  - before and after wording that changes interpretation

## Outputs

- durable why language fit for goals or features
- clearer interpretation of why the promise matters

## Hand-off

- continue with `derive-goal-stack` or `tighten-goal-outcomes`

## Quality checks

- the why would still hold if implementation details changed
- the why changes how later readers interpret the promise
- the why is brief enough to stay durable

## Escalation triggers

- the why is still disputed or exploratory
- the only available rationale is organizational timing or ticket context
- extracting a durable why would require new research conclusions

## Arc use

- usually invoked during `Map Arc`
- occasionally invoked during `Shape Step` when the current Intent slice lacks
  durable product motivation

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used the
  pass.
- Do not defer pass-effect capture to a later phase.
- Keep raw discovery material outside IDD if it does not belong in durable
  Intent
