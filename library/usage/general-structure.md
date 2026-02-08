# General Structure

## Library Organization

Procedures are grouped by the stage where they are used in the main library.

## Procedure Organization

Contents of a procedure are placed in a folder named in kebab-case.

The main contents are in `procedure.md` within this folder.

Some procedures require project-specific guidelines that are not hard-coded upfront in this library and are supplied by the developer during usage. Developers place these guidelines in the procedure folder that is copied locally in the codebase repo (for example, `style.md`) so the agent can load them during invocation. Shared starter files live in `common/` (for example, `common/guidelines/` and `common/tools/`) to avoid duplication in the library. When developers set up procedures locally, they copy these files into each procedure folder so every local procedure is self-contained. When multiple guideline templates exist, pick one (for example, `style-balanced.md`) and copy it as `style.md` for the local procedure setup.

Templates that the procedure uses to generate outputs are stored as `template-*.md` files in the procedure folder.

Tools can be present as scripts in the procedure folder for the agent to use while running the procedure. When tools are shared across multiple procedures, keep them in `common/tools/` and copy them into each local procedure setup as needed.

## procedure.md structure

Every `procedure.md` must include the following required sections, in this order:

- `## Purpose`: the intended outcome (and any explicit non-goals).
- `## When to use`: concrete triggers and scenarios.
- `## Guidelines`: constraints and assumptions the agent must follow (including how to find local style).
- `## Tools`: scripts or helper tools available to the agent while running the procedure (or "None required").
- `## Pre-requisites`: fast checks that must pass before doing work (repo state, required artifacts, required user-supplied inputs).
- `## Gather Context`: the exact repo context the agent must read before doing work.
- One or more stage sections (`## <Stage Name>`): the core work, written as a single continuous bullet flow.
- `## Verification`: objective checks and commands that confirm success.
- `## Report`: what the agent must report back at the end (paths, commands, outcomes, open questions).

`## Tools` must appear immediately after `## Guidelines` so the agent can discover available tools early.
`## Pre-requisites` must appear immediately after `## Tools` so the agent can fail fast before doing deeper work.

### Stage sections

Stages are where the agent does the work. A procedure can have one or more stages; they run top-to-bottom.

Within each stage:

- Use unnumbered bullet points (`- ...`) as one continuous flow.
- Interleave “processing” and “persisting” actions where it reads better.
- Include explicit file paths, template names, and commands when relevant.
- Put persistence actions next to the work that produces them (draft/create → save/link → record).
- Avoid repeating steps that already live in `## Pre-requisites`, `## Gather Context`, `## Verification`, or `## Report`.

Stage names should be short, verb-phrase titles (for example, `Draft Tech Spec`, `Run Verification`, `Sync Blueprint and Code`).

### Section authoring guidance

#### Purpose

- Prefer 2–5 bullets that describe concrete outcomes.
- Include hard constraints (for example, “plan-only; do not implement code”) when relevant.

#### When to use

- List the scenarios that should trigger the procedure.
- If the procedure only applies under a specific scope (feature-scoped vs global), state it explicitly.

#### Guidelines

- Put local setup expectations here (for example, “Writing style: use `style.md` in the local procedure folder; if missing, flag it.”).
- Capture constraints that shape decisions (scope, file boundaries, approval gates, traceability rules).
- Avoid “how to run the procedure” duplication that belongs in the stage section.

#### Tools

- List scripts/tools in the procedure folder with a 1-line description of what they do.
- If a tool is shared, keep the canonical copy in `common/tools/` and copy it into the local procedure folder during setup.

#### Pre-requisites

- Write a checklist of quick checks the agent must run before starting.
- Include repo-state checks (required IDD folders/artifacts exist, expected commands/tools are available) and invocation checks (required user-supplied inputs like names, paths, scope, constraints).
- Prefer “fail fast”: if a pre-requisite is missing, stop and report exactly what is needed before proceeding.
- Keep checks lightweight; full validation belongs in `## Verification`.
- Do not include procedure setup checks (for example, missing `style.md`, missing `template-*.md`, or copying `scripts/`); those belong to procedure instantiation time, not procedure run time.

#### Gather Context

- Name the exact files/folders the agent must read (use repo-relative paths where possible).
- Include any must-run commands that are required to gather current state.
- Keep this as “inputs only”; do not include output-writing steps here.

#### Stage writing

- Write the work as unnumbered bullets in the order the agent should do them.
- Include the output location and template at the moment the agent is asked to create/update something.
- Keep each bullet verifiable (a reader should be able to check that it happened).

#### Verification

- Provide checks that prove the stage outputs match the procedure’s intent.
- Prefer concrete commands and file-change assertions (what should/should not have been edited).

#### Report

- Require paths to key outputs and any commands run.
- Include follow-ups, missing context, and unresolved questions.

### Minimal skeleton

```md
# <Procedure Name>

## Purpose
- <What this achieves>

## When to use
- <Trigger scenarios>

## Guidelines
- Writing style: use `style.md` in the local procedure folder; if missing, flag it.
- <Constraints the agent must follow>

## Tools
- None required.

## Pre-requisites
- <Checks that must pass before starting>

## Gather Context
- <Inputs the agent must read>

## <Stage Name>
- <Work + persistence as one bullet flow>

## Verification
- <Checks / commands>

## Report
- <What to report back>
```
