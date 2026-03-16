# IDD Claim Types

This file is authoritative for the IDD claim catalog and claim-family rules for
Arc evidence.

## Start Here

Use this file when you need to answer:

- which claim types exist
- which claim types are baseline versus conditional
- which claim types are shared core claims versus IDD-specific extensions

Use these next documents:

- one claim type folder for concrete claim and evidence rules
- `../../methodology/ARC.md` for when Arc evidence must be updated
- `../../methodology/arc/templates/evidence/index.md` for the Arc evidence
  index template
- `../../methodology/arc/templates/evidence/EVIDENCE.md` for the shared Arc
  evidence-item shape

## Path Context

Source repo:

- `library/claims/README.md`

Installed runtime:

- `.methodologies/idd/library/claims/README.md`
- evidence items under `.methodologies/idd/scratch/evidence/<arc-id>/`

## Claim Family Structure

- each claim type lives in `library/claims/<claim-type-name>/`
- `<claim-type-name>` must be unique kebab-case and is the canonical claim type
  name

Required files:

- `claim.md`: purpose, applicability, trust question, concrete claim shape, and
  artifact integration
- `evidence.md`: evidence capture rules, verdict guidance, and thread-splitting
  rules

Optional files:

- `examples.md`: concrete examples and anti-patterns when a repo wants extra
  calibration

## Required `claim.md` Shape

Every `claim.md` file must start with `# Claim Type`.

Every `claim.md` file must use this opening field order:

- `Claim type name`
- `Summary`
- `Why this claim matters`
- `Primary trust question`
- `Default evidence kind`

Every `claim.md` file must then use this section order:

1. `Use This Claim When`
2. `Claim Sentence Template`
3. `Required Inputs`
4. `Update These Artifacts When`
5. `Related Claim Types`

Do not insert extra top-level sections before, between, or after those
sections in `claim.md`.

## Required `evidence.md` Shape

Every `evidence.md` file must start with `# Evidence Capture` and one short
orientation paragraph or sentence before the first section.

Every `evidence.md` file must keep its guidance aligned to the shared Arc
evidence item shape in
`../../methodology/arc/templates/evidence/EVIDENCE.md`.

Every `evidence.md` file must use this section order:

1. `Claim`
2. `Methodology References`
3. `Method Or Context`
4. `Observations`
5. `Raw Artifacts`
6. `Verdict Guidance`
7. `Evidence Thread Rules`
8. `Closeout Conditions`

Do not insert extra top-level sections before, between, or after those
sections in `evidence.md`.

## Starter Skeletons

Use these as the canonical family skeletons:

```md
# Claim Type

Claim type name: `<claim-type-name>`
Summary:
Why this claim matters:
Primary trust question:
Default evidence kind:

## Use This Claim When

- ...

## Claim Sentence Template

- ...

## Required Inputs

- ...

## Update These Artifacts When

- ...

## Related Claim Types

- ...
```

```md
# Evidence Capture

Capture this claim type in the shared Arc evidence shape: claim, context or
method, observations and raw artifacts, and verdict.

## Claim

- ...

## Methodology References

- ...

## Method Or Context

- ...

## Observations

- ...

## Raw Artifacts

- ...

## Verdict Guidance

- ...

## Evidence Thread Rules

- ...

## Closeout Conditions

- ...
```

## Core Claim Set

IDD uses this shared core claim set:

- `intent-target`
- `boundary-compliance`
- `authority-basis`
- `verification-posture`
- `residual-uncertainty`
- `governance-ownership`

## IDD Extension Claim Set

IDD adds these methodology-specific extension claims:

- `layer-sync`
- `conflict-resolution`
- `outcome-posture`
- `pass-effect`

## Baseline Claim Set

Every Arc must keep these baseline claims current:

- `intent-target`
- `boundary-compliance`
- `layer-sync`
- `verification-posture`

Other claim types activate when their trigger conditions become materially
relevant during the Arc.

## Runtime Use

1. Match the current trust-relevant assertion to a claim type folder.
2. Use `claim.md` to state the concrete claim and check applicability.
3. Use `evidence.md` to capture and maintain the supporting Arc evidence
   thread.
4. Store evidence items under
   `.methodologies/idd/scratch/evidence/<arc-id>/`.
5. Keep step files and decision artifacts pointing to the evidence IDs that
   matter to the current pass.
6. Use `pass-effect` when a local pass materially improved an Intent, Blueprint,
   or step artifact and later review would benefit from the recorded
   before-and-after posture. Create or update that evidence in the same Arc
   phase that used the pass.
