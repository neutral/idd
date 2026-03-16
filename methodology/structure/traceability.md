# Artifact Graph

This file defines the durable artifact graph for IDD.

## Big Idea

IDD traceability is a graph, not a tag cloud.

Use this split:

- frontmatter defines artifact identity
- typed `Refs` surfaces define graph edges
- file placement helps navigation but does not imply a relationship

The goal is to reconstruct product intent, implementation contracts, and code
bridges without relying on chat history or folder adjacency.

## Reference Kinds

### Artifact Refs

Use artifact refs for links between durable or runtime artifacts that have
stable IDs.

Required item format:

```text
`<artifact-id>` | `<repo-relative-path>`
```

Optional narrative may follow after the path on the same line.

Examples:

- `` `feature/checkout/cart` | `intents/system/commerce/checkout/feature.md` ``
- `` `goal/system/checkout-trust` | `intents/system/goals.md` ``
- `` `decision/checkout/payment-provider` | `intents/system/commerce/checkout/decisions/payment-provider.md` ``
- `` `step-01-shape-checkout-model` | `.methodologies/idd/scratch/arc/step-01-shape-checkout-model.md` ``

Artifact refs are the only allowed format inside `... refs` fields that point
to graph nodes.

### Surface Refs

Use surface refs for non-IDD surfaces that matter to verification or
implementation but are not durable IDD graph nodes.

Examples:

- repo-relative paths to tests or source files
- dashboard URLs
- runbook URLs
- issue or ticket URLs

Surface refs should still be concrete and stable, but they do not use the
artifact-ref `id | path` format because they are not graph nodes.

### Intent Target IDs

Use intent target IDs when a Blueprint or Arc step must name the exact durable
Intent promise it is implementing, proving, or validating.

Intent target IDs are not graph edges. They are stable addresses inside the
Intent layer.

Allowed forms:

- `goal/...`
- `assurance/...`
- `feature/...#<kebab-case-outcome-id>`
- `scenario/...#<kebab-case-check-id>`
- `behavior/...#<kebab-case-check-id>`

Use the `#...` suffix only for stable local promise IDs defined inside the
referenced artifact.

Those local IDs must be unique within their containing artifact before they are
used as IDs.

Use intent target IDs in:

- Blueprint `Scope and Consumers > Intent targets`
- Arc step `Proof Target > Intent targets`

## Ref Authoring Rules

Apply these rules uniformly:

- every `Refs` subsection is a simple bullet list
- each bullet is either one ref item or the literal marker `(none)`
- do not mix artifact refs and narrative prose in one bullet
- do not rely on folder structure, neighboring filenames, or section order as
  an implied edge
- when extra explanation is needed, place it after the ref item on the same
  line or in ordinary prose outside the ref list

Use artifact refs everywhere except where a contract explicitly allows surface
refs.

## Addressing Catalog Entries

Catalog entries are durable graph nodes even though they share a file.

For refs that target catalog entries:

- the `id` is the authoritative target identity
- the path points to the catalog file that contains that entry
- an anchor may be added if the repo wants direct navigation, but the anchor is
  optional

Example:

- `` `goal/system/checkout-trust` | `intents/system/goals.md` ``
- `` `assurance/system/privacy-no-pii-in-logs` | `intents/system/assurances.md` ``

## Graph Node Types

Catalog files are durable file-backed artifacts with frontmatter and lifecycle,
but they are containers rather than graph nodes.

IDD uses two kinds of durable graph nodes:

- file-backed nodes, identified by frontmatter IDs
- catalog-entry nodes, identified inside a catalog file

File-backed nodes:

- `feature/...`
- `scenario/...`
- `behavior/...`
- `decision/...`
- `blueprint/...`
- `explainer/...`
- `description/...`

Catalog-entry nodes:

- `goal/...` entries inside a `goal-catalog/...` file
- `assurance/...` entries inside an `assurance-catalog/...` file

## Intent Target Sources

Intent target IDs come from these durable surfaces:

- goal IDs in `goals.md`
- assurance IDs in assurance catalogs
- feature `Outcome ID` values in `Required Outcomes`
- scenario `Check ID` values in `Checks (Scenario)`
- behavior `Check ID` values in `Checks (Behavior)`

## Required Refs Surfaces

Every file-backed artifact that participates in the durable graph must carry a
`## Refs` section whose subsection order is defined by that artifact's
contract.

Catalog container files keep graph edges inside each entry rather than in one
file-level `Refs` section because a single file may contain multiple graph
nodes.

Each artifact contract must say exactly which `Refs` subsections are required,
which accept only artifact refs, and which may also accept surface refs.

## Allowed Edge Vocabulary

Use only the allowed edge names for each artifact type.

### Goal Entries

- `Feature refs`
- `Assurance refs`
- `Decision refs`

### Feature Files

- `Goal refs`
- `Scenario refs`
- `Assurance refs`
- `Blueprint refs`
- `Decision refs`

### Scenario Files

- `Feature ref`
- `Behavior refs`
- `Assurance refs`
- `Blueprint refs`
- `Decision refs`

### Behavior Files

- `Scenario ref`
- `Assurance refs`
- `Blueprint refs`
- `Decision refs`

### Assurance Entries

- `Feature refs`
- `Scenario refs`
- `Blueprint refs`
- `Description refs`
- `Verification refs`
- `Decision refs`

### Blueprint Files

- `Intent refs`
- `Decision refs`
- `Explainer refs`
- `Verification refs`

### Explainer Files

- `Canonical contract refs`
- `Intent refs`

### Decision Files

- `Intent refs`
- `Blueprint refs`
- `Step refs`
- `Evidence refs`

### Description Files

- `Intent refs`
- `Blueprint refs`
- `Decision refs`
- `Verification refs`

## Graph Invariants

These invariants define the intended end state:

- every artifact ID is unique
- every artifact ref resolves to a real path
- the target path contains the referenced target ID or catalog-entry ID
- every graph edge is declared in an explicit `Refs` surface or catalog-entry
  ref field
- file placement never counts as traceability by itself
- every feature required outcome uses a stable kebab-case local ID
- every scenario check uses a stable kebab-case local ID
- every behavior check uses a stable kebab-case local ID
- every scenario has exactly one `Feature ref`
- every behavior has exactly one `Scenario ref`
- every decision has at least one entry under `Intent refs` or `Blueprint refs`
- every Blueprint has at least one entry under `Intent refs`
- every description file has at least one entry under `Intent refs` and at
  least one entry under `Blueprint refs` or `Decision refs`
- every scoped assurance catalog classifies the full inherited baseline before
  adding new local assurance nodes
- every decision that resolves a runtime conflict links the relevant step and
  evidence surfaces
- every code-facing chain is reconstructable through durable nodes and, when
  needed, surface refs

## Runtime Bridge

Arc step files keep their own `References` section because they are runtime
coordination artifacts, not durable product nodes.

That runtime surface should still bridge back to the durable graph:

- `Intent refs` point to Intent graph nodes
- `Blueprint refs` point to Blueprint graph nodes
- `Description refs` point to description graph nodes
- `Decision refs` point to decision graph nodes

## Machine-Checked Model

The verifier machine-checks this model through these assumptions:

- frontmatter provides stable IDs
- each artifact contract fixes section order and ref vocabulary
- artifact refs use one canonical `id | path` format
- surface refs are clearly separated from graph refs

Use `../validation/verifying-idd.md` for the active verification surface.

## Extending The Graph

To add a new graph node type later, define all of these before using it:

- frontmatter `id` prefix and node class
- required section order or catalog-entry shape
- allowed edge names
- whether each edge name accepts artifact refs only or also surface refs
- any node-specific invariants

That keeps future extensions additive and parseable instead of introducing
special-case link semantics.
