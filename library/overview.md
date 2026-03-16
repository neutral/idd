# IDD Library Overview

This file is the runtime entrypoint for selecting local library resources.

## Use This File When

Use this file when you need to answer:

- whether the current repo has local library guidance beyond the built-in
  methodology
- which local library surface to open next
- where the IDD pass catalog lives for authored-quality and hand-off
  strengthening
- where the IDD claim catalog lives for Arc evidence, including `pass-effect`
- how source-repo paths differ from installed runtime paths

## Path Context

Source repo:

- `library/overview.md`

Installed runtime:

- `.methodologies/idd/library/overview.md`

## Agent Navigation

1. Start in `../methodology/ARC.md` for Arc stage selection.
2. Open this file when reusable local guidance or helper assets may help the
   current run.
3. Open `passes/index.md` when authored quality or hand-off quality needs
   strengthening support.
4. Use `passes/index.md` to route into the right pass area under
   `passes/intent/`.
5. Open `claims/README.md` when the Arc needs the IDD claim catalog for
   evidence work, including `pass-effect` evidence.
6. If the installed library contains additional local surfaces, follow the
   canonical local path recorded here.
7. If no local library surface fits, continue with `../methodology/arc/` and
   the referenced product artifacts.
8. Record only canonical local library paths in runtime artifacts when a local
   library asset is actually used.

## Starter Package Shape

The starter IDD package ships a small library:

- `overview.md`: runtime entrypoint and extension surface
- `passes/index.md`: pass catalog, pipeline routing, and pass-family rules for
  authoring support
- `claims/README.md`: claim catalog and claim-family rules for Arc evidence,
  including `pass-effect`

Installed copies may merge additional local resources into
`.methodologies/idd/library/`.

If no extra local resources are installed, this file routes the agent back to
the built-in methodology docs rather than inventing a new library surface.

## Library Sources

- `primary`: this IDD source repo `library/`
- `additional`: installed-library merges tracked in `.methodologies/idd/status.md`

## Merge Resolution

- Installed local entries override starter content when they define the
  canonical local surface for the current repo.
- Runtime usage should reference canonical local paths under
  `.methodologies/idd/library/`, not source-repo paths.
