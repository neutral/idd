# Decisions

This file defines the contract for durable decision nodes in the Intent layer.

## Locations

- global decisions: `intents/decisions/`
- feature- or scenario-scoped decisions:
  `intents/system/<feature>/decisions/`,
  `intents/system/<domain>/<feature>/decisions/`, or a nested scope

## Required Frontmatter

Use the frontmatter defined in `../../structure/frontmatter.md`.

The file `id` must use the `decision/...` type.

## Required Section Order

1. `Summary`
2. `Context`
3. `Decision`
4. `Options Considered`
5. `Consequences`
6. `Implementation Details`
7. `Verification`
8. `Refs`
9. `Status and History`

## Required Refs Subsections

Inside `Refs`, use these subsections in this order:

1. `Intent refs`
2. `Blueprint refs`
3. `Step refs`
4. `Evidence refs`

`Step refs` and `Evidence refs` may be `(none)` unless the decision resolved a
live Arc conflict. When a decision resolves a live Arc conflict, both fields
must be populated and the durable outcome must not live only in Arc files or
evidence.

## Required Content Rules

- `Intent refs` or `Blueprint refs` must contain at least one artifact ref.
- `Step refs` use artifact refs when the decision links back to Arc step files.
- `Evidence refs` may use artifact refs or surface refs depending on the
  evidence surface.

## Starter Template

```md
---
id: decision/checkout/payment-provider
status: draft
owner: <team or role>
---
# Decision: <decision name>

## Summary

<one-paragraph summary of the decision and why it exists>

## Context

<background, constraints, forces, requirements, and risks>

## Decision

<the choice made, including scope and rationale>

## Options Considered

- <option>: <pros and cons>

## Consequences

- Positive:
- Negative:
- Follow-up:

## Implementation Details

<implementation-specific impact when needed>

## Verification

- <tests, reviews, metrics, or checks>

## Refs

### Intent refs

- `feature/checkout/cart` | `intents/system/checkout/feature.md`

### Blueprint refs

- `(none)`

### Step refs

- `(none)`

### Evidence refs

- `(none)`

## Status and History

- Status:
- Decided on:
- Reviewed by:
- Review trigger:
```
