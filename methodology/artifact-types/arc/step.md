# Step

A step defines a bounded piece of work. Each step file focuses on planning to achieve one concrete objective on the path to finishing the arc. Bias towards sizing the work in a step small for reliable model runs and fast human review; each step updates code plus the Intent and Blueprint artifacts. Changes introduced by each step should be in testable form to allow the model itself to verify effectively.

Developer runs one or more procedures to expand the implementation plan and accomplish the work captured as part of the step.

Step files live in the Arc folder (`intents/arc/`), which is used as the staging area to record planning information to handoff between procedures as work progresses within the step, and between steps as work progresses to finish the arc.

Steps are sequenced and worked upon in sequential order. Intermediate steps discovered later can be introduced with an alphabet extension to the step number.
Step files begin with a zero‑padded sequence: `step-01-`, `step-02-`, … to keep steps naturally ordered and define execution order.
Use a short slug to name the step, a few words summarising the change (`add-auth`, `refactor-db-layer`) it aims to achieve.

The lowest‑numbered step file is considered _active_.

Once a step is complete it is moved to the `_done` folder within the arc folder.

General process is during the arc initialization all the steps required to achieve it are identified with a few lines per step. A step file is created later to record the plan as it is being worked upon to update both the Intent/Blueprint artifacts and code to implement the high level goals outlined for the step. It is ok to not have all the steps outlined upfront in arc.md and it can be done as work progresses.

Create a step file with the following template:

## Objective

Implement `<concise goal>` …

## Current State

Current state of the project

## Proposed Changes

High level points

## Implementation Plan

- [ ] Intent artifacts to add/modify
- [ ] Blueprint files/decisions to add/modify
- [ ] Source code to add/modify
- [ ] Description files to add/modify
- [ ] Tests to add/modify
- [ ] Observability to add/modify
- [ ] Verification
- [ ] Update docs

## Technical Design

- Request/response shape
- Algorithm
- Database interactions
- Policies & limits
- Integration details

## Key Decisions

Key decisions

## Performance Considerations

Performance considerations

## Security Notes

Security notes

## Notes

Capture notes for agents to use while running procedures through the step.
Capture updates to next steps.

## Procedure Log

Capture the procedures used and a brief summary of the changes introduced to the repo along with date and time.
