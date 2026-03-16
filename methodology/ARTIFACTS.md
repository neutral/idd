# IDD Runtime Artifacts

This file is the runtime artifact inventory for IDD. It defines the runtime
templates and installed runtime state for Arc. It does not replace the domain
artifact guidance in `artifacts/overview.md`.

## Use This File When

- locating the runtime templates that Arc depends on
- mapping source-package assets to installed runtime paths
- checking which runtime files and folders must exist before execution

## Not Defined Here

- domain artifact semantics live in `artifacts/overview.md`
- runtime behavior lives in `ARC.md` and `arc/`

## Runtime Templates

- `arc/templates/step.md`: required template for
  `.methodologies/idd/scratch/arc/step-<nn>-<slug>.md`.
- `arc/templates/proof-packet.md`: required proof and review snippet used while
  a step is in `proving`.
- `arc/templates/evidence/index.md`: required template for
  `.methodologies/idd/scratch/evidence/<arc-id>/index.md`.
- `arc/templates/evidence/EVIDENCE.md`: required template for
  `.methodologies/idd/scratch/evidence/<arc-id>/<evidence-file>.md`.

## Installed Runtime State

- `.methodologies/idd/status.md`: required installed control file. It includes
  `Sources`, `Operating scope`, and `Permissions`.
- `.methodologies/idd/scratch/`: required local working area for run-scoped methodology state.
- `.methodologies/idd/scratch/arc/`: required current working area for
  branch-scoped Arc runtime artifacts.
- `.methodologies/idd/scratch/evidence/`: required current working area for
  Arc-scoped evidence runs.
- `.methodologies/idd/scratch/arc/arc.md`: required Arc register artifact with
  `Metadata`, `Arc Objective`, `Completion Rule`, `Step Register`,
  `Final Validation`, `Closeout`, and `Notes`.
- `.methodologies/idd/scratch/arc/step-<nn>-<slug>.md`: required for the active
  step and for any step that has moved beyond `planned`. Uses
  `arc/templates/step.md` and `arc/contracts/step-schema.md`.
- `.methodologies/idd/scratch/evidence/<arc-id>/index.md`: required evidence
  run index for the Arc.
- `.methodologies/idd/scratch/evidence/<arc-id>/E*.md`: required evidence
  items for active Arc claims.

## Runtime Requirements

- Required: `status.md`, `scratch/`, `scratch/arc/`, `scratch/evidence/`,
  `arc.md`, the Arc evidence run, the full declared step register, and the
  active step file.
- Keep temporary working notes that do not belong in `arc.md` or a step file
  under `.methodologies/idd/scratch/`.

## Runtime Boundary

The Arc runtime entrypoint, status contract, Arc workflow, and step schema are
active. Arc and Arc evidence remain transient branch-scoped runtime state.

Use `structure/archival.md` for the canonical maintainer-guidance note on
branch-local Arc retention. This file inventories runtime surfaces; it does not
define branch preservation policy.
