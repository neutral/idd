# Intent-Driven Development

This file describes what IDD is, what it optimizes, and which companion
documents own the operational rules.

## Summary

- What IDD optimizes: durable product context, explicit implementation
  contracts, and bounded agent execution.
- Where to use it: repos that want Intent, Blueprint, and Code to stay aligned
  as humans and agents collaborate.
- Non-goals: using chat history as the system of record, treating Arc as
  durable product storage, or letting code drift from product obligations.

## Operating Model

- Representation: IDD keeps durable product truth in Intent, Blueprint, and
  Code artifacts.
- Identity: frontmatter identifies file-backed artifacts, while catalog entries
  carry entry IDs for the durable graph nodes inside catalog files.
- Graph: typed `Refs` surfaces connect durable artifacts into one inspectable
  product graph.
- Execution: Arc is the runtime workflow that maps, executes, proves, and
  closes one bounded pass of work.
- Governance: `status.md` defines operating scope and permissions for each
  installed runtime.
- Claims and evidence: each Arc keeps one Arc-scoped evidence run as the
  canonical proof surface for later validation, while step files preserve the
  step-local proof and review summaries that point to that evidence.
- Memory: durable outcomes belong in product artifacts and decisions, not in
  transient Arc working state.

## Companion Documents

- Runtime entrypoint: `ARC.md`
- `ARC.md`: runtime decision contract for status gates, phase selection, and
  re-entry behavior.
- `arc/overview.md`: methodology-owned routing surface for Arc stages,
  contracts, artifacts, and templates.
- `ARTIFACTS.md`: runtime artifact inventory for Arc templates and installed
  runtime state.
- `LIBRARY.md`: library-layer purpose, structure, and runtime usage rules.
- `LABELS.md`: semantic label behavior. IDD uses explicit no-label mode.
- `artifacts/overview.md`: domain artifact families for Intent, Blueprint, and
  Code-support artifacts.
- `structure/layout.md`: default file layout for durable product artifacts and
  Arc runtime state.
- `structure/frontmatter.md`: file-backed artifact identity and lifecycle
  contract.
- `structure/traceability.md`: durable artifact graph and ref vocabulary.
- `validation/verifying-idd.md`: verifier commands, checks, and output
  expectations.

## Layer Model

IDD uses three product layers and one runtime workflow:

- Intent: durable user-facing promises, including goals, feature outcomes,
  scenario checks, behavior checks, assurances, and decisions.
- Blueprint: durable implementation contracts that concretize those promises.
- Code: the executable implementation plus tests and description files that
  realize and trace those contracts.
- Arc: the transient workflow that selects a bounded set of Intent targets,
  moves the supporting Blueprint and Code surfaces, and records proof and
  closeout.

Work may start in any layer. IDD requires the layers to be reconciled.
Code-first changes must be captured back into Intent and Blueprint, and new
Intent or Blueprint obligations must be reflected in Code.

A step becomes execution-ready only when its exact durable Intent targets and
the Blueprint surfaces that constrain them are explicit.

## Intent Layer

Intent is the last durable product layer before technical design.

Its job is to reduce the space of acceptable future implementations.

It does not hold brainstorming, user research, or architecture design.

Intent records the promises the product must keep. Blueprint contracts, Arc
step scope, and proof attach to those promises.

A good Intent layer tells an agent:

- what promise is being made
- when that promise applies
- what counts as satisfaction
- what must not be violated
- what prior decisions already narrow the space

Use Intent artifacts for:

- user needs and scope
- scenarios and externally visible behaviors
- assurances such as security, privacy, reliability, and performance
- explicit checks and acceptance criteria
- decisions that preserve why important choices were made

Intent reduces ambiguity. It gives humans and agents a stable evaluation
surface for deciding whether a change is correct.

For agents, strong Intent answers these questions:

- What exact promise is in scope?
- For whom or in what situation?
- What must happen?
- What must not happen?
- How will we know it happened?
- What cross-cutting constraints shape it?
- What prior durable decisions already constrain the space?

Intent promises must be addressable. In practice, Arc and Blueprint should be
able to name the exact durable target they are working against:

- goal IDs
- feature outcome IDs
- scenario check IDs
- behavior check IDs
- assurance IDs

## Blueprint Layer

The Blueprint layer turns Intent into concrete implementation contracts.

Use Blueprint artifacts for:

- definitions, schemas, and data models
- interfaces, invariants, and integration boundaries
- API and failure-behavior contracts
- compatibility and migration expectations
- test contracts and required coverage reasoning

Blueprints constrain generation. They reduce divergence by making the intended
implementation shape explicit before code changes land.

Every Blueprint should name the exact Intent targets it concretizes.

## Code Layer

The Code layer is the implementation output that proves Intent has been
satisfied under the Blueprint constraints.

Use the Code layer for:

- source code and supporting configuration
- tests that validate Intent checks and Blueprint contracts
- description files that trace source files back to the obligations they
  satisfy

Code is the executable result of the product artifacts above it.

## Sources Of Truth

IDD preserves two different kinds of truth:

- durable product truth in Intent, Blueprint, Code, tests, and decisions
- transient run coordination state in Arc artifacts and Arc-scoped evidence

Intent and Blueprint remain the durable sources of truth. Code is the
implementation output. Arc and its Arc-scoped evidence record the current
bounded pass so a later agent, reviewer, or validator can reconstruct what
happened without relying on chat history.

When implementation details drift or assumptions change, restore alignment by
updating the relevant Intent and Blueprint artifacts, then regenerating or
modifying Code accordingly.

## Artifact Graph

IDD durable artifacts form an explicit graph:

- frontmatter identifies file-backed artifacts
- goal and assurance catalogs carry entry IDs for in-file nodes
- typed `Refs` surfaces connect those nodes
- description files bridge the durable graph to code and verification surfaces

Folder placement supports navigation. Explicit IDs and `Refs` define the graph.

Within that graph, Intent carries durable target addresses that Arc and
Blueprint select for a bounded pass.

## Arc Runtime Model

Arc is the executable workflow for IDD. Each working branch carries at most one
Arc in `.methodologies/idd/scratch/arc/`.

Arc runtime authority is split across four surfaces:

- `status.md`: the outer operating boundary for scope and permissions
- `arc.md`: the authoritative Arc register and control record
- `.methodologies/idd/scratch/evidence/<arc-id>/`: the authoritative
  claim-and-evidence surface for the Arc
- step files: the authoritative per-step execution and review summaries once a
  step becomes active

Arc keeps work restartable and reviewable with these rules:

- every step is declared up front in `arc.md`
- the active step always has a step file
- any step that is not `planned` has a step file
- the active step is the lowest-numbered non-`complete` step
- only the active step may be `shaped`, `executing`, `proving`, or `blocked`
- every later step remains `planned` until it becomes active

## Arc Design Principles

- Upfront executable planning: the full ordered step register is visible from
  the start in `arc.md`.
- Evidence-carrying execution: the Arc keeps one canonical evidence run while
  each step records the summary of the pass that updated it.
- Boundary control: every step stays inside the boundary declared in
  `status.md`.
- Capability calibration: every step declares why it is sized safely for the
  agent performing it.
- Review handoff: every completed step leaves a fixed review surface and
  evidence references for the next reader.

## Library Support

The library is the reusable capability layer for IDD.

This source repo ships a minimal starter library in `library/`. Installed repos
may merge additional local guidance or helper assets into
`.methodologies/idd/library/`.

At runtime, start in `ARC.md`, use `arc/overview.md` for the built-in Arc
workflow, and open `../library/overview.md` when the Arc needs pass support,
the claim catalog, or other reusable local guidance.

Use `../scripts/verify-idd.sh` from this source repo to verify either the IDD
source package or an installed target repo.
