# Verifying IDD

Use the verifier from the IDD source repo. It does not get copied into target
repos.

## Use This File When

- validating this source package after documentation or contract changes
- validating an installed target repo against the published IDD contracts
- validating durable artifact graph structure in a target repo
- checking what the verifier reports and what exit codes mean

## Commands

```bash
scripts/verify-idd.sh
scripts/verify-idd.sh --source-only
scripts/verify-idd.sh --target /path/to/target-repo
scripts/verify-idd.sh --runtime-only --target /path/to/target-repo
```

## What It Checks

- source-package contract surfaces in this repo
- source-package Arc `step.md`, `proof-packet.md`, and evidence template shape
  under `methodology/arc/templates/`
- source-package claim-family `claim.md` and `evidence.md` shape under
  `library/claims/`, including `pass-effect`
- source-package pass-family `index.md` and recursive pass-file shape under
  `library/passes/`
- source and installed-package library entrypoint references to
  `passes/index.md`
- installed-package hierarchical pass catalog surfaces under
  `.methodologies/idd/library/passes/` in target repos
- installed-package claim-family `claim.md` and `evidence.md` shape under
  `.methodologies/idd/library/claims/` in target repos
- installed-package Arc `step.md`, `proof-packet.md`, and evidence template
  shape under `.methodologies/idd/methodology/arc/templates/` in target repos
- durable artifact frontmatter shape and ID uniqueness in target repos
- durable artifact section order and required `Refs` surfaces in target repos
- artifact-ref target-type compatibility across durable nodes and runtime
  step/evidence nodes
- machine-checkable artifact content rules for explicit field order,
  subheading order, required single-path surfaces, and structured local
  promise IDs
- artifact-ref resolution across file-backed nodes, catalog-entry nodes, and
  runtime step/evidence nodes
- graph invariants for scenario-to-feature, behavior-to-scenario, Blueprint,
  decision, and description links
- Blueprint `Intent targets` and step `Proof Target > Intent targets` format
- scoped-assurance baseline disposition coverage against the global assurance
  baseline
- runtime `status.md` sections
- Arc register and step schema structure
- `Planned Layer Delta` population and non-`(none)` layer-delta/ref alignment
- `Proof Target > Required checks` shape across success-path, negative-path,
  invariant or regression, and review-only categories
- `Proof Packet > Checks run` and `Results` shape against those same
  categories
- Arc evidence runtime structure, exact evidence-index section order, required
  conditional-claim coverage, and required evidence links
- step and Arc status-transition validity from `Run Ledger`
- step-ordering rules across the full declared step register
- required planning bullets for every declared step
- active-step and non-`planned` step-file presence
- rejection of future `planned` step files before those steps become active
- step envelope paths against the `status.md` boundary
- machine-checkable refs under `References`

## Durable Artifact Graph

The durable artifact graph contract is defined in:

- `methodology/structure/frontmatter.md`
- `methodology/structure/traceability.md`
- the artifact contracts under `methodology/artifacts/`

When validating a target repo with `--target`, the verifier now machine-checks
those durable artifact graph rules in addition to the Arc runtime package.

Use `--runtime-only --target /path/to/target-repo` when you want to skip the
durable artifact graph checks and focus on the installed package plus the Arc
runtime and evidence surfaces.

## Output

The verifier emits one issue per line:

- `ERROR <code> <path>: <message>`
- `WARN <code> <path>: <message>`

It ends with:

```text
SUMMARY errors=<count> warnings=<count>
```

Exit codes:

- `0`: no errors
- `1`: verification failed
- `2`: usage error or verifier failure

## Target Repo Usage

Run the verifier from a checkout of this IDD source repo and point it at the
target repo path when you want to validate an installed runtime:

```bash
scripts/verify-idd.sh --target /path/to/target-repo
```

When you need to validate runtime behavior, point the verifier at a real target
repo or a local throwaway fixture outside the source package.
