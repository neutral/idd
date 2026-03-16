# Goals

This file defines the contract for goal catalog artifacts.

## Location

- `intents/system/goals.md`

## Required Frontmatter

Use the frontmatter defined in `../../structure/frontmatter.md`.

The catalog file `id` must use the `goal-catalog/...` type.

## Required Section Order

1. `Summary`
2. `Goal Catalog`
3. `Guardrails`
4. `Catalog Notes`

## Required Goal Entry Shape

Each goal entry in `Goal Catalog` must use a level-3 heading and include these
bullets in this order:

- `Goal ID`
- `Outcome`
- `Why it matters`
- `Success signals`
- `Feature refs`
- `Assurance refs`
- `Decision refs`

`Goal ID` must use the `goal/...` type defined in
`../../structure/frontmatter.md`.

Each `Goal ID` is a directly targetable durable Intent promise and may appear
in Blueprint or step `Intent targets`.

## Ref Rules

Use artifact refs in `Feature refs`, `Assurance refs`, and `Decision refs`:

```text
`<artifact-id>` | `<repo-relative-path>`
```

Use `(none)` only when a ref field is intentionally empty.

## Starter Template

```md
---
id: goal-catalog/system
status: draft
owner: <team or role>
---
# Goals

## Summary

<one-paragraph orientation>

## Goal Catalog

### <goal name>

- Goal ID: `goal/system/<goal-slug>`
- Outcome:
- Why it matters:
- Success signals:
- Feature refs:
  - `(none)`
- Assurance refs:
  - `(none)`
- Decision refs:
  - `(none)`

## Guardrails

- <system-level non-goal or boundary>

## Catalog Notes

- <notes about scope, review cadence, or catalog maintenance>
```
