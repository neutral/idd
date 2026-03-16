# Assurances

This file defines the contract for assurance catalog artifacts and assurance
entry nodes in the Intent layer.

## Graph Role

- assurance catalog files are containers; each assurance entry inside them is a
  durable graph node
- each assurance ID is also a directly targetable durable Intent promise
- the global catalog defines the repository-wide baseline for code-governing
  quality, risk, and policy constraints
- scoped catalogs classify how that baseline applies to a feature or scenario
  and may add local assurance nodes when new risk appears
- durable assurance edges live in typed `Refs` fields, not in file placement or
  freeform metadata

## Locations

- global baseline: `intents/system/assurances.md`
- feature-scoped catalogs:
  `intents/system/<feature>/assurances.md` or
  `intents/system/<domain>/<feature>/assurances.md`
- scenario-scoped catalogs, if used:
  `intents/system/<feature>/<scenario>/assurances.md` or
  `intents/system/<domain>/<feature>/<scenario>/assurances.md`

## Required Frontmatter

Use the frontmatter defined in `../../structure/frontmatter.md`.

The catalog file `id` must use the `assurance-catalog/...` type.

## Required File Shapes

### Global Baseline Catalog Files

Global baseline files must use this section order:

1. `Summary`
2. `Baseline Catalog`
3. `Conflict Policy`
4. `Review and Ownership`

Section rules:

- `Summary` states the system scope the baseline governs.
- `Baseline Catalog` contains only assurance entry nodes that use the required
  assurance entry shape below.
- `Conflict Policy` defines default resolution rules across assurance
  categories.
- `Review and Ownership` defines baseline owners, review cadence, and update
  triggers.

### Scoped Catalog Files

Feature-scoped and scenario-scoped catalog files must use this section order:

1. `Summary`
2. `Scoped Critical Paths`
3. `Baseline Disposition`
4. `Scoped Assurance Entries`
5. `Overrides and Review Dates`

Section rules:

- `Summary` states the scope, parent baseline, and what changed in this scope.
- `Scoped Critical Paths` contains only critical-path entries that use the
  required critical-path shape below.
- `Baseline Disposition` classifies every inherited baseline assurance exactly
  once.
- `Scoped Assurance Entries` contains only scoped assurance entry nodes that
  use the required assurance entry shape below.
- `Overrides and Review Dates` contains only weakening overrides that require
  explicit review.

## Required Critical-Path Entry Shape

Each critical-path entry in `Scoped Critical Paths` must use a level-3 heading
and include these bullets in this order:

- `Path ID`
- `Summary`
- `Scenario refs`
- `Primary risks`

`Path ID` is a stable local slug for the scoped catalog. It is not a frontmatter
node type.

Use artifact refs in `Scenario refs`:

```text
`<artifact-id>` | `<repo-relative-path>`
```

## Required Baseline-Disposition Shape

Each entry in `Baseline Disposition` must use a level-3 heading and include
these bullets in this order:

- `Assurance ID`
- `Disposition`
- `Rationale`
- `Compensating controls`
- `Review-by`
- `Decision refs`

Allowed `Disposition` values:

- `Inherited`
- `Overrides`
- `Not applicable`

Disposition rules:

- `Assurance ID` must point to a baseline `assurance/...` node from the global
  catalog.
- every baseline assurance must appear exactly once in each scoped catalog.
- `Rationale` is required for `Overrides` and `Not applicable`.
- `Compensating controls` is required when the scoped change weakens the
  baseline.
- `Review-by` is required when the scoped change weakens the baseline.
- `Decision refs` is required for `Overrides` and optional otherwise.
- use `(none)` only when a field is intentionally empty under these rules.

## Required Assurance Entry Shape

Each assurance entry in `Baseline Catalog` or `Scoped Assurance Entries` must
use a level-3 heading and include these bullets in this order:

- `Assurance ID`
- `Applies to`
- `Category`
- `Criticality`
- `Priority`
- `Quality scenario`
- `Metric definition`
- `Targets and budgets`
- `Evidence`
- `Implementation patterns and examples`
- `Refs`
- `Lifecycle`
- `Conflicts and Tradeoffs`

Optional trailing field:

- `Notes`

### Required Nested Field Shapes

`Evidence` must include these nested bullets in this order:

- `Checks`
- `Operational signals`
- `Reviews`

`Implementation patterns and examples` must include these nested bullets in
this order:

- `Preferred patterns and helpers`
- `Do`
- `Do not`
- `Reference examples`

`Refs` must include these nested bullets in this order:

- `Feature refs`
- `Scenario refs`
- `Blueprint refs`
- `Description refs`
- `Verification refs`
- `Decision refs`

`Lifecycle` must include these nested bullets in this order:

- `Owner`
- `Status`
- `Review-by`

## Refs Rules

- `Feature refs`, `Scenario refs`, `Blueprint refs`, `Description refs`, and
  `Decision refs` use artifact refs only.
- `Verification refs` may use artifact refs or surface refs.
- global baseline assurances may use `(none)` in `Feature refs` and
  `Scenario refs` when they intentionally apply repository-wide.
- scoped assurance entries must include at least one entry under
  `Feature refs` or `Scenario refs`.
- every scoped assurance that materially changes a baseline constraint must
  include at least one entry under `Decision refs`.

## Coverage And Exhaustiveness Rules

- the global baseline catalog is exhaustive for constraints that should shape
  code, configuration, tests, or instrumentation in this repository.
- each scoped catalog must classify the full inherited baseline before adding
  local assurance entries.
- each critical path must be covered by at least one assurance for reliability
  and error handling.
- each critical path involving sensitive data, auth, or entitlements must be
  covered by at least one assurance for security or privacy.
- each critical path must be covered by at least one assurance for
  observability.
- each user-facing or latency-sensitive critical path must be covered by at
  least one assurance for performance or capacity.

Operational concerns that are not enforceable through repository artifacts may
live elsewhere, but the nearest relevant assurance entry should link to those
surfaces when they matter to delivery or review.

Assurance IDs may appear directly in Blueprint or step `Intent targets`.

## Precedence And Override Rules

- more specific scope wins only when the override is explicit in
  `Baseline Disposition`.
- silence never counts as inheritance; every baseline assurance must be
  classified.
- weakening a baseline requires all of these:
  - `Disposition: Overrides`
  - rationale
  - compensating controls
  - review-by date
  - supporting `Decision refs`
- every `Overrides` disposition must be backed by at least one scoped assurance
  entry in `Scoped Assurance Entries`.
- `Overrides and Review Dates` is the review queue for weakening overrides; do
  not repeat inherited or stricter-than-baseline changes there.

## Lifecycle Rules

- use the same status vocabulary as `../../structure/frontmatter.md`:
  `draft`, `active`, `deprecated`, `disabled`.
- do not mark an assurance entry `active` until its checks and operational
  signals exist or are committed as launch-ready surfaces.
- after an incident, update the affected assurance entries instead of leaving
  the gap only in chat logs, tickets, or runbooks.

## Starter Templates

### Global Baseline Catalog Template

```md
---
id: assurance-catalog/system
status: draft
owner: <team or role>
---
# Assurances

## Summary

<one-paragraph description of the baseline scope>

## Baseline Catalog

### <assurance name>

- Assurance ID: `assurance/system/<assurance-slug>`
- Applies to: Global baseline
- Category:
- Criticality:
- Priority:
- Quality scenario:
- Metric definition:
- Targets and budgets:
- Evidence:
  - Checks:
  - Operational signals:
  - Reviews:
- Implementation patterns and examples:
  - Preferred patterns and helpers:
  - Do:
  - Do not:
  - Reference examples:
- Refs:
  - Feature refs:
    - `(none)`
  - Scenario refs:
    - `(none)`
  - Blueprint refs:
    - `(none)`
  - Description refs:
    - `(none)`
  - Verification refs:
    - `(none)`
  - Decision refs:
    - `(none)`
- Lifecycle:
  - Owner:
  - Status:
  - Review-by:
- Conflicts and Tradeoffs:

## Conflict Policy

- <default precedence rule>

## Review and Ownership

- Baseline owner:
- Review cadence:
- Review triggers:
```

### Scoped Catalog Template

```md
---
id: assurance-catalog/<scope>
status: draft
owner: <team or role>
---
# Assurances

## Summary

<one-paragraph description of this scope and what changed>

## Scoped Critical Paths

### <critical path name>

- Path ID:
- Summary:
- Scenario refs:
  - `scenario/checkout/guest-cart` | `intents/system/checkout/scenarios/guest-cart/scenario.md`
- Primary risks:

## Baseline Disposition

### <baseline assurance name>

- Assurance ID: `assurance/system/<assurance-slug>`
- Disposition:
- Rationale:
- Compensating controls:
- Review-by:
- Decision refs:
  - `(none)`

## Scoped Assurance Entries

### <scoped assurance name>

- Assurance ID: `assurance/<scope>/<assurance-slug>`
- Applies to:
- Category:
- Criticality:
- Priority:
- Quality scenario:
- Metric definition:
- Targets and budgets:
- Evidence:
  - Checks:
  - Operational signals:
  - Reviews:
- Implementation patterns and examples:
  - Preferred patterns and helpers:
  - Do:
  - Do not:
  - Reference examples:
- Refs:
  - Feature refs:
    - `feature/checkout/cart` | `intents/system/checkout/feature.md`
  - Scenario refs:
    - `(none)`
  - Blueprint refs:
    - `(none)`
  - Description refs:
    - `(none)`
  - Verification refs:
    - `(none)`
  - Decision refs:
    - `(none)`
- Lifecycle:
  - Owner:
  - Status:
  - Review-by:
- Conflicts and Tradeoffs:

## Overrides and Review Dates

- Baseline assurance ID:
- Scoped assurance ID:
- Review-by:
- Compensating controls:
- Decision refs:
  - `(none)`
```
