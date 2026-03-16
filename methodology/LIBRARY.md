# IDD Library

This file defines what the IDD `library/` is for, what remains in
`methodology/`, and how runtime agents should use installed library surfaces.

## Use This File When

- deciding what belongs in `library/` versus `methodology/`
- checking source-repo paths against installed runtime paths
- understanding multi-library merge rules

## Authoritative Here

- library purpose and structure
- runtime entry and recording rules for local library assets
- merge and provenance rules when multiple library sources are installed

## Start Here

Use this file when you need to answer:

- what belongs in `library/` versus `methodology/`
- how the starter package differs from an installed local library
- when a runtime agent should open `library/overview.md`

Use these next documents:

- `../library/overview.md`: runtime library entrypoint
- `ARC.md`: runtime entrypoint for Arc stage selection

## Path Context

Source repo:

- `library/`
- `library/overview.md`

Installed runtime:

- `.methodologies/idd/library/`
- `.methodologies/idd/library/overview.md`

## Purpose

The library is the reusable capability layer for IDD. It holds optional local
guidance and helper resources that runtime agents may load inside the built-in
methodology contract.

In short:

- `methodology/` defines the process contract and the built-in Arc control loop
- `library/` provides the local extension and selection surface used within
  that contract

## Structure

The starter IDD library ships these starter catalogs:

- `../library/overview.md`: runtime entrypoint and routing surface
- `../library/passes/index.md`: pass catalog for authoring-strengthening
  support across the Intent pipeline
- `../library/claims/README.md`: the IDD claim catalog for Arc evidence,
  including `pass-effect`

Installed runtimes may merge additional local library surfaces under
`.methodologies/idd/library/`.

## Runtime Usage

At runtime, agents should:

1. Start in `../methodology/ARC.md`.
2. Use `../methodology/arc/overview.md` and `../methodology/arc/stages/` for
   built-in Arc stage handling.
3. Open `../library/overview.md` when reusable local guidance or helper assets
   may help the current run.
4. Open `../library/passes/index.md` when authored quality or hand-off quality
   needs strengthening.
5. Use `../library/passes/index.md` to route into the right pass area under
   `../library/passes/intent/`.
6. Open `../library/claims/README.md` when shaping, updating, or validating
   Arc evidence, including `pass-effect`.
7. If no local library surface fits, continue with the methodology docs and the
   referenced product artifacts.
8. Record only canonical local library paths in runtime artifacts when a local
   library asset is actually used.

## Multi-library Installs

When multiple library sources are merged into one installed copy:

- Merge assets into `.methodologies/idd/library/` so runtime agents see one
  local library surface.
- Record source IDs and provenance in `.methodologies/idd/status.md` and the
  installed `library/overview.md`.
- Resolve duplicate identifiers or overlapping support paths into one canonical
  local entry before use.
- Use canonical local paths at runtime; source-specific paths are provenance
  only and should not appear in Arc artifacts or reports.

Installed copies may extend the library with helper assets, but
`library/overview.md` remains the single runtime entrypoint for selecting them.
