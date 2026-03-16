# Description Files

This file defines the contract for file-adjacent description nodes in the Code
layer.

## Location And Naming

- place one description file beside each source file that needs one
- prefix the description filename with `_`
- mirror the full source filename and append `.desc.md`
- example: `crypto.go` -> `_crypto.go.desc.md`

## Required Frontmatter

Use the frontmatter defined in `../../structure/frontmatter.md`.

The file `id` must use the `description/...` type.

## Required Section Order

1. `Purpose`
2. `Source Surface`
3. `Key Logic`
4. `Refs`
5. `Interfaces and Models`
6. `Verification Notes`

## Required Refs Subsections

Inside `Refs`, use these subsections in this order:

1. `Intent refs`
2. `Blueprint refs`
3. `Decision refs`
4. `Verification refs`

## Required Content Rules

- The H1 must be `Description: <source file name>`.
- `Source Surface` must name the repo-relative source path this file
  describes.
- `Intent refs` must contain at least one artifact ref.
- `Blueprint refs` or `Decision refs` must contain at least one artifact ref.
- `Verification refs` may contain surface refs when the verification surface is
  not an IDD artifact node.
- `Verification Notes` may include surface refs to tests or review outputs.

## Starter Template

```md
---
id: description/src/crypto-go
status: draft
owner: <team or role>
---
# Description: `crypto.go`

## Purpose

<high-level role of the source file>

## Source Surface

- `src/crypto.go`

## Key Logic

<important behavior or control flow>

## Refs

### Intent refs

- `behavior/checkout/cart-recalculation` | `intents/system/checkout/scenarios/guest-cart/behaviors/cart-recalculation.md`

### Blueprint refs

- `blueprint/checkout/request-model` | `intents/system/checkout/blueprints/request-model.md`

### Decision refs

- `(none)`

### Verification refs

- `(none)`

## Interfaces and Models

- <external interface, schema, or model>

## Verification Notes

- `(none)`
```
