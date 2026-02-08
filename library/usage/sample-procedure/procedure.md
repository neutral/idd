# Sample Procedure: Blueprint + Code Sync

## Purpose

Update a blueprint contract and generate or update the related code so the Code layer stays aligned with Intent and Blueprint. This sample demonstrates how a procedure references local guidelines, uses templates, and ships a repeatable workflow.

## When to use

- You need to change a contract (schema, API, model, error behavior) and then update code to match it.
- Example scenario: add a retry policy to outbound notification delivery, update the blueprint contract, and generate the code path plus description files.

## Guidelines

- Writing style: use `style.md` in the local procedure folder; if missing, flag it.
- Follow project naming and file placement conventions.
- Keep blueprint edits minimal and traceable to the relevant intent artifacts.

## Tools

- `scripts/verify-blueprint-links.sh`: quick check for missing blueprint references in description files. Copy from `common/tools/verify-blueprint-links.sh` into this procedure folder when setting up locally.

## Pre-requisites

- Confirm the change request is concrete: which contract is changing, what the new behavior is, and any compatibility constraints; if unclear, stop and ask for specifics.
- Confirm you can locate (or are given) the relevant Intent artifacts, Blueprint contract file(s), and corresponding code areas before making edits.
- Confirm there is an active Arc Step (or agreed logging location) for recording the procedure run; if not, stop and ask where to log it.
- Confirm there is a known way to verify blueprint links in description files (repo script, doc check, or manual review) so you can validate references after changes.

## Gather Context

- Read the relevant intent artifacts (feature, behaviors, assurances).
- Locate the blueprint file(s) that define the contract being changed.
- Review the current code and any description files tied to the contract.
- Check the active Arc Step notes for scope and constraints.

## Sync Blueprint and Code

- Update the blueprint contract file(s), using `template-blueprint-update.md` as a checklist.
- Generate or update code to match the new contract and write or update description files.
- Use `template-code-change.md` as a checklist to confirm coverage of changes.
- Record the procedure run in the Arc Step "Procedure Log".

## Verification

- Run the repo's standard checks that cover the changed area (tests, lint, or build).
- Confirm blueprint links in description files are accurate.

## Report

- Summarize intent, blueprint, and code changes.
- Call out any follow-ups or gaps in verification.
- Include file paths and any commands run.
