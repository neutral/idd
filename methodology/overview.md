# Intent-Driven Development

IDD is organized as a stack of three layers that evolve together to satisfy a given user need. Each layer is both:

- conceptual (how you reason about the work), and
- concrete (how you store the artifacts that agents and humans use to generate and verify software).

The three layers together help agentic coding perform far better than prompts that attempt to update code directly in a repo without structure.
Intent communicates the system model to humans; Code runs that model on machines; Blueprint makes the contract between them explicit.
Work can start in any layer, but the discipline is to keep all three aligned. A code-first hotfix or experiment must be captured back into Intent and Blueprint, just as a new intent or contract must be reflected in Code.

## The three layers

### Intent Layer (capture goals and outcomes)

The Intent Layer captures what must be true from the user’s perspective, without prematurely committing to implementation details.

- Intent: the concept and phase that captures user needs at a high level.
- intent: an individual artifact that records Intent for a feature, capability, or change.
- intents: the collection (for example, an `intents` folder) that holds multiple intent artifacts.

What belongs here:

- User needs
- Key scenarios and expected behaviors (including edge cases)
- Assurances clarifying constraints (security, privacy, compliance, performance, reliability)
- Clear, testable acceptance criteria and verification checks, defined upfront
- Decisions (ADRs) that preserve why choices were made

Role in IDD:
Intent reduces ambiguity. It provides the evaluation surface that generated software must satisfy, minimizing review churn and guessing by agents.

### Blueprint Layer (codify the contracts)

The Blueprint Layer captures how Intent will be made true in a form that is immediately actionable for humans and agentic tools, via explicit definitions, interfaces, and contracts.

- Blueprint: the concept and phase that defines how Intent will be implemented.
- blueprint: an individual artifact that records how a specific intent (or group of intents) will be implemented.
- blueprints: the collection (for example, root-level and feature-level `blueprints` folders) that holds multiple blueprint artifacts.

What belongs here:

- Definitions, schemas, and data models
- Contracts, invariants, and interface definitions
- API specifications and integration boundaries
- Error model and failure behaviors
- Migration notes and compatibility expectations
- Test contracts (what must be covered and why)

Role in IDD:
Blueprints constrain generation. They translate Intent into a shape that agents can implement consistently, reducing divergence and increasing correctness within organizational standards.

### Code Layer (generate and verify)

The Code Layer is the implementation output: the working system that proves Intent has been satisfied under the constraints described in the Blueprint.

The system is produced in tight feedback with the relevant intents and blueprints: code, infrastructure, checks, and supporting artifacts. Agents implement code, tests, and gates from the described Behaviors and Assurances plus the corresponding blueprints, then execute checks to validate outcomes.

- Code: the implementation output (source files, description files, tests)

What belongs here:

- Source code and supporting configuration
- Description files accompanying source code files
- Automated tests that validate Intent checks and Blueprint contracts

Role in IDD:
Code is the executable artifact. In IDD, it is kept in sync with higher-trust artifacts (Intent and Blueprint) rather than treated as the sole source of truth.

## Sources of truth and drift prevention

IDD explicitly positions:

- intents and blueprints as the sources of truth
- Code as the implementation output

When implementation details drift or assumptions change, IDD restores alignment by updating the relevant intents and blueprints, then regenerating or modifying Code accordingly.

## How Arc coordinates the three layers

Arc is the working loop that sizes, sequences, and coordinates work so that the Intent, Blueprint, and Code layers move forward together for a given need, at a predictable cadence.
Each working branch carries at most one Arc stored in `intents/arc/`.

Rather than treating the layers as a strict handoff (requirements → design → build), Arc enforces co-development:

- Intent is refined as implementation realities are discovered, without allowing implementation to silently redefine the requirement.
- Blueprint is refined as contracts, boundaries, and edge cases become clear, without letting agent output invent interfaces ad hoc.
- Code is generated and updated continuously as the executable proof of progress, without allowing code to become the only real truth.

Within this loop:

- Tests and checks validate that Code satisfies the Intent and conforms to the Blueprint.
- Failures are routed back to the appropriate layer (missing requirement, missing contract, or incorrect implementation).
- The outcome is not just “code that runs,” but Intent, Blueprint, and Code that agree.
- Subsequent changes are faster: agents can be re-run against stable, explicit artifacts rather than re-deriving context from the codebase.

Arc prevents layer drift, keeps agent work bounded and repeatable, and ensures each shipped increment is simultaneously well-specified, well-constrained, and correctly implemented.

Arc stages planning to deliver one or more features with a coding agent. Arc files form a staging area for planning details that developers and agents need while keeping Intent + Blueprint + Code aligned for those features. Durable knowledge is moved out of Arc into intent artifacts (Goals, Features, Behaviors, Assurances, Decisions) and blueprint artifacts.

Steps are the smallest unit of planning and execution. Arcs define a cohesive high-level plan but let developer and agent tackle delivery in Steps sized to model capabilities. Steps are worked sequentially.

## Procedures

Procedures are reusable prompts, invoked in a standard way. Agents run procedures to pull context from intent artifacts and blueprints and write results back before the conversation is discarded. They guarantee retention and structure:

- Durable knowledge goes to intents and blueprints.
- Planning details stay in Arc.

A shared procedure library is available in the public `idd-procedures` repo.
Developers can also use one or more additional procedure libraries (public or internal).
Keep a local copy of the procedures you use in a `.procedures/` directory at the repo root and add it to the repo’s `.gitignore`.

Developers can safely discard chat history, knowing agents running procedures have persisted what matters into various IDD artifacts.

## Why this works for coding agents

- Retrieval: Agents fetch only the needed intent and blueprint artifacts, not the entire corpus.
- Decomposition: Features enumerate required Behaviors and Assurances; definitions scope to those obligations.
- Traceable generation: IDs and links let orchestrators fetch precisely the intents and blueprints for a slice of work.
- Proof-driven: Verification lives in Intent; contract details live in Blueprint; both feed Code generation.
- Composable updates: Changing an obligation (Intent) or a contract (Blueprint) requires editing the relevant artifact and re-running generation and verification.
- Parallelizable: Multiple lanes let agents work independently; errors must align across lanes to invalidate the spec or source, rather than any single lane silently redefining intent.
