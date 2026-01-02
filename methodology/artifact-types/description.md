# Description Files

Description files live beside source files in the Code layer. They link generated code back to the Intent obligations and Blueprint contracts it implements.

- Naming: prefix with `_` to keep them grouped. Mirror the source filename (including extension) and append `.desc.md` (example: `crypto.go` → `_crypto.go.desc.md`).
- Scope: one description file per source file.
- Purpose: bridge Intent/Blueprint context to the code; not a substitute for code comments.

Template:

## Title

Usually the source file name.

## Purpose

High-level purpose of the source file in the system.

## Key Logic

## Relations

## Interfaces and Models
