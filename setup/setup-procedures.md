# Setup: Procedures

Procedures are reusable prompts that read IDD artifacts (Intent + Blueprint) and write durable updates back before a conversation is discarded.

## Use a local `.procedures/` folder

Keep a local copy of the procedures you use in a `.procedures/` directory at the repo root.

## Keep it out of git

Add `.procedures/` to the target repo’s `.gitignore` so procedure libraries and local edits aren’t committed to the target repo.

## Get procedures from `library/`

The `library/` folder in this repo is a procedure library with procedures, shared guidelines, and usage docs.
Developers can also use one or more additional procedure libraries (public or internal) and install procedures from any of them into `.procedures/` for their agent/tooling to use.

## Keep runs reproducible

Because `.procedures/` is not committed, record the procedure(s) used (and, when relevant, the library version/commit) in the Step’s “Procedure Log” so others can rerun the same workflow.
