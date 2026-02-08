# Procedures

Procedures are reusable prompts designed for Intent-Driven Development (IDD). They capture a working process in a repeatable format so developers can trigger a workflow with a standard invocation by simply naming the procedure they want an agent to run. Agents run procedures to read IDD artifacts as inputs and write durable updates back as outputs (Intent, Blueprint, and Code). Running procedures reduces freeform chat and keeps work reproducible by making context and outcomes explicit.

This repo is a public library of procedures. Developers can also use one or more additional procedure libraries (public or internal) and install procedures from any of them into a project.

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

Keep a local copy of the procedures you want an agent to run (from one or more libraries) in a `.procedures/` directory at the repo root. Copy any needed shared files from `common/` into each local procedure folder (for example, pick a template from `common/guidelines/` such as `style-balanced.md` and copy it as `style.md`, or copy `common/tools/verify-blueprint-links.sh` into `scripts/`). Add `.procedures/` to the repo's `.gitignore`.

Because `.procedures/` is not committed, record the procedure(s) used (and the library version or commit) in the Arc Step "Procedure Log" so others can reproduce the workflow.

## 🤝 Contributing

Please see our [Contributing Guide](CONTRIBUTING.md) for details.

Source code files should include `SPDX-License-Identifier: (CC0-1.0 OR 0BSD)` where applicable.

## License

This project is released under a dual-license model. Choose either:

- **[CC0-1.0](LICENSE.CC0-1.0)** - Creative Commons Zero v1.0 Universal
- **[0BSD](LICENSE.0BSD)** - Zero-Clause BSD

This applies to all project materials.
