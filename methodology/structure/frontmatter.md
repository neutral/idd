# Artifact Frontmatter

This file defines the identity and lifecycle frontmatter for durable IDD
artifacts.

## Big Idea

Frontmatter names the file-backed artifact surface. It does not carry graph
edges.

For file-backed graph nodes, frontmatter names the node directly.

For catalog container files, frontmatter names the container file while the
durable graph nodes inside it use entry IDs.

Use frontmatter for:

- stable identity
- lifecycle status
- ownership

Do not use frontmatter for:

- parent or child relationships
- dependency links
- verification links
- freeform grouping metadata

Those belong in typed `Refs` surfaces defined in `traceability.md`.

## Applies To

This frontmatter contract applies to these file-backed artifact surfaces:

- goal catalog files
- feature files
- scenario files
- behavior files
- assurance catalog files
- decision files
- Blueprint files
- explainer files
- description files

## Required Shape

```yaml
---
id: feature/checkout/cart
status: draft
owner: team-or-role
---
```

## Field Rules

- `id`: canonical artifact or catalog ID
- `status`: one of `draft`, `active`, `deprecated`, or `disabled`
- `owner`: team, role, or maintainer group responsible for the artifact

No other frontmatter fields are part of the default IDD contract.

## Status Semantics

Use `status` as a lifecycle signal, not as a workflow diary:

- `draft`: the artifact shape exists, but the contract is still being formed or
  is not yet relied on
- `active`: the artifact is the current authoritative surface for its scope
- `deprecated`: the artifact still matters for history or compatibility, but a
  newer artifact surface or node set now supersedes it
- `disabled`: the artifact intentionally does not participate in the current
  system and should not receive new downstream links

If the repository needs finer workflow states, express them in body content or
runtime coordination artifacts rather than expanding frontmatter.

## ID Vocabulary

The first path segment in `id` must be one of:

- `goal-catalog`
- `goal`
- `feature`
- `scenario`
- `behavior`
- `assurance-catalog`
- `assurance`
- `decision`
- `blueprint`
- `explainer`
- `description`

Use `/`-separated kebab-case segments after the type segment.

## File-Backed Versus Catalog-Entry IDs

Use these IDs in file frontmatter:

- `goal-catalog/...`
- `feature/...`
- `scenario/...`
- `behavior/...`
- `assurance-catalog/...`
- `decision/...`
- `blueprint/...`
- `explainer/...`
- `description/...`

`goal-catalog/...` and `assurance-catalog/...` identify catalog container
files, not the individual durable graph nodes inside them.

Use these IDs inside catalog entries that live within a file:

- `goal/...`
- `assurance/...`

Catalog-entry IDs are required inside `goals.md` and `assurances.md` entry
shapes because one file may contain multiple graph nodes.

## ID Construction Rules

- Keep the same `id` when the artifact meaning stays the same.
- Change the `id` only when the artifact's meaning or scope changes
  materially.
- Choose scope segments that stay stable if code moves.
- Do not encode transient branch names, ticket numbers, or timestamps in
  artifact IDs.

Examples:

- `goal-catalog/system`
- `goal/system/checkout-trust`
- `feature/checkout/cart`
- `scenario/checkout/guest-cart`
- `behavior/checkout/cart-recalculation`
- `assurance-catalog/system`
- `assurance/system/privacy-no-pii-in-logs`
- `decision/checkout/payment-provider`
- `blueprint/checkout/request-model`
- `explainer/checkout/request-lifecycle`
- `description/src/payments/charge-go`

## Path Alignment

File placement is for navigation. `id` is the authoritative identity.

Even so, IDs and paths should align semantically:

- catalog container IDs should match the scope the catalog governs
- feature IDs should match the feature scope folder
- scenario and behavior IDs should match their parent feature scope
- Blueprint and decision IDs should match the scope they govern
- description IDs should mirror the source-file path they describe in a stable
  slash-based slug

## Extending The Vocabulary

Do not introduce a new frontmatter `id` type informally.

Before a new frontmatter type is allowed, define all of these:

- its `id` prefix in this file
- whether it is a file-backed node, a file-backed container, or a catalog-entry
  node
- its required section order in an artifact contract
- its allowed `Refs` vocabulary in `traceability.md`
- its graph invariants and lifecycle expectations

That keeps the graph mechanically expandable instead of drifting into
repo-specific exceptions.
