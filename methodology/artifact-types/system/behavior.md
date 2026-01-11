# Behavior

A Behavior is an Intent artifact that describes an externally observable obligation the system must satisfy. It is implementation-agnostic and is validated by explicit checks.

Behaviors can be stored in either form:

- Inline as a section inside a scenario file (`intents/system/<feature>/scenarios/<scenario>/scenario.md` or `intents/system/<domain>/<feature>/scenarios/<scenario>/scenario.md`).
- As a separate file (for example, under `intents/system/<feature>/scenarios/<scenario>/behaviors/` or `intents/system/<domain>/<feature>/scenarios/<scenario>/behaviors/`) when the scenario grows large or you want easier review, reuse, or parallel work.

Create a behavior file with this template:

```yaml
---
id: <id>
status: draft
owner: <team or role>
upstream: []
module: []
tags: []
---
```

## Summary

One-sentence summary of the behavior.

## Inputs and Conditions

Required state or preconditions.

## Outputs and Effects

What must be true after the behavior.

## Definitions

Pin the contracts the behavior depends on. Reference Blueprint files for:

- Interfaces & Contracts: entry points (API path/UI control/topic), request/response schemas, examples (happy path + edge cases).
- State, Errors, Idempotency: state transitions; idempotency keys; error taxonomy with user-facing copy and codes.
- Authorization & Audit: required roles/scopes; audit events; PII handling with targets defined in linked assurances.
- Telemetry & Observability Hooks: events/metrics/traces, correlation IDs.

## Checks

List verifiable checks. Give each check an ID and keep them implementation-neutral.
