# Analyze and Expand Current Step

## Purpose

- Expand one Arc step at a time into an actionable, verifiable plan that an implementer can follow verbatim.
- Preserve traceability to Intent and Blueprint artifacts.
- Require a complete test plan that includes a happy path and negative cases.
- Keep the output plan-only: do not implement code or create files.

## When to use

- You need to turn a vague Arc step into a detailed, executable plan.
- The current Arc step needs explicit updates for intent artifacts and blueprint contracts.
- You want to ensure the implementation plan includes tests, verification, and checks.

## Guidelines

- Writing style: use `style.md` in the local procedure folder; if missing, flag it.
- Only edit the active step file in the Arc folder; do not modify other files.
- Plan updates to intent artifacts and blueprint contracts without implementing them.
- Include description file updates for any modified sources.
- Add Refs lines in the step expansion that point to the exact goals, behaviors, assurances, blueprint files, and decisions.
- Require a happy-path test and negative cases in the test plan.

## Tools

- None required.

## Pre-requisites

- Confirm the repo has an Arc folder (typically `intents/arc/`) containing `arc.md` and step files; if not, stop and ask for the Arc path (or for the Arc to be created).
- Confirm `arc.md` makes it possible to unambiguously identify the current step (lowest numbered not marked done/skipped); if ambiguous, stop and ask which step to expand.
- Confirm the active step file exists and is writable; if missing, stop and ask for the correct step file name/path.

## Gather Context

- The current Arc folder (typically `intents/arc/`) and its step files.
- The Arc summary file (`intents/arc/arc.md`) to confirm step ordering and status.
- `intents/system/goals.md`, relevant behaviors and assurances.
- Relevant blueprint files, ADRs, and user flow artifacts.
- Existing `*.desc.md` files tied to the code that will be touched.
- The code areas referenced by the step (paths and ownership in `*.desc.md`).

## Expand Step

- Identify the current step (choose the lowest numbered step not marked done or skipped in `arc.md`).
- In the active step file, expand the step in place using `template-step-expansion.md`, filling each subsection with explicit file paths, commands, and criteria.
- Include explicit Refs to related intent and blueprint artifacts.
- In the step file, list intended updates to intent, blueprint, code, tests, and related `*.desc.md` files without changing them here.
- Record the procedure run in the Arc Step "Procedure Log" section.

## Verification

- Confirm only the active step file was edited.
- Ensure the plan includes all required subsections and commands.
- Verify the test plan includes a happy path, negative cases, invariants, and commands.
- Ensure intent and blueprint updates list exact file paths and change intent.

## Report

- Summarize which step was expanded.
- Provide the Arc step file path.
- Note any missing context or open questions.
