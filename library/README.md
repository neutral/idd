# Procedures

This folder contains the IDD procedure library. Procedures are reusable prompts that capture repeatable workflows and write durable updates back to artifacts.

Developers can also use one or more additional procedure libraries (public or internal) and keep imported procedures in the same target repo procedures folder.

## Procedure format

Each procedure lives in a folder and is centered around `procedure.md`. Procedures may also include:

- `template-*.md` files that the agent uses to produce outputs in a consistent format.
- `scripts/` with helper tools for verification or automation (copied locally from `common/tools/` when needed).
- `style.md` in the local (copied) procedure folder to enforce project-specific writing style (required; if missing, the agent should flag it).

Every `procedure.md` must follow the same high-level structure:

- `## Purpose`, `## When to use`
- `## Guidelines`, then `## Tools`, then `## Pre-requisites`
- `## Gather Context`
- One or more stage sections (`## <Stage Name>`) that describe the core work as a single bullet flow
- `## Verification`, `## Report`

See `usage/general-structure.md` for the full section requirements and authoring guidance.

## This repo

- `procedures/` contains the procedures, grouped by stage or domain.
- `common/` contains shared guidelines and tools to avoid duplication in the library; copy them into each procedure folder when setting up local procedures.
- `usage/` documents the library structure and conventions.

Developers pull the procedures they need from this library into their codebase repo and tailor them locally.

## Using procedures in a project

Use `.methodologies/idd/library/procedures/` as the procedures folder in target repos. Keep all procedures in this single folder, including procedures imported from additional libraries. Copy any needed shared files from `common/` into each procedure folder (for example, pick a template from `common/guidelines/` such as `style-balanced.md` and copy it as `style.md`, or copy `common/tools/verify-blueprint-links.sh` into `scripts/`).

Because this folder can include local edits and mixed sources, record the procedure(s) used (and source/library version or commit) in the Arc Step "Procedure Log" so others can reproduce the workflow.
