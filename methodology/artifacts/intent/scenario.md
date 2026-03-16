# Scenario

This file defines the contract for file-backed scenario nodes in the Intent
layer.

## Location

- `intents/system/<feature>/scenarios/<scenario>/scenario.md`
- `intents/system/<domain>/<feature>/scenarios/<scenario>/scenario.md`

## Required Frontmatter

Use the frontmatter defined in `../../structure/frontmatter.md`.

The file `id` must use the `scenario/...` type.

## Required Section Order

1. `Summary`
2. `Details`
3. `Checks (Scenario)`
4. `Refs`

## Required `Details` Subheadings

Inside `Details`, use these subheadings in this order:

1. `Actors`
2. `Triggers`
3. `Entry Conditions`
4. `High-Level Flow (Narrative)`
5. `Out of Scope for This Scenario`

## Required Refs Subsections

Inside `Refs`, use these subsections in this order:

1. `Feature ref`
2. `Behavior refs`
3. `Assurance refs`
4. `Blueprint refs`
5. `Decision refs`

## Required Scenario Check Shape

Each entry in `Checks (Scenario)` must use a level-3 heading and include these
bullets in this order:

- `Check ID`
- `Requirement`
- `Why it matters`
- `Evidence expectations`

`Check ID` must use a stable kebab-case local name that is unique within the
scenario.

Each `Check ID` is a durable Intent target and may be addressed as
`scenario/...#<check-id>`.

## Required Content Rules

- `Feature ref` must contain exactly one artifact ref.
- `Checks (Scenario)` must contain at least one check entry.
- `Behavior refs` point only to file-backed `behavior/...` nodes.

## Starter Template

```md
---
id: scenario/checkout/guest-cart
status: draft
owner: <team or role>
---
# Scenario: <scenario name>

## Summary

<short description that mirrors the parent feature wording>

## Details

### Actors

- <user or system>

### Triggers

- <entry path>

### Entry Conditions

- <state or assumption>

### High-Level Flow (Narrative)

<implementation-agnostic flow description>

### Out of Scope for This Scenario

- <excluded path>

## Checks (Scenario)

### <scenario check name>

- Check ID: `recalculate-before-response`
- Requirement:
- Why it matters:
- Evidence expectations:

## Refs

### Feature ref

- `feature/checkout/cart` | `intents/system/checkout/feature.md`

### Behavior refs

- `behavior/checkout/cart-recalculation` | `intents/system/checkout/scenarios/guest-cart/behaviors/cart-recalculation.md`

### Assurance refs

- `(none)`

### Blueprint refs

- `(none)`

### Decision refs

- `(none)`
```
