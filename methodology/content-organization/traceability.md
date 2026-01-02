# Traceability

Each file has a unique semantic slug that reflects its hierarchy. Trace links run Intent ↔ Blueprint ↔ Code/description files so sources of truth stay connected to the implementation output.

- Intent artifacts link upward (scenario → feature → system) and outward to Blueprint files they rely on.
- Blueprint files link back to the Intent behaviors/assurances they satisfy and to Decisions/Arc where rationale lives.
- Description files sit beside code and reference the relevant IDs, forming the final bridge to the implementation.

Use backlinks and Refs lines to maintain bidirectional navigation. Use global search to discover inbound links.
