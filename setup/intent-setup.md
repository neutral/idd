# Setup: Intent-Driven Development

Create an `intents` layer at the repo root that contains Intent artifacts (what must be true), Blueprint files (contracts for how it will be made true), and cross-cutting assets. A single root `intents/` folder is the better pattern even in monorepos; only split per module if there is no viable alternative.

The folder layout is a convention for discoverability, not a rigid requirement. Agents can work with different layouts as long as the Intent/Blueprint/Code contents exist and are easy to find (via consistent naming, links, and a short orientation in `AGENTS.md`).

Domain groupings are an optional way to keep `intents/system/` browsable in large repos (for example, monorepos with many packages and features). If you use them, keep them conceptual and stable, and still maintain a single root `intents/` folder. Domain folders are strictly organizational: do not add domain-level artifacts or inheritance; keep artifacts at the system-wide or feature level.

## Create a starter layout (recommended)

- `intents/`
  - `system/`
  - `blueprints/` (global blueprint files/contracts/glossary)
  - `decisions/` (global decisions/ADRs)
  - `arc/` (the active arc on this branch)

## Copy Files

Copy templates from `methodology/artifact-types` in this repo into your target repo as needed:

- Use Intent templates for features, scenarios, assurances, goals, and behaviors and place files in `intents/system` appropriately.
- Use Blueprint templates and place files in `intents/blueprints/` (or `intents/system/<feature>/blueprints/` / `intents/system/<domain>/<feature>/blueprints/` for feature scope).
- Use Decision templates and place files in `intents/decisions/` (or feature-specific decisions under `intents/system/<feature>/decisions/` / `intents/system/<domain>/<feature>/decisions/`).

### Behavior storage (pick what fits)

Behaviors can be stored in either form:

- **Inline:** keep the whole scenario (narrative + checks + behaviors) in `intents/system/<feature>/scenarios/<scenario>/scenario.md` or `intents/system/<domain>/<feature>/scenarios/<scenario>/scenario.md`.
- **Split:** keep `scenario.md` as the scenario overview and store behaviors as separate files (for example, under `intents/system/<feature>/scenarios/<scenario>/behaviors/` or `intents/system/<domain>/<feature>/scenarios/<scenario>/behaviors/`) when the scenario grows large or you want easier review, reuse, or parallel work.

The important part for agent work is that each behavior’s content exists somewhere in durable files (description, inputs/outputs, linked definitions, and checks), not that it matches an exact path or shape.

## Project Agents.md Setup

Add an IDD section to `AGENTS.md` (or your agent instruction file).

- Generate an overview paragraph using content from `methodology/overview.md` that explains Intent + Blueprint + Code as co-evolving layers.
- Agentic generation process involves generating artifacts across all three layers.
- Highlight the key artifacts being used and summarize the processes. Reference the `intents` and `intents/blueprints` folders and the available templates developers or agents use when initializing files.

## Arc Setup

Set up an arc with a draft list of steps to scaffold the repo, add the initial intent artifacts, add supporting blueprint files, and implement code.

## Procedures

Procedures are reusable prompts that agents run to make changes reproducible and durable.

- Set up a local `.procedures/` folder using `setup/setup-procedures.md`.
