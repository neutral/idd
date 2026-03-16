# Blueprint Files

This file defines the contract for file-backed Blueprint nodes.

## Locations

- global blueprints: `intents/blueprints/**`
- feature-scoped blueprints:
  `intents/system/<feature>/blueprints/**` or
  `intents/system/<domain>/<feature>/blueprints/**`

## Required Frontmatter

Use the frontmatter defined in `../../structure/frontmatter.md`.

The file `id` must use the `blueprint/...` type.

## Required Section Order

1. `Summary`
2. `Scope and Consumers`
3. `Contract`
4. `Failure and Boundary Conditions`
5. `Verification Notes`
6. `Refs`
7. `Change Notes`

## Required Refs Subsections

Inside `Refs`, use these subsections in this order:

1. `Intent refs`
2. `Decision refs`
3. `Explainer refs`
4. `Verification refs`

## Required `Scope and Consumers` Fields

Inside `Scope and Consumers`, record these lines in this order:

- `Scope`
- `Consumers`
- `Intent targets`

`Intent targets` must list one or more exact durable Intent targets using the
forms defined in `../../structure/traceability.md`.

## Required Content Rules

- `Intent refs` must reference the feature, scenario, behavior, goal, or
  assurance nodes this Blueprint serves.
- `Intent refs` must contain at least one artifact ref.
- `Intent targets` must name the exact durable Intent promises this Blueprint
  concretizes.
- `Contract` must carry the actual definition. Put subtype-specific
  subsections inside `Contract`; do not replace the required opening surface.
- `Verification refs` may contain surface refs when the verification surface is
  not an IDD artifact node.

## Starter Template

```md
---
id: blueprint/checkout/request-model
status: draft
owner: <team or role>
---
# Blueprint: <contract name>

## Summary

<one-paragraph summary of the contract>

## Scope and Consumers

- Scope:
- Consumers:
- Intent targets:
  - `feature/checkout/cart#cart-contract-preserved`
  - `scenario/checkout/guest-cart#recalculate-before-response`
  - `behavior/checkout/cart-recalculation#validate-request-model`

## Contract

<schemas, definitions, examples, invariants, or structured rules>

## Failure and Boundary Conditions

- <error behavior, explicit limit, or `(none)`>

## Verification Notes

- <tests, reviews, or consuming surfaces>

## Refs

### Intent refs

- `feature/checkout/cart` | `intents/system/checkout/feature.md`

### Decision refs

- `(none)`

### Explainer refs

- `(none)`

### Verification refs

- `(none)`

## Change Notes

- Version:
- Change impact:
```
