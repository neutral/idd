# Decision Records (ADRs)

Decisions capture significant architectural or product choices and their context so Intent, Blueprint, and Code stay aligned and teams understand how to revisit them.

Store them under Intent. Global decisions go in `intents/decisions/`. Feature and Scenario level decisions live under `intents/system/<feature>/decisions/` or nested scopes. Link each decision to the Intent behaviors/assurances it affects and to the Blueprint files/contracts it informs.

Write an ADR when choosing across meaningful alternatives:

- Making architectural choices that affect system structure
- Choosing between multiple viable approaches
- Adopting new tools, libraries, or patterns
- Establishing conventions or standards
- Reversing or modifying previous decisions

Update existing decisions when:

- The decision is modified but not completely reversed
- New information validates or challenges the decision
- Consequences (positive or negative) become apparent
- Review triggers are reached

Don't document every tiny choice.

Create a decision file with the following template:

## Context

Capture Background, constraints, forces, requirements, risks.

## Decision

Record the choice made. Include scope and rationale in 1–3 sentences.

## Options Considered

List all options considered, and their pros/cons.

## Consequences

Positive/negative effects, follow‑ups, migration notes.

## Implementation Details

Implementation details

## Verification

How this decision is validated in practice: tests, metrics, reviews.

## Status & History

Dates, reviewers, links to PRs/issues, and status changes.
