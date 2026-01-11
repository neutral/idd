# Assurances

Assurances are Intent artifacts that capture quality attributes, policies, and operational targets. They must stay traceable to: features → scenarios → code → tests → monitors and alerts.

Each assurance must have:

- a metric
- a target
- evidence (CI checks and/or production signals)
- trace links (where it is implemented and verified)

## Scope, Exhaustiveness

- The assurances captured in Intent are exhaustive for the code-generated system: anything that should constrain or shape code, configuration, tests, and instrumentation in this repository must be represented as an assurance (global baseline, feature refinements, and scenario deltas).
- Operational concerns that are not directly expressible or enforceable through repository artifacts (examples: on-call staffing, incident response process, pager rotations, manual runbooks unrelated to code, external vendor SLAs managed outside the repo) may live elsewhere. When relevant, link to those external artifacts from the nearest assurance entry, but treat Intent as the canonical source for constraints that should guide code generation and change.

### How to ensure exhaustiveness in the narrow (code-generated) sense

- The global baseline must enumerate a complete catalog of assurance IDs for the repository’s code-governed concerns. The catalog is considered complete when every critical category below has at least one baseline assurance with concrete evidence expectations.
- Every feature assurance doc must include a baseline disposition section that explicitly classifies every global assurance ID as one of: Inherited, Overrides, Not applicable.
- Every feature must also declare its critical paths and verify coverage by assurances: for each critical path, there must be at least one assurance covering:

  - reliability and error handling
  - security and privacy if any sensitive data or auth is involved
  - observability
  - performance where user experience depends on it

- Scenario assurance docs must contain only deltas, but must also list which critical path they correspond to.

## Levels, files, and precedence

### What each level must contain

- Global: a stable catalog of “baseline assurances” with IDs and default targets + verification expectations.
- Feature: a disposition list for baseline items (Inherited / Overrides / Not applicable) + any new feature-specific assurances.

### Where assurance files live

- Global (system-wide): `intents/system/assurances.md`
- Feature: `intents/system/<feature>/assurances.md` or `intents/system/<domain>/<feature>/assurances.md`

### Precedence rules

- Feature > Global. Overrides must be explicit. Anything not mentioned at feature level is inherited.
- Weakening a baseline target or control requires: explicit Overrides, justification, compensating controls, and a review-by date.

## Categories

Think in two groups:

### Quality attributes (system behavior under stress)

- Performance (latency, load time, throughput)
- Reliability and availability (SLOs, error budgets)
- Resiliency and DR (degraded modes, failover, RPO and RTO as applicable to code and config)
- Scalability (capacity limits, burst behavior)
- Observability (logs, metrics, traces, dashboards, alerts)
- Usability (guardrails that prevent operator/user error)
- Accessibility
- Compatibility (runtime/browser/device support)
- Maintainability (operability, change safety)

### Policy and risk controls (what must not happen)

- Security (authentication and authorization, vulnerability management, secrets, transport)
- Privacy and data governance (PII handling, retention and deletion hooks, consent)
- Compliance (domain-specific obligations where applicable)

### Constraint strength

- Hard constraints: Security, Privacy, Compliance (default Criticality: Blocker)
- Strong constraints: Reliability and availability, Observability, Accessibility (default Criticality: Strong)
- Best effort unless elevated: Performance, Scalability, Compatibility, Maintainability

A feature may elevate criticality. Lowering defaults requires an explicit override rationale.

## Assurance writing standards

Every assurance entry must include:

- stable ID and name
- level and applies-to scope
- category
- criticality and priority
- quality scenario (ATAM-style)
- metric definition (where measured, percentile and window, inclusion and exclusion rules)
- targets and budgets (numbers and caps)
- evidence (CI checks and production signals; name specific tests and dashboards)
- implementation patterns and examples (how to satisfy it in code)
- trace links (feature and scenario docs, check IDs, dashboards and runbooks, key code locations)
- lifecycle (review cadence)

### Conflict handling expectations

- An assurance may conflict with another (example: strict rate limiting versus usability; stronger encryption versus latency).
- Each assurance entry must either:

  - declare itself as a hard constraint that cannot be traded off (Blocker), or
  - document acceptable tradeoffs in the Conflicts and Tradeoffs field, including which assurances win and how the system behaves under that resolution.

- If a change would violate a Blocker assurance, it must be redesigned or explicitly overridden with justification and compensating controls.

## Workflow: authoring global assurances

This is the “system contract”. The goal is a small, universal baseline that is measurable and enforceable.

### 1. Establish scope and narrow exhaustiveness

- Confirm the boundary: Intent is exhaustive for constraints that shape code, configuration, tests, and instrumentation.
- List any operational-only items that live elsewhere and how they will be linked when relevant.

### 2. Define baseline catalog and IDs

- Create stable IDs across core categories.
- Keep the baseline small but complete: only include assurances that both constrain code and are measurable and verifiable.

### 3. Decide default criticality and conflict policy

- Set default Criticality and priority by category (Blocker, Strong, Best effort).
- Write a short global conflict policy: Blocker constraints win; tradeoffs must be documented in Conflicts and Tradeoffs.

### 4. Write baseline quality scenarios

- For each baseline assurance, include at least one scenario covering:

  - normal operation
  - peak or burst
  - dependency degradation (timeouts and errors)
  - misuse or abuse (for security and privacy)

### 5. Set targets, budgets, and metric definitions

- Define the measurement rules once (so teams don’t argue later):

  - percentile (p95/p99), window (5m/1h/28d), population (all requests vs key routes),
  - where measured (client RUM vs server), and what counts as “success”.

- Typical baseline targets you can adopt as defaults (adjust to your reality):

  - Availability (critical APIs): 99.9% per 28 days; define “available” as non-5xx non-timeout responses.
  - Server request latency: p95 ≤ 300ms for “standard” endpoints; p95 ≤ 800ms for “heavy” endpoints (explicitly labeled).
  - Error rate: 5xx ≤ 0.1–0.5% (pick one) with paging threshold tighter on critical routes.
  - Client UX (key pages): Core Web Vitals targets (e.g., LCP, INP, CLS) measured via production RUM; define device/network profile for lab checks.
  - Accessibility: WCAG 2.2 AA on all user-facing screens; keyboard + screen-reader on critical flows.
  - Security hygiene: no critical/high vulns past SLA; secrets scanning required; TLS enforced; least-privilege.
  - Privacy: PII never in logs; retention and deletion expectations defined.

### 6. Define evidence and enforcement hooks

- For each baseline assurance, specify:

  - CI gates (tests, scans, lints, performance and accessibility) that can fail a change
  - production signals (dashboards, alerts, SLOs) that detect regressions

### 7. Define implementation patterns and examples

- For baseline assurances that should not be reinvented, define canonical patterns and link them:

  - retry and timeout helper patterns for dependency calls
  - logging wrapper and rules, including fields that must not be logged
  - authentication and authorization middleware patterns
  - metrics and tracing conventions and helpers

- Provide at least one reference example per commonly reused baseline assurance.

### 8. Define override mechanics

- Require explicit Overrides, rationale, compensating controls, and review-by date for any weakening.
- Identify approval owners for Blocker category overrides (security, privacy, compliance review).

### 9. Ownership and lifecycle

- Assign category owners.
- Define review cadence and update triggers (major releases, post-incident).

## Workflow: authoring feature-level assurances

Goal: apply the baseline explicitly, add only the necessary feature-specific constraints, and make them enforceable.

### 1. Feature scoping and critical paths

- Identify: List the feature’s critical paths (user journeys and service flows).
- Enumerate dependencies: internal services, third parties, queues, caches, identity providers.
- Classify data touched: public / internal / sensitive / regulated (whatever taxonomy you use).

### 2. Create feature assurance file and baseline disposition

- Create `intents/system/<feature>/assurances.md` or `intents/system/<domain>/<feature>/assurances.md`.
- Add a baseline disposition section that lists every global assurance ID with:

  - Inherited, Overrides, or Not applicable (with rationale).

### 3. Assign criticality and priority for feature context

- Elevate criticality where feature risk is higher (sensitive data, money or entitlements, high traffic, irreversible actions).
- If lowering baseline strength, mark Overrides with rationale, compensating controls, and review-by date.

### 4. Add feature-specific assurances only for new or changed risk

Examples of triggers:

- new sensitive fields → privacy, logging, access control, audit constraints
- new external dependency → resilience, timeouts, retries, graceful degradation
- new write path → stronger correctness and idempotency constraints
- new high-traffic endpoint → performance and scalability caps and rate limiting

### 5. Write feature quality scenarios

- For each New or Overrides assurance, write scenarios for:

  - steady state
  - peak/burst traffic
  - dependency degradation
  - misuse or abuse where relevant

### 6. Allocate budgets and define targets

- Start from the user-visible outcome, then budget backwards:

  - client time budget → network → gateway → service → DB → external dependency

  - Specify:

    - latency percentiles + concurrency/throughput expectations,
    - rate limits (per user/IP/token) where appropriate,
    - payload size caps,
    - retry policies (max attempts, backoff, jitter) and timeout ceilings,
    - caching expectations (what’s cacheable, TTL, invalidation strategy).

### 7. Bind verification and enforcement (must be specific)

Each assurance must name at least one automated CI signal _and_ one production signal (unless it’s purely design-time policy, which should be rare).

- CI evidence examples to bind explicitly (pick what applies):

  - unit/integration tests for edge cases and invariants,
  - contract tests for service/service or client/API contracts,
  - end-to-end tests for critical flows,
  - performance checks with budget thresholds (route-level, endpoint-level),
  - accessibility audits on key pages/flows,
  - security scans (deps + secrets) and SAST rules,
  - schema/static checks for logging (PII redaction), config, infra policies.

- Production evidence requirements:

  - dashboard(s) per critical path: latency, error rate, saturation, dependency health,
  - alert(s) with clear paging thresholds and runbook links,
  - SLO definition (if customer-impacting) and error budget policy (what happens when it burns).

- Promote Draft to Accepted only when CI and monitoring hooks exist.

### 8. Define implementation patterns and examples

- For each assurance, link the canonical patterns to use, and add feature-specific examples:

  - which retry helper and standard timeout wrapper applies
  - which logging wrapper must be used and which fields must be redacted or omitted
  - which contract-test harness validates integration behavior

- Add explicit Do and Do not bullets to reduce ambiguity for code generation tools.

### 9. Conflict handling for the feature

- For any assurance where a tradeoff is likely, fill Conflicts and Tradeoffs with:

  - which assurance wins
  - what the system does under that resolution (fail closed or open, degrade UI, and so on)

- Ensure Blocker constraints remain non-negotiable unless explicitly overridden.

### 10. Traceability

- For each assurance entry, fill `Trace` fields:

  - link to `feature.md` and the scenarios it affects,
  - list check IDs/test names,
  - link dashboards/alerts,
  - link runbooks for failure modes,
  - reference code docs (`_file.desc.md`) where the behavior is implemented.

### 11. Acceptance criteria and lifecycle

- Mark `Draft` until CI + dashboards exist.
- Move to `Accepted` only when:

  - CI checks pass and are required in the pipeline, and
  - production monitors are deployed (or ready for launch behind a flag).

- On incidents, update:

  - targets (if unrealistic) _or_ implementation (if target is right),
  - add new scenarios and evidence where gaps were exposed.

## Generating succinct prompt content from assurances

Assurances can be distilled into a short, scoped guardrail brief for an LLM or agent by selecting the Accepted items that apply (global plus feature plus scenario), prioritizing Blocker then Strong, and extracting only:

- do and do not rules from Implementation patterns and examples
- numeric targets from Targets and Budgets
- required checks from Evidence (CI)
- key monitoring expectations from Evidence (Prod)

Include the assurance IDs so the agent can cite them and so reviewers can trace decisions back to the canonical entries.

## Template

File frontmatter:

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

### `<ASSUR-ID>`: `<Assurance Name>`

- Level: Global | Feature

- Applies to: All | `<feature>`

- Category: Performance | Reliability | Security | Privacy | Accessibility | Observability | ...

- Criticality: Blocker | Strong | Best effort

- Priority: P0 | P1 | P2

- Disposition: New | Inherited | Overrides

- Inherits from: `<ASSUR-ID>` | None

- Quality scenario:
  Source=`<who or what>`, Stimulus=`<event>`, Environment=`<normal or degraded or peak or attack>`,
  Artifact=`<component or flow>`, Response=`<expected behavior>`, Measure=`<metric>`

- Metric definition:
  `<where measured (lab, CI, or prod), percentile and window, success criteria, exclusions>`

- Targets and Budgets:
  `<numbers: latency, availability, error rate, bundle caps, rate limits, retention, and so on>`

- Evidence:

  - CI: `<test or check name and location or ID>` (Automated or Manual)
  - Prod: `<dashboard and alert and SLO if applicable>`
  - Reviews: `<threat model, privacy review, and so on>`

- Implementation patterns and examples:

  - Preferred patterns and helpers: `<links to wrappers or utilities>`
  - Do: `<short bullets>`
  - Do not: `<short bullets>`
  - Reference examples: `<links to code paths or snippets>`

- Conflicts and Tradeoffs:
  `<if this assurance competes with others, define resolution rules and expected behavior>`

- Trace:
  Feature=`<link>`, Scenario=`<link>`, Checks=`<ids>`, CodeDesc=`<_file.desc.md>`, Runbook=`<link>`, Tickets=`<ids>`

- Owner and Status: `<name or team>` / Draft | Accepted | Deprecated

- Review-by:
  `<date or trigger; required for Overrides that weaken baseline>`

- Notes:
  `<dependencies, fallback or degraded mode, rollout constraints, edge cases>`
