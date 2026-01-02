# Blueprint Files

Blueprint files codify how Intent will be implemented through explicit contracts and definitions. They translate user obligations into actionable specifications for humans and agents.

Examples:

- Research finding
- Environment setup
- Data models and schemas (with validation rules)
- API contracts (request/response, status codes, error models)
- Use Cases
- Event/message shapes and topics
- Algorithms and calculations
- Integration boundaries and error behaviors
- UI / UX behavior (screens, states, error messages)
- Glossary entries and explainers
- Budgets and limits (performance, payload sizes, rate limits)
- Rollout State: KPIs, Flags, Analytics

Each Blueprint must link back to the Intent behaviors or assurances it satisfies.

- Global blueprints: `intents/blueprints/**`
- Feature-scoped blueprints: `intents/system/<feature>/blueprints/**`

Contracts must be concrete and testable (OpenAPI/JSON Schema/protobuf, structured examples). Version schemas, messages, and budgets so changes are traceable.

## Template (minimum)

```yaml
---
id: <id>
status: draft
owner: <team or role>
upstream: []
module: []
tags: []
---
```

Add the sections needed to specify the contract and link back to the relevant Intent.
