# IDD Artifacts

## Intent

- Feature: business outcomes and users served.
- Scenarios: user/system situations a feature supports.
- Behaviors: externally observable functional obligations.
- Assurances: non-functional/quality/policy obligations.
- Decisions: ADRs capturing rationale for implementation choices aligned to definitions.

## Blueprint

- Definitions: contracts, schemas, interfaces, glossary, explainers that codify how intent will be satisfied.

## Planning

- Arc: focused run led by a single developer to realize new/changed system behaviors and assurances.
- Steps: smallest units of work inside an Arc, sized to agent/model capabilities.

## Prompting

Developers choose procedures for agents to run while working on a Step. When an agent runs a procedure, the agent reads Intent and Blueprint files, executes the work, and writes durable knowledge back before the conversation is discarded. Running procedures removes the need for ad-hoc chat and keeps knowledge in system-of-record storage.
