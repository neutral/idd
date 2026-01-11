# IDD Artifacts CI/CD

- Validate frontmatter for all Intent and Blueprint files (required fields and valid values).
- Ensure every Behavior includes at least one functional check and links to the Blueprint definitions it depends on.
- Ensure every Assurance links to verification evidence and any Blueprint files (contracts/budgets) it requires.
- Enforce path/layout rules: Intent under `intents/`, definitions under `intents/blueprints/` (or `intents/system/<feature>/blueprints/` / `intents/system/<domain>/<feature>/blueprints/`), decisions under `intents/decisions/` (or feature decision folders), description files adjacent to code.
