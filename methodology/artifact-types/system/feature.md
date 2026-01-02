# Feature

A Feature is an Intent artifact that defines the user outcome, scope, and scenarios the system must support. It is implementation-agnostic and sets the obligations that Blueprint and Code must satisfy.

- Location: `intents/system/<feature>/feature.md`
- Related files: `assurances.md` for feature assurances, `scenarios/**` for scenario details, `blueprints/` for feature-scoped contracts, `decisions/` for rationale.
- Role: anchor the why and what. Behaviors, assurances, and blueprint contracts should trace back here.

Create a feature file with this template:

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

One-paragraph description of the user-facing outcome and who it serves.

## Background and Problem

Why this feature exists. Include current gaps, supporting data/anecdotes, and why now.

## Definition

- Value statement: For [persona], enable [capability], so they can [benefit].
- In scope:
- Out of scope:

## Goals and Outcomes

Success criteria and measures (ideally measurable).

## Scenarios

List the scenarios this feature enables. Link to `scenarios/<name>/scenario.md`.
