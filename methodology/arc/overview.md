# Arc Runtime

This folder is the methodology-owned runtime home for Arc in IDD.

## Use This File When

- locating the Arc stage document for the current runtime phase
- finding the authoritative Arc contract, artifact, or template surface
- checking what stays in `methodology/arc/` versus `library/`

## Purpose

- keep the built-in Arc workflow in one semantic area
- separate runtime control from optional library pass and claim support assets
- make Arc phases, artifact guidance, contracts, and templates easy to find

## Arc Layout

- `stages/`: the phase handlers selected from `../ARC.md`
- `artifacts/`: guidance for `arc.md` and step files
- `contracts/`: normative state, workflow, schema, proof, and reconciliation rules
- `templates/`: canonical Arc step, proof, and evidence templates

## Phase Index

- `stages/map-arc.md`
- `stages/shape-step.md`
- `stages/run-step.md`
- `stages/prove-step.md`
- `stages/close-step.md`
- `stages/finalize-arc.md`

## Artifact Guidance

- `artifacts/arc.md`
- `artifacts/step.md`

## Contracts

- `contracts/state-machine.md`
- `contracts/loop.md`
- `contracts/step-schema.md`
- `contracts/layer-sync-invariants.md`
- `contracts/conflict-resolution.md`

## Templates

- `templates/step.md`
- `templates/proof-packet.md`
- `templates/evidence/index.md`
- `templates/evidence/EVIDENCE.md`

## Runtime Boundary

Use `../ARC.md` to select the current Arc phase first.

Then use this split:

- Arc phase handling stays in `methodology/arc/`
- pass support and claim guidance stay in `../../library/`
- step execution works directly from the active step file and referenced
  product artifacts

## Logging Rule

When a methodology-owned Arc phase updates a step, add one `Run Ledger` entry
using the schema in `contracts/step-schema.md`. Use the phase name as the
`Operation` value.

During direct implementation work, use `Operation: direct work`.

When no step exists yet, record the phase result in `arc.md` `Notes` instead.
