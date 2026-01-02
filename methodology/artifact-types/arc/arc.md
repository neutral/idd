# Arc — package of work

Each Arc captures a scope of implementation work for a short, single developer-led push to add new features or capabilities to the codebase. Arcs keep Intent, Blueprint, and Code moving forward together for the same user need.

Arc files are stored in the `intents/arc/` folder. Each working branch contains at most one Arc in progress.

Each arc is split into one or more sequentially numbered steps. Developer needs to size the steps in the Arc based on both the developer's intended level of involvement as well as the agentic/thinking capabilities and context sizes of the model they are using to accomplish the implementation work outlined in the step.

Arc Folder Organization:
arc.md contains all arc information. Steps can initially be written at a high level and added to arc.md. They will be expanded later into individual step files, and once complete the step file is moved to the \_done folder. \_scratch folder is available to store temporary notes.

```text
intents/arc/
  _done/
    step-01-insert-offer-slot.md
  _scratch/
    notes.md
  arc.md
  step-02-integrate-pricing-api.md
  step-03-track-conversions.md
  step-04-closeout.md
```

Archive the arc and its files using the archival process.

Developer uses procedures to evolve Intent artifacts, Blueprint files, and source code towards the set of identified goals. Agents run procedures using Intent/Blueprint/Code files and the planning information present in `arc/steps` to transform artifacts to their next state without relying on freeform chat. The goal is to select the context and procedure needed to move the codebase forward, then have an agent run it and store important information back into Intent, Blueprint, or `arc/steps` before discarding the conversation.

Create an arc.md file with this template:

## Purpose

What features/outcomes the arc delivers.

## Definition of Done

Explicit completion criteria for the arc

## Steps

List all the individual steps.

Each step can start with a few bullet points as part of arc initialization. Steps are expanded into their own files later. This avoids having to develop an elaborate plan upfront for the entire arc when some decisions for later steps can be made as the implementation progresses and additional details are uncovered.

## Risks & Mitigations

brief

## Review

Capture final verification and review.
Use a review procedure to audit the entire set of work done in the Arc to close the arc.

## Notes

External Links – PRs, dashboards, docs
