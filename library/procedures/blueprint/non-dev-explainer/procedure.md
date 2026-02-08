# Non-Developer Explainer

## Purpose

Create a concise explainer for a subsystem or technology that helps non-developer collaborators understand what it is, why we use it, and how it behaves in this project.

## When to use

- You need a non-code explainer tied to a behavior, assurance, or blueprint contract.
- The subsystem changed and documentation must be updated for non-developers.
- A decision or goal should be communicated in plain language.

## Guidelines

- Writing style: use `style.md` in the local procedure folder; if missing, flag it.
- Keep language practical and avoid source-level detail.
- Prefer bullets over paragraphs.

## Tools

- None required.

## Pre-requisites

- Confirm the subsystem name and a 1–2 sentence project-context description are provided; if missing, stop and ask for them.
- Confirm the intended output location is known (which Blueprint folder to write into, and the desired filename); if unclear, stop and ask where to place the explainer.
- Confirm there is at least one anchor artifact to tie the explainer to (a behavior, assurance, blueprint contract, goal, or decision under `intents/`); if none are available, stop and ask for the relevant references or for approval to write a standalone explainer without anchors.

## Gather Context

- Behavior or assurance files under `intents/system/` related to the subsystem.
- Subsystem name and a short project-context sentence.
- Relevant blueprint files (contracts, definitions, interfaces).
- Decisions or goals that explain why the subsystem exists.
- Related code modules and `*.desc.md` files to ensure the explainer matches actual behavior.
- Active Arc step if the explainer is tied to in-progress work.

## Write Non-Developer Explainer

- Write a single Markdown explainer under the relevant Blueprint folder (for example, `intents/blueprints/` or `intents/system/<feature>/blueprints/`) using `template-explainer.md`.
- Fill sections with short, practical bullets and add references.
- Add a link to the explainer in related `*.desc.md` files when it clarifies the implementation.
- Record the procedure run in the Arc Step "Procedure Log".

## Verification

- Confirm the explainer file is in the intended Blueprint folder.
- Verify references to behaviors, assurances, goals, and decisions.
- Run doc checks if the repo has them.

## Report

- Summarize what was added or updated.
- Provide the explainer file path.
- Note missing inputs or follow-ups.
