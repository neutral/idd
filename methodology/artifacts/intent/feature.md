# Feature

This file defines the contract for file-backed feature nodes in the Intent
layer.

## Location

- `intents/system/<feature>/feature.md`
- `intents/system/<domain>/<feature>/feature.md`

## Required Frontmatter

Use the frontmatter defined in `../../structure/frontmatter.md`.

The file `id` must use the `feature/...` type.

## Required Section Order

1. `Summary`
2. `Background and Problem`
3. `Definition`
4. `Required Outcomes`
5. `Refs`

## Required Outcome Entry Shape

Each outcome in `Required Outcomes` must use a level-3 heading and include
these bullets in this order:

- `Outcome ID`
- `Statement`
- `Why it matters`
- `Satisfaction signals`

`Outcome ID` must use a stable kebab-case local name that is unique within the
feature.

Each `Outcome ID` is a durable Intent target and may be addressed as
`feature/...#<outcome-id>`.

## Required Content Rules

- `Definition` must include `Value statement`, `In scope`, and `Out of scope`.
- `Required Outcomes` must contain at least one outcome entry.
- `Goal refs` must contain at least one artifact ref.
- `Refs` must include the required subsections in the required order.

## Required Refs Subsections

Inside `Refs`, use these subsections in this order:

1. `Goal refs`
2. `Scenario refs`
3. `Assurance refs`
4. `Blueprint refs`
5. `Decision refs`

## Starter Template

```md
---
id: feature/checkout/cart
status: draft
owner: <team or role>
---
# Feature: <feature name>

## Summary

<one-paragraph description of the user-facing outcome and who it serves>

## Background and Problem

<why this feature exists, the current gap, and why now>

## Definition

- Value statement:
- In scope:
- Out of scope:

## Required Outcomes

### <outcome name>

- Outcome ID: `cart-contract-preserved`
- Statement:
- Why it matters:
- Satisfaction signals:

## Refs

### Goal refs

- `goal/system/<goal-slug>` | `intents/system/goals.md`

### Scenario refs

- `(none)`

### Assurance refs

- `(none)`

### Blueprint refs

- `(none)`

### Decision refs

- `(none)`
```
