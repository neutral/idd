# Using Procedures

Procedures are reusable prompts. Agents run procedures to read IDD artifacts as inputs and write durable updates back as outputs.
The goal is to avoid freeform chat: agents run procedures using context from Intent and Blueprint files and, at the end of a run, write back what matters into those artifacts (with Code as the implementation output).

## Procedure libraries

The `library/` folder in this repo is one procedure library.
Developers can also use one or more additional procedure libraries (public or internal) to match internal standards, tools, or review workflows.

## Procedures folder in a repo

When working in a repo, use `.methodologies/idd/library/procedures/` as the procedures folder.
Keep all procedures for runs in this folder, including imported procedures from additional libraries.

## Keeping work reproducible

Because this folder can include local edits and mixed sources, record the procedure(s) used (and, when relevant, source path/library version/commit) in the Step’s “Procedure Log” so other developers can rerun the same workflow.
