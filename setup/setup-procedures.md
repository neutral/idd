# Setup: Procedures

Procedures are reusable prompts that read IDD artifacts (Intent + Blueprint) and write durable updates back before a conversation is discarded.

## Use a local `.procedures/` folder

Keep a local copy of the procedures and packs you use in a `.procedures/` directory at the repo root.

## Keep it out of git

Add `.procedures/` to the target repo’s `.gitignore` so procedure libraries and local edits aren’t committed to the target repo.

## Get a starter library

The `idd-procedures` repo is a public library of procedures.
Developers can also use one or more additional procedure libraries (public or internal) and install procedures from any of them into `.procedures/` for their agent/tooling to use.
Use packs to discover procedures within each library.

## Keep runs reproducible

Because `.procedures/` is not committed, record the procedure(s) used (and, when relevant, the library version/commit) in the Step’s “Procedure Log” so others can rerun the same workflow.
