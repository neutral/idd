# File Organization and Navigation

This document defines the default IDD layout for durable product artifacts and
Arc runtime state.

## Use This File When

- creating the initial `intents/` layout in a repo
- deciding where a new intent, blueprint, decision, or description file
  belongs
- checking which folders are authoritative versus purely organizational

## Layout Rules

- Place `intents/` at the repo root for durable Intent and Blueprint artifacts.
- Keep global Blueprint contracts in `intents/blueprints/`.
- Keep decisions under `intents/` beside the scope they govern.
- Keep Arc runtime state under `.methodologies/idd/scratch/arc/`.
- Keep Arc evidence under `.methodologies/idd/scratch/evidence/<arc-id>/`.
- Keep code description files next to the source files they describe.

The Intent, Blueprint, and Code layers may evolve in any order, but the
artifacts should stay cross-linked and reconciled as work changes.

Placement is navigation, not traceability. Durable relationships are
authoritative only when they are declared through the artifact graph surfaces
defined in `frontmatter.md` and `traceability.md`.

## Naming Rules

- Use semantic, descriptive kebab-case names without numeric IDs.
- Prefix intent artifact filenames with their type when helpful, such as
  `feature.md`, `scenario.md`, or `assurances.md`.
- Treat most durable files as one file per graph node. The main exceptions are
  `goals.md` and `assurances.md`, which are catalog files that contain multiple
  `goal/...` or `assurance/...` entry nodes.
- Store behavior nodes under scenario-scoped `behaviors/` folders with one
  descriptive file per `behavior/...` node.
- Use `_` prefixes to surface definition-style folders such as `_definitions`
  or `_decisions` when a repo adopts that convention.
- Use `_` to prefix description files adjacent to code, such as
  `_crypto.go.desc.md`.

## Target Outline

- repo
  - intents/
    - system/
      - goals.md
      - assurances.md
      - commerce/
        - checkout/
          - feature.md
          - assurances.md
          - scenarios/
            - checkout-happy-path/
              - scenario.md
              - behaviors/
                - cart-recalculation.md
              - assurances.md
          - blueprints/
          - decisions/
    - blueprints/
    - decisions/
  - .methodologies/
    - idd/
      - scratch/
        - arc/
        - evidence/
  - src/...
    - `_file.desc.md`
  - AGENTS.md

## Intent Space

Organize product-facing features under `intents/system/<feature>/` or
`intents/system/<domain>/<feature>/`.

Intent artifacts should remain implementation-agnostic and focus on obligations
that must be testable:

- `feature.md`: outcome, scope, and enabled scenarios
- `scenario.md`: concrete user or system situations
- `behaviors/*.md`: one file per behavior that refines a scenario into
  observable obligations and checks
- `assurances.md`: non-functional, policy, or quality constraints

Global assurances live in `intents/system/assurances.md`. Feature and scenario
deltas live beside the feature or scenario they narrow.

## Blueprint Space

Blueprint files define how Intent will be satisfied:

- global definitions live under `intents/blueprints/`
- feature-scoped definitions live under
  `intents/system/<feature>/blueprints/` or
  `intents/system/<domain>/<feature>/blueprints/`
- decisions live beside their scope in `intents/decisions/`,
  `intents/system/<feature>/decisions/`, or
  `intents/system/<domain>/<feature>/decisions/`

Use Blueprint artifacts for contracts, schemas, APIs, models, glossary entries,
budgets, and explainers.

## Domain Groupings

Domain groupings are optional folders directly under `intents/system/` that
cluster related features by conceptual area.

They are:

- a human-first browsing aid for larger repos
- stable conceptual groupings that should outlive code movement
- strictly organizational

They are not:

- code packages
- deployment units
- policy owners
- inheritance points for domain-level overrides

Domain folders should stay empty aside from feature folders.

## Arc Runtime State

Arc work lives in `.methodologies/idd/scratch/arc/` as the single in-progress
Arc for the current branch. Arc-scoped evidence lives beside it in
`.methodologies/idd/scratch/evidence/<arc-id>/`.

Use these placement rules:

- keep `arc.md` in `.methodologies/idd/scratch/arc/`
- keep the active step file in `.methodologies/idd/scratch/arc/`
- keep completed step files in place for the full Arc
- keep later `planned` steps in `arc.md` until they become active
- keep the Arc evidence index and evidence items under
  `.methodologies/idd/scratch/evidence/<arc-id>/`
- keep temporary notes that do not belong in `arc.md` or a step file under
  `.methodologies/idd/scratch/`

## Description Files

Description files use `.desc.md` and sit next to source files in the Code
layer.

They should explain how the adjacent source file satisfies Intent obligations
and Blueprint contracts so a later reader or agent can trace implementation
back to the governing product artifacts.
