# IDD Domain Artifacts

This file routes readers to the durable artifact contracts in IDD.

## Big Idea

IDD durable artifacts form an explicit graph:

- frontmatter names file-backed artifacts; some are direct nodes and some are
  catalog containers
- catalog entries carry their own node IDs when one file contains many nodes
- typed `Refs` surfaces connect the graph

Within that graph, Intent artifacts define the durable promises that Blueprint
contracts and Arc steps are allowed to select and prove.

Treat the artifact docs below as normative contracts for produced artifacts, not
as loose examples.

## Intent Coverage

Intent is a family of artifacts, not one document type.

Together, the Intent family covers this slice of product truth:

- durable reason for the promise
- scope and boundaries
- goal -> feature -> scenario -> behavior decomposition
- user or system context
- required user-visible outcomes
- observability and satisfaction signals
- what must not happen
- cross-cutting quality constraints
- prior durable decisions that narrow the solution space
- stable IDs and refs for later targeting
- criticality where it materially shapes delivery
- lifecycle stability through durable artifact status

Use this split:

- `intent/goals.md`: durable why, system-level outcomes, and the top of the
  Intent decomposition
- `intent/feature.md`: scoped product promise, in-scope and out-of-scope
  boundaries, and required outcomes with satisfaction signals
- `intent/scenario.md`: applicability context, actors, triggers, entry
  conditions, and scenario-level checks
- `intent/behavior.md`: tighter externally meaningful rules, inputs and
  conditions, outputs and effects, and behavior-level checks
- `intent/assurances.md`: security, privacy, reliability, performance,
  compliance, auditability, criticality, and measurable quality constraints
- `intent/decision.md`: prior durable choices that narrow the acceptable
  solution space

Shared structure carries two more parts of the Intent contract:

- `../structure/frontmatter.md`: durable identity, lifecycle status, and
  artifact stability
- `../structure/traceability.md`: stable refs and target addresses so
  Blueprint, Arc, and later validation can select the right promise

## Intent Family

- `intent/goals.md`: goal catalog container plus `goal/...` entry nodes
- `intent/feature.md`: `feature/...` nodes
- `intent/scenario.md`: `scenario/...` nodes
- `intent/behavior.md`: `behavior/...` nodes
- `intent/assurances.md`: assurance catalog container plus `assurance/...`
  entry nodes
- `intent/decision.md`: `decision/...` nodes

## Blueprint Family

- `blueprint/blueprint.md`: `blueprint/...` nodes
- `blueprint/explainer.md`: `explainer/...` nodes

## Code Support Family

- `code/description.md`: `description/...` nodes that bridge into code and
  verification surfaces

## Shared Structure Contracts

- `../structure/frontmatter.md`: file-backed artifact identity and lifecycle
- `../structure/traceability.md`: graph edges, ref formats, and invariants
- `../structure/layout.md`: placement rules and path conventions

## Not Defined Here

- runtime templates and installed runtime state live in `../ARTIFACTS.md`
- runtime sequencing and Arc gates live in `../ARC.md` and `../arc/`
- library claim-catalog routing lives in `../LIBRARY.md` and
  `../../library/overview.md`

## Runtime Relationship

Arc is the transient execution layer that moves durable artifacts forward.
Lasting product truth belongs in the artifact graph defined here. Arc should
update that graph, cite it, and hand back to it rather than becoming a parallel
system of record.
