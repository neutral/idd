# IDD Setup

Use this guide in a target repo to install IDD assets, initialize the product
artifact layout, and bootstrap Arc plus the local library entrypoint.

## Use This Guide When

- installing IDD into a repo for the first time
- updating an existing IDD install from this source repo
- preparing a target repo for bounded Arc execution

## Setup Outcomes

After this guide, the target repo should have:

- `.methodologies/idd/methodology/` and `.methodologies/idd/library/`
- `.methodologies/idd/status.md` with `Sources`, `Operating scope`, and
  `Permissions`
- `.methodologies/idd/scratch/`, `.methodologies/idd/scratch/arc/`, and
  `.methodologies/idd/scratch/evidence/`
- an `intents/` tree for durable product artifacts
- an initialized Arc register and first active step file when work is ready to
  begin

## Path Context

Source repo paths in this document refer to this repo.

Target repo paths in this document refer to the repo receiving the installed
copy under `.methodologies/idd/`.

## 1) Install IDD assets under `.methodologies/idd/`

Copy this repo's folders into the target repo:

- `.methodologies/idd/methodology/` (from `methodology/`)
- `.methodologies/idd/library/` (from `library/`)

Keep `.methodologies/idd/` at the repo root.

## Helper Script

Use the helper script to install/update IDD in another repo:

```bash
scripts/copy-idd.sh /path/to/target-repo [--delete] [--scope entire-repo|selected-paths] [--scope-path <repo-relative-path> ...]
```

Add `--delete` to remove files in target methodology/library folders that no longer exist in this repo.

Use scope flags during setup when you already know run boundaries:

- `--scope entire-repo`: set IDD operating scope to the whole repo.
- `--scope selected-paths --scope-path <path> [...]`: set IDD operating scope
  to one or more repo-relative folders or files.
- If scope flags are omitted, `status.md` is initialized with setup placeholders
  to fill from user input.

The helper also:

- Creates `.methodologies/idd/scratch/` and
  `.methodologies/idd/scratch/arc/`.
- Creates `.methodologies/idd/scratch/evidence/`.
- Keeps `.methodologies/idd/scratch/` available for temporary working notes,
  while `scratch/arc/` stays reserved for `arc.md` and step files and
  `scratch/evidence/` stays reserved for Arc evidence runs.
- Creates/updates `.methodologies/idd/.gitignore` to ignore downloaded `methodology/` and `library/`.
- Ensures `.methodologies/idd/status.md` includes `Sources`, `Operating scope`, and `Permissions`.
- Ensures the `Permissions` section has required buckets (`read and write allowed`, `read-only`, `no access`) with `(none)` defaults.

## 2) Configure `.methodologies/idd/status.md`

Use `status.md` as the per-repo control file for IDD runs.

Required sections:

- `Sources`
- `Operating scope`
- `Permissions`

`Operating scope` must define:

- `Mode`: `entire-repo` or `selected-paths`
- `In-scope roots`: one or more repo-relative roots

`Permissions` must define three buckets:

- `Read and write allowed`
- `Read-only`
- `No access`

Status rules:

- Capture initial operating scope during setup before runs.
- If `Mode` is `entire-repo`, use `.` as the in-scope root.
- If `Mode` is `selected-paths`, list one or more repo-relative roots.
- Set permissions during setup before runs.
- Use repo-relative paths when possible.
- Initialize all three permission buckets to `(none)` until explicit boundaries are approved.
- If a path is not listed in a permission bucket, treat it as `no access`.
- Reads and writes outside `Operating scope` are disallowed even if a permission entry exists.
- Most specific path entry wins.
- Update `Sources` only when source paths change.
- Update `Operating scope` whenever intended run boundaries change.
- Update `Permissions` whenever boundaries change.

## 3) Create the intent layer

Create an `intents/` folder at the target repo root:

- `intents/system/`
- `intents/blueprints/` (global blueprint files/contracts/glossary)
- `intents/decisions/` (global decisions/ADRs)

A single root `intents/` folder is the preferred pattern, including monorepos.
Domain folders under `intents/system/` are optional and organizational only.

## 4) Author starter artifacts

Use the artifact guidance under `.methodologies/idd/methodology/artifacts/`
to author the initial intent, blueprint, and decision files in the target
repo:

- Intent guidance: `.methodologies/idd/methodology/artifacts/intent/`
- Blueprint guidance: `.methodologies/idd/methodology/artifacts/blueprint/`
- Code-support guidance: `.methodologies/idd/methodology/artifacts/code/`

Place the authored files in the target repo as needed:

- Intent artifacts under `intents/system/`
- Behavior artifacts under scenario-scoped `behaviors/` folders
- Blueprint artifacts under `intents/blueprints/` or feature-scoped blueprint
  folders
- Decision artifacts under `intents/decisions/` or feature-scoped decision
  folders

Artifact authoring rules:

- assign frontmatter IDs to every file-backed durable artifact
- assign `Goal ID` values inside goal catalogs and `Assurance ID` values inside
  assurance catalogs
- assign unique kebab-case local `Outcome ID` values inside feature
  `Required Outcomes`
- assign unique kebab-case local `Check ID` values inside scenario and
  behavior checks
- treat goal and assurance catalog files as containers; the entry IDs are the
  durable node identities inside them
- use typed `Refs` surfaces for durable relationships
- in scoped assurance catalogs, classify the full inherited baseline before
  adding local scoped assurance entries
- store each behavior as its own file and connect it through `Behavior refs`
  and `Scenario ref`
- make the executable Intent slice explicit enough that a later step can name
  exact durable `Intent targets`
- do not treat folder adjacency as traceability
- use description files to bridge durable artifacts back to code and
  verification surfaces

## 5) Map Arc

Initialize Arc planning state in `.methodologies/idd/scratch/arc/`:

- Create `.methodologies/idd/scratch/arc/arc.md` as the Arc register.
- Declare the full ordered step register up front in `arc.md`.
- Give every step a machine-checkable register line plus the required planning
  bullets: `Goal`, `Constraint envelope`, `Planned layer delta`,
  `Proof target`, and `Capability fit`.
- Keep any future-step enrichment brief inside that step's `arc.md` block until
  the step becomes active.
- Create the first active step file immediately. Create later step files only
  when they become active.
- Keep later steps in `planned` until they become active.
- Define the active step's full constraint envelope, capability fit, planned
  layer delta, references, and proof target before execution begins.
- Define the active step's exact durable `Intent targets` before it becomes
  `shaped`.
- Initialize `.methodologies/idd/scratch/evidence/<arc-id>/` once the Arc ID is
  stable, and keep Arc evidence current while steps are shaped, executed,
  proved, and closed.
- Size steps so no more than one capability-fit load is `high`.
- Update future `planned` steps immediately in `arc.md` whenever the completion
  path changes.
- Arc files and Arc evidence are transient branch-local runtime artifacts.
  Promote durable outcomes into Intent/Blueprint/Code artifacts. Repo
  maintainers decide whether branches that contain Arc runtime residue are
  kept, deleted later, or summarized elsewhere.

## 6) AGENTS.md addition

Add this short section to the target repo `AGENTS.md`:

```md
## IDD
- Use IDD for feature work by starting with `.methodologies/idd/methodology/ARC.md`.
- Start library selection at `.methodologies/idd/library/overview.md`.
- Use `.methodologies/idd/library/passes/index.md` when authored quality or
  hand-off quality needs strengthening support.
- Use `.methodologies/idd/library/claims/README.md` for the IDD claim catalog,
  including `pass-effect` when a local pass materially strengthens the current
  run.
- Keep durable outputs in `intents/` and the codebase artifacts (code, tests, description files), not in chat-only notes.
- Read `.methodologies/idd/status.md` before runs and enforce both `Operating scope` and `Permissions`.
```

## 7) Updating IDD in a target repo

Re-copy the contents of `methodology/` and `library/` into
`.methodologies/idd/` when updates are needed or use `scripts/copy-idd.sh`.

Update `.methodologies/idd/status.md` `Sources` only when methodology or
library source locations change. Update `Operating scope` and `Permissions`
whenever run boundaries change.

## 8) Verify a target repo from the IDD source repo

The verifier stays in the IDD source repo. It is not copied into
`.methodologies/idd/` in target repos.

Run it from this source repo:

```bash
scripts/verify-idd.sh
scripts/verify-idd.sh --target /path/to/target-repo
scripts/verify-idd.sh --runtime-only --target /path/to/target-repo
```

Use `scripts/verify-idd.sh --target /path/to/target-repo` after setup changes,
workflow changes, or Arc contract updates when you want to confirm the target
repo still matches the published IDD contracts.
