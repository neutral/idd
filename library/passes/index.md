# IDD Pass Catalog

This file is authoritative for the pass-family structure, pass selection
guidance, and the full pass set for IDD.

## Start Here

Use this file when you need to answer:

- what passes are for
- where a pass sits in the Intent pipeline
- how pass files are structured
- which pass to open next

Use these next documents:

- one pass leaf file: pass-specific strengthening instructions
- `../overview.md`: library entrypoint
- `../../methodology/LIBRARY.md`: library-layer contract
- `../claims/README.md`: claim catalog, including `pass-effect`

## Path Context

Source repo:

- `library/passes/index.md`

Installed runtime:

- `.methodologies/idd/library/passes/index.md`

## What Passes Are For

Passes are optional library support surfaces for strengthening authored
artifacts and handoffs.

In IDD, passes help transform material that arrives before Intent, sharpen
durable Intent artifacts, translate Intent pressure into Blueprint, and turn
that pressure into execution-ready work.

Passes improve authored quality without changing the core IDD methodology
contract or creating a parallel workflow beside Arc.

## Pass Topology

Use this pipeline split:

- `intent/from-upstream/`: turn upstream material into durable Intent promises
- `intent/within-intent/`: strengthen and reconcile existing Intent artifacts
- `intent/to-blueprint/`: turn Intent pressure into Blueprint obligations
- `intent/to-execution/`: turn Intent and Blueprint pressure into step, proof,
  and execution surfaces

## How To Select A Pass

1. Identify where the current weakness sits in the pipeline.
2. Match that weakness to the narrowest pass that strengthens it directly.
3. Prefer upstream and decomposition passes before tightening passes when the
   artifact shape is still wrong.
4. Prefer Blueprint and execution passes only after the durable Intent target
   is explicit.
5. Use more than one pass only when one pass leaves a different, still-material
   weakness behind.

When more than one pass fits, prefer the pass that most directly reduces
ambiguity for the next durable hand-off.

After opening a pass, work `Pass Steps` in order, stop at the first
`Escalation trigger`, and route through `Hand-off` only after the `Quality
checks` hold.

## Pass File Contract

Every pass file must start with:

- H1: `# Pass: <pass-name>`

Every pass file must then use this section order:

1. `Purpose`
2. `Pipeline position`
3. `Strengthens`
4. `Creates or updates`
5. `Use This Pass When`
6. `Not for`
7. `Inputs`
8. `Preconditions`
9. `Pass Steps`
10. `Pass-effect claim`
11. `Outputs`
12. `Hand-off`
13. `Quality checks`
14. `Escalation triggers`
15. `Arc use`
16. `Runtime notes`

Do not add top-level sections before, between, or after those sections in a
pass file.

Within that structure:

- `Creates or updates` and `Inputs` should name the narrowest concrete
  artifact families or runtime surfaces the pass needs.
- `Pass Steps` should read as the ordered rewrite procedure.
- `Quality checks` should read as exit conditions.
- `Escalation triggers` should read as hard stop conditions.
- `Hand-off` should name the next pass or Arc phase once the pass is ready to
  hand off.
- `Runtime notes` should stay operational and use direct imperative language.

Inside `Pass-effect claim`, use these bullets in this order:

1. `Use claim type`
2. `Claim when`
3. `Before posture`
4. `After posture`
5. `Evidence this pass can supply`

`Use claim type` must always be `pass-effect`.

## Pass-Effect Claims

Use the `pass-effect` claim type when a pass materially improved an Intent,
Blueprint, or step surface and later review would benefit from an explicit
before-and-after posture.

The pass does not create a second logging system. When material:

- create or update the `pass-effect` evidence item in the same Arc phase that
  used the pass
- capture the pass path and posture shift in that `pass-effect` evidence item
- cite that evidence from the current step or Arc surface when it matters to
  proof or review
- do not defer pass-effect capture to a later phase
- keep the underlying durable artifact or step as the primary product surface

## Starter Skeleton

```md
# Pass: <pass-name>

## Purpose

<one-paragraph purpose>

## Pipeline position

- `<intent/from-upstream | intent/within-intent | intent/to-blueprint | intent/to-execution>`

## Strengthens

- <semantic improvement>

## Creates or updates

- <artifact surfaces this pass may create or modify>

## Use This Pass When

- <trigger>

## Not for

- <work this pass must not absorb>

## Inputs

- <artifact or context input>

## Preconditions

- <required condition>

## Pass Steps

1. <rewrite step>

## Pass-effect claim

- Use claim type: `pass-effect`
- Claim when:
- Before posture:
- After posture:
- Evidence this pass can supply:
  - <supporting artifact, diff, or posture evidence>

## Outputs

- <expected stronger result>

## Hand-off

- <what should be ready next>

## Quality checks

- <quality bar>

## Escalation triggers

- <when this pass must stop and surface a blocker>

## Arc use

- <common Arc phase usage>

## Runtime notes

- If this pass materially changes the current run, create or update the
  corresponding `pass-effect` evidence item in the same Arc phase that used
  the pass.
- Do not defer pass-effect capture to a later phase.
- <pass-specific runtime note>
```

## Pass Catalog

- `intent/from-upstream/distill-durable-promises`: turn upstream material into
  durable product promises that belong in Intent
- `intent/from-upstream/extract-product-why`: distill the enduring product
  reason behind the promise
- `intent/from-upstream/bound-scope-and-non-goals`: separate what belongs in
  the current promise from what stays out
- `intent/from-upstream/derive-goal-stack`: derive or refresh the goal layer
  that explains why the promise matters
- `intent/from-upstream/derive-scenarios`: derive scenario surfaces from the
  scoped promise and operating context
- `intent/from-upstream/derive-behaviors`: derive tighter externally meaningful
  behaviors under the scenario layer
- `intent/from-upstream/surface-quality-constraints`: extract the
  cross-cutting constraints that should shape delivery
- `intent/from-upstream/promote-tradeoffs-to-decisions`: turn durable solution
  narrowing into decision artifacts
- `intent/from-upstream/strip-unsettled-material`: remove brainstorming,
  research, and architecture speculation from durable Intent
- `intent/within-intent/align-intent-decomposition`: reconcile goals, features,
  scenarios, and behaviors into one clean decomposition
- `intent/within-intent/tighten-goal-outcomes`: sharpen goals into durable
  system outcomes and success signals
- `intent/within-intent/tighten-feature-outcomes`: turn broad feature prose
  into concrete required outcomes
- `intent/within-intent/tighten-applicability-context`: sharpen actors,
  triggers, entry conditions, and operating situation
- `intent/within-intent/tighten-scenario-checks`: turn scenario narrative into
  precise scenario checks
- `intent/within-intent/tighten-behavior-definitions`: sharpen behavior
  definitions so downstream design pressure is clear
- `intent/within-intent/tighten-behavior-checks`: turn behavior notes into
  observable behavior checks
- `intent/within-intent/sharpen-satisfaction-signals`: make success and
  evidence signals inspectable
- `intent/within-intent/surface-negative-space`: make exclusions, failure
  posture, and invariants explicit
- `intent/within-intent/route-constraints-to-assurances`: move cross-cutting
  quality pressure into the assurance surface
- `intent/within-intent/classify-assurance-criticality`: sharpen assurance
  criticality, priority, and measurable pressure
- `intent/within-intent/stabilize-intent-traceability`: make IDs, refs, and
  target addresses stable and complete
- `intent/within-intent/de-duplicate-overlapping-promises`: remove duplicate or
  competing promise surfaces
- `intent/within-intent/merge-fragmented-intent`: combine split surfaces that
  should form one durable promise
- `intent/within-intent/split-overloaded-intent`: divide one overloaded
  artifact into cleaner durable promise units
- `intent/within-intent/tighten-decision-records`: sharpen durable narrowing in
  decision artifacts
- `intent/to-blueprint/align-blueprint-targets`: make Blueprint target
  selection exact and complete against Intent
- `intent/to-blueprint/extract-blueprint-contract-pressure`: turn Intent
  pressure into concrete Blueprint contract obligations
- `intent/to-blueprint/derive-verification-obligations`: derive the
  verification burden that Blueprint and Code must satisfy
- `intent/to-blueprint/map-intent-to-code-impact`: map the likely code,
  description, and test surfaces implied by the Intent slice
- `intent/to-execution/raise-verification-specificity`: turn weak verification
  language into concrete checks, evidence, and closure conditions
- `intent/to-execution/shape-executable-step`: turn a vague step into a
  bounded, exact-target, evidence-ready, execution-safe step
- `intent/to-execution/split-overloaded-step`: detect when one step carries too
  much novelty, scope, or proof burden and rewrite it into smaller steps

## Runtime Use

- Passes are optional library support surfaces.
- Start from this file, then open the narrowest matching pass.
- Use `pass-effect` only when a pass materially shaped the current run.
- Create or update `pass-effect` evidence in the same Arc phase that used the
  pass.
- Record canonical local pass paths in runtime artifacts only when a pass
  materially shaped the current run.
- Do not defer pass-effect capture to a later phase.
- Passes do not define a separate runtime lifecycle or logging contract.
