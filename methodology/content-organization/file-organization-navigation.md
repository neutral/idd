# File Organization and Navigation

IDD organizes artifacts into three layers: Intent (what must be true), Blueprint (how it will be made true), and Code (the implementation output, with description files). Intent communicates the model to humans; Code runs it on machines. The layers co-evolve and can be updated in any order; the expectation is to keep cross-links and reconcile differences as you go.

- Place an `intents/` folder at the repo root for Intent artifacts (features, scenarios, behaviors, assurances, goals) and cross-cutting assets. A single root `intents/` folder is the preferred pattern even in monorepos.
- Within `intents/`, keep a `blueprints/` folder for global contracts/glossary/definitions. Feature folders can also have their own `blueprints/` subfolder for feature-scoped contracts.
- Decisions live under `intents/` because they drive updates across Intent + Blueprint + Code (keeping the layers in sync). Feature decisions live under the feature folder (e.g., `intents/system/<feature>/decisions/` or `intents/system/<domain>/<feature>/decisions/`); global decisions live in `intents/decisions/`.
- Description files belong to the Code layer and are colocated with source code files. They link code back to the Intent obligations and Blueprint contracts it satisfies.

Use semantic, descriptive kebab-case names without IDs. Prefix intent artifact filenames with their type (feature, behavior, scenario, assurance) and Blueprint files with their type where helpful.

Use `_` prefixes to keep definition folders surfaced (e.g., `_definitions`, `_decisions`). Use `_` to prefix description files adjacent to code (e.g., `_crypto.go.desc.md`).

Both the `intents` and `blueprints` sections are hierarchical. Use the structure below to move between spaces and discover what exists.

## Example Outline

- repo
  - intents
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
              - assurances.md
          - blueprints/ (feature-specific definitions)
          - decisions/ (feature-specific decisions)
    - blueprints/ (global definitions/glossary/contracts)
    - decisions/ (global decisions/ADRs)
    - arc/
  - src/... (Code)
    - \_file.desc.md (description files adjacent to code)
  - AGENTS.md

## Domain Groupings

Domain groupings are optional folders directly under `intents/system/` used to cluster related features by conceptual area (for example, `intents/system/commerce/checkout/`). They are most useful in large repos or monorepos with many packages where the `intents/system/` feature list would otherwise become unwieldy.

- What they are: a lightweight, human-first way to browse Intent by domain.
- Why they are not packages: they should not mirror code modules, deployment units, or ownership boundaries, and they should remain stable even when code moves.
- Strictly organizational: do not introduce domain-level artifacts, inheritance, or policy overrides; artifacts live at the system-wide or feature level only.

## System

### Intent: Features, Scenarios, Behaviors, Assurances

Organize features under `intents/system/<feature>/` or `intents/system/<domain>/<feature>/`. Intent is implementation-agnostic and focuses on obligations and outcomes that must be testable.

- Features describe the outcome and users served, and list the scenarios they enable.
- Scenarios contain behaviors and checks that define externally observable system obligations.
- Assurances declare the non-functional/quality/policy constraints that shape implementations.
- Global assurances live in `intents/system/assurances.md`; feature assurances live under each feature; scenario-level deltas live under each scenario folder. Domain folders stay empty aside from feature folders.

### Blueprint: Definitions, Decisions, Contracts

Blueprint files define how Intent will be satisfied: contracts, schemas, APIs, models, glossary entries, budgets, and explainers.

- Global definitions live under `intents/blueprints/`.
- Feature-scoped definitions live under `intents/system/<feature>/blueprints/` or `intents/system/<domain>/<feature>/blueprints/`.
- Decisions live beside their scope (`intents/decisions/`, `intents/system/<feature>/decisions/`, or `intents/system/<domain>/<feature>/decisions/`) and link back to the Intent behaviors/assurances they inform.

## Arc

Arc work lives in `intents/arc/` as the single in-progress arc for the current branch. Steps sit inside the folder with `_done` and `_scratch`.

## Procedures

Procedures remain in a local `.procedures/` folder at the repo root (or another local procedure folder). When agents run procedures, they read from the Intent/Blueprint layers and write back before ending.

## Descriptions

Description files use `.desc.md` and sit next to source files in the Code layer. Each source file needs code comments and a corresponding description file. Description files bridge Intent and Blueprint context to code and help agents trace implementations back to obligations and contracts.
