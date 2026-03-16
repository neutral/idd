# Conflict Resolution

This contract defines how IDD resolves or defers conflicts when current-run
user direction, Intent, Blueprint, Code, or decision artifacts disagree.

## Precedence Order

Use this order when determining which source controls the current run:

1. current-run user direction
2. recorded ADR or decision artifacts
3. Intent
4. Blueprint
5. Code

## How To Apply Precedence

- Current-run user direction overrides artifacts for the current run only.
- If current-run user direction establishes durable product truth, the relevant
  intent, blueprint, and decision artifacts must be updated before closeout.
- Decisions override lower-ranked artifacts only within their recorded scope.
- Intent overrides Blueprint and Code when product obligation is the issue.
- Blueprint overrides Code when implementation drift is the issue.
- Code never silently overrides higher-trust artifacts. If Code appears more
  correct, record a reconciliation path instead of treating Code as authority by
  default.

## What Counts As A Non-Trivial Conflict

Treat a conflict as non-trivial when it changes or threatens any of:

- the user outcome being served,
- the implementation contract or interface shape,
- the allowed boundary or authority posture,
- the proof story or closeout posture,
- the durable decision history for the touched scope.

## Required Conflict Record

Every non-trivial conflict must record all of the following before the step is
blocked or closed:

- the conflicting sources,
- the chosen authority basis,
- the reconciliation action,
- the affected refs,
- the required durable follow-up artifacts, if any.

Record this in:

- the step `Run Ledger`,
- the Arc evidence item that preserves the conflict thread,
- the step `Proof Packet` or `Working Record` when proof context needs to be
  preserved in the step file,
- the relevant decision artifact when the outcome outlives the current step.

## Durable Outcome Rule

If the reconciliation outcome should remain true after the current step, link it
into the relevant decision artifact. Durable conflict outcomes must not live
only in Arc summaries or Arc evidence.

## Escalation Rules

- If precedence is unclear after applying the fixed order, stop and return to
  intake or refinement.
- If scope or permissions prevent the necessary reconciliation edits, block the
  step rather than partially resolving the conflict.
- If the conflict requires owner approval or follow-up ownership, block the
  step until that owner path is explicit.
- If the conflict is unresolved at closeout, use `Outcome: block`.
