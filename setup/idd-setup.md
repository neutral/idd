# IDD Setup

Use this setup guide in a target repo to install IDD assets, initialize intent artifacts, and set up procedures.
This document intentionally combines intent setup and procedure setup.

## 1) Install IDD assets under `.methodologies/idd/`

Copy this repo's folders into the target repo:

- `.methodologies/idd/methodology/` (from `methodology/`)
- `.methodologies/idd/library/` (from `library/`)

Keep `.methodologies/idd/` at the repo root.

## Helper script

Use the helper script to install/update IDD in another repo:

```bash
scripts/copy-idd.sh /path/to/target-repo
```

Add `--delete` to remove files in target methodology/library folders that no longer exist in this repo.

The helper also:

- Creates `.methodologies/idd/workflow/` (placeholder runtime folder).
- Creates/updates `.methodologies/idd/.gitignore` to ignore downloaded `methodology/` and `library/`.
- Creates `.methodologies/idd/status.md` (if missing) and records primary methodology/library source paths under `Sources`.
- Initializes a `Permissions` section in `.methodologies/idd/status.md` (`read and write allowed`, `read-only`, `no access`).

## 2) Configure `.methodologies/idd/status.md`

Use `status.md` as the per-repo control file for IDD runs.

Required sections:

- `Sources`
- `Permissions`

`Permissions` must define three buckets:

- `Read and write allowed`
- `Read-only`
- `No access`

Guidelines:

- Set permissions during setup before runs.
- Use repo-relative paths when possible.
- Most specific path entry wins.
- Update `Sources` only when source paths change.
- Update `Permissions` whenever boundaries change.

## 3) Create the intent layer

Create an `intents/` folder at the target repo root:

- `intents/system/`
- `intents/blueprints/` (global blueprint files/contracts/glossary)
- `intents/decisions/` (global decisions/ADRs)
- `intents/arc/` (Arc planning and step files)

A single root `intents/` folder is the preferred pattern, including monorepos.
Domain folders under `intents/system/` are optional and organizational only.

## 4) Copy starter artifacts

Copy templates from `.methodologies/idd/methodology/artifact-types/` into the target repo as needed:

- Intent templates: features, scenarios, assurances, goals, and behaviors under `intents/system/`.
- Blueprint templates: under `intents/blueprints/` (or feature-scoped `intents/system/<feature>/blueprints/` / `intents/system/<domain>/<feature>/blueprints/`).
- Decision templates: under `intents/decisions/` (or feature-scoped `intents/system/<feature>/decisions/` / `intents/system/<domain>/<feature>/decisions/`).

### Behavior storage (pick what fits)

Behaviors can be stored in either form:

- Inline: keep narrative + checks + behaviors in `scenario.md`.
- Split: keep `scenario.md` as overview and store behavior files separately when scenarios get large.

The key requirement is durable behavior content with linked definitions and checks, not one fixed directory shape.

## 5) Bootstrap Arc

Initialize Arc planning state in `intents/arc/`:

- Create `intents/arc/arc.md` with a draft list of steps.
- Create step files as needed (`step-01-<slug>.md`, `step-02-<slug>.md`, ...).
- Keep step sizing small for reliable model runs and quick review.
- Update both artifacts and code through steps; use Arc files as staging notes between procedure runs.

## 6) Set up procedures

Use `.methodologies/idd/library/procedures/` as the procedures folder in the target repo:

- Create `.methodologies/idd/library/procedures/` if it does not exist.
- Keep all procedures used for runs in this folder.
- Add procedures from additional sources directly into this same folder when needed.
- Copy shared files from `.methodologies/idd/library/common/` into each procedure folder as needed:
  - guideline templates (for example, copy one style template as `style.md`)
  - shared tools (for example, `verify-blueprint-links.sh`)

Because this folder can include mixed sources and local edits, record used procedures in the Arc Step "Procedure Log" with source/commit details when relevant.

## 7) AGENTS.md addition

Add this short section to the target repo `AGENTS.md`:

```md
## IDD
- Use IDD for feature work by following `.methodologies/idd/methodology/overview.md`.
- Keep durable outputs in `intents/` and the codebase artifacts (code, tests, description files), not in chat-only notes.
- Use procedures from `.methodologies/idd/library/procedures/`.
- Read `.methodologies/idd/status.md` before runs and enforce its `Permissions` section.
```

## 8) Workflow status

`.methodologies/idd/methodology/WORKFLOW.md` is currently a placeholder.
Use this setup guide and methodology docs directly until the workflow is defined.
