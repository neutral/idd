# Using Procedures

Procedures are reusable prompts. Agents run procedures to read IDD artifacts as inputs and write durable updates back as outputs.
The goal is to avoid freeform chat: agents run procedures using context from Intent and Blueprint files and, at the end of a run, write back what matters into those artifacts (with Code as the implementation output).

## Procedure libraries and packs

The public `idd-procedures` repo is one procedure library.
Developers can also use one or more additional procedure libraries (public or internal) and their packs (for example, to match internal standards, tools, or review workflows).

## Local procedures in a repo

When working in a repo, keep a local copy of the procedures you use in a `.procedures/` directory at the repo root.
Use this folder to store pulled libraries (and any local changes) without adding procedure code to the project history.

- Add `.procedures/` to the target repo’s `.gitignore` so it is not committed.

## Keeping work reproducible

Because `.procedures/` is not committed, record the procedure(s) used (and, when relevant, the library version/commit) in the Step’s “Procedure Log” so other developers can rerun the same workflow.
