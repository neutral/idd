# Explainer

This file defines the contract for optional explainer nodes in the Blueprint
layer.

## Locations

- `intents/blueprints/<scope>/`
- `intents/system/<feature>/blueprints/`
- `intents/system/<domain>/<feature>/blueprints/`

## Required Frontmatter

Use the frontmatter defined in `../../structure/frontmatter.md`.

The file `id` must use the `explainer/...` type.

## Required Section Order

1. `Summary`
2. `Explanation`
3. `Refs`
4. `Boundaries and Non-Goals`

## Required Refs Subsections

Inside `Refs`, use these subsections in this order:

1. `Canonical contract refs`
2. `Intent refs`

## Required Content Rules

- `Canonical contract refs` must link the authoritative Blueprint nodes.
- `Canonical contract refs` must contain at least one artifact ref.
- `Explanation` may clarify difficult material but may not introduce new
  normative rules.

## Starter Template

```md
---
id: explainer/checkout/request-lifecycle
status: draft
owner: <team or role>
---
# Explainer: <topic>

## Summary

<what this explainer helps a reader understand>

## Explanation

<plain-language explanation>

## Refs

### Canonical contract refs

- `blueprint/checkout/request-model` | `intents/system/checkout/blueprints/request-model.md`

### Intent refs

- `(none)`

## Boundaries and Non-Goals

- <what this explainer does not define>
```
