# Coding Style

## Markdown Conventions

- Title: every `.md` file starts with a single H1 (`# Title`) that clearly names the document.
- Headings: use a consistent hierarchy (H1 once; H2 for main sections; H3 for subsections). Do not skip levels.
- Code blocks: use fenced code blocks with language hints for clarity and syntax highlighting (e.g., `bash`, `json`, `go`, `ts`, `sql`, `cddl`). Prefer blocks over inline for multi-line commands or code.
- Inline code: wrap commands, file paths, env vars, constants, and identifiers in backticks.
- Lists: use bullets for concise, scannable items; keep each bullet verifiable and single-purpose.
- Consistency: prefer present tense, active voice; avoid fluff; keep sections short and self-contained.

## fmt and lint at every step

- Always run fmt after generating code
- Always run lint before completing the implementation step
