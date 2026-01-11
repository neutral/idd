# Development Rules and Conventions

## Consult Intent + Blueprint First

- Always check the `intents/` folder for requirements and assurances when implementing features.
- Intent is the authoritative “what must be true”; Blueprint files are the contracts/specs for “how it will be made true.”
- Keep Intent, Blueprint, and Code aligned as work progresses. Intent communicates the model to humans; Code runs it on machines. You can start in any layer, but reconcile changes by updating the other layers as needed.
- Treat Code as the implementation output that must satisfy Intent and Blueprint; verify changes against both.
- Capture definitions in `intents/blueprints/` (or feature-specific `intents/system/<feature>/blueprints/` / `intents/system/<domain>/<feature>/blueprints/`) and decisions in `intents/decisions/` or feature-level decision folders.

## Documentation Requirements

- Source files require both code comments and `.desc.md` description files
- Keep documentation concise and focused on non-obvious aspects
- Description files (.desc.md) provide the "why" behind the code, complementing the "what" in the source files and making the codebase more maintainable and understandable for future developers.
- Intent and Blueprint artifacts are sources of truth for what and how, but they are not substitutes for codebase documentation. Code still needs clear comments and readable structure. Description files bridge Intent/Blueprint context to code; they do not replace in-code explanations.

## File Processing

file crawling
always index files into a checklist
process one file at a time

1. Use file crawling for 10+ files - Don't try to hold all in context
2. Process one file at a time - No shortcuts, no batching
3. Read complete files - No skimming before changes
4. Mark complete honestly - Only after full individual review
5. Show progress periodically - Keep human informed

## Ruthless Simplicity

- Start minimal, grow as needed
- Avoid future-proofing
- Question every abstraction
- Clear over clever

## Occam's Razor thinking

The solution should be as simple as possible, but no simpler.

## Now vs Future

The code handles what's needed now rather than anticipating every possible future scenario.

## Modularization

- Self-contained modules
- Clear interfaces (studs)
  Complex systems work best when built from simple, well-defined components that do one thing well.
