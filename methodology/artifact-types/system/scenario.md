# Scenario

A Scenario is an Intent artifact that describes a user/system situation a feature must support. It is implementation-agnostic and contains the behaviors and checks that Code will be validated against.

- Location: `intents/system/<feature>/scenarios/<scenario>/scenario.md` or `intents/system/<domain>/<feature>/scenarios/<scenario>/scenario.md`
- Role: make the feature concrete through narratives, actors, and behaviors; link to Blueprint contracts that govern the scenario.

Create a scenario file with this template:

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

Short description of the scenario. Mirror the wording used in the parent feature.

## Details

Add scaffolding and context as needed.

### Actors

Users or systems involved.

### Triggers

Entry paths that lead into the scenario.

### Entry Conditions

State/assumptions before the flow begins.

### High-Level Flow (Narrative)

Describe the experience or flow without specifying implementation.

### Out of Scope for This Scenario

Flows intentionally excluded.

## Checks (Scenario)

List verifiable checks at the scenario level. Give each check an ID.

## Behaviors

Behaviors are externally observable obligations. Keep them testable, measurable, and implementation-neutral (avoid “use CSS variables,” prefer “persist theme preference across sessions”).

Behaviors can be kept inline in this file or stored as separate behavior files (for example, under `behaviors/`) when the scenario grows large. The important part is that the behavior content and checks exist in durable files so agents can read them and write results back.

For the behavior structure and writing template, see `methodology/artifact-types/system/behavior.md`.
