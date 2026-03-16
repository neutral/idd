# Arc Branch Retention Guidance

Arc state is transient branch-scoped working state. It is not a durable archive
surface.

## Runtime Surfaces Covered

- `.methodologies/idd/scratch/arc/`
- `.methodologies/idd/scratch/evidence/`

## Main Rule

- Do not treat Arc runtime files as durable product history.
- Durable information that must survive belongs in Intent, Blueprint, Code,
  description files, tests, or decision artifacts.
- Arc files and Arc evidence are left behind on the branch as non-durable
  runtime residue.

## Maintainer Concern

- Repo maintainers decide how, whether, and where to preserve branch history
  that includes Arc runtime files.
- A maintainer may leave the branch as-is, delete it later, or capture a
  summary elsewhere in the repo or outside the repo.
- IDD does not define a required preservation policy for those branch-local
  runtime files.

## IDD Guidance

- Promote any durable product truth into the appropriate product artifact.
- Do not treat Arc runtime files themselves as part of the durable IDD
  contract.
