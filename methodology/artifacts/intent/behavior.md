# Behavior

This file defines the contract for file-backed behavior nodes in the Intent
layer.

## Location

- `intents/system/<feature>/scenarios/<scenario>/behaviors/<behavior>.md`
- `intents/system/<domain>/<feature>/scenarios/<scenario>/behaviors/<behavior>.md`

## Required Frontmatter

Use the frontmatter defined in `../../structure/frontmatter.md`.

The file `id` must use the `behavior/...` type.

## Required Section Order

1. `Summary`
2. `Inputs and Conditions`
3. `Outputs and Effects`
4. `Definitions`
5. `Checks (Behavior)`
6. `Refs`

## Required Definition Fields

Inside `Definitions`, record these lines in order and use `(none)` when a
category does not apply:

- `Interface refs`
- `State and error refs`
- `Authorization and audit refs`
- `Telemetry refs`

## Required Refs Subsections

Inside `Refs`, use these subsections in this order:

1. `Scenario ref`
2. `Assurance refs`
3. `Blueprint refs`
4. `Decision refs`

## Required Behavior Check Shape

Each entry in `Checks (Behavior)` must use a level-3 heading and include these
bullets in this order:

- `Check ID`
- `Requirement`
- `Why it matters`
- `Evidence expectations`

`Check ID` must use a stable kebab-case local name that is unique within the
behavior.

Each `Check ID` is a durable Intent target and may be addressed as
`behavior/...#<check-id>`.

## Required Content Rules

- `Scenario ref` must contain exactly one artifact ref.
- `Checks (Behavior)` must contain at least one check entry.

## Starter Template

```md
---
id: behavior/checkout/cart-recalculation
status: draft
owner: <team or role>
---
# Behavior: <behavior name>

## Summary

<one-sentence summary of the behavior>

## Inputs and Conditions

- <required state or precondition>

## Outputs and Effects

- <observable effect>

## Definitions

- Interface refs:
- State and error refs:
- Authorization and audit refs:
- Telemetry refs:

## Checks (Behavior)

### <behavior check name>

- Check ID: `validate-request-model`
- Requirement:
- Why it matters:
- Evidence expectations:

## Refs

### Scenario ref

- `scenario/checkout/guest-cart` | `intents/system/checkout/scenarios/guest-cart/scenario.md`

### Assurance refs

- `(none)`

### Blueprint refs

- `(none)`

### Decision refs

- `(none)`
```
