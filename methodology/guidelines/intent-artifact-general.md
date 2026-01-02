# Intent Artifact Hygiene

- Treat Intent artifacts as the evaluation surface: they define what must be true and what Code will be judged against.
- Prefer one intent artifact per concern (feature, scenario, behavior, assurance) to maintain clarity. For smaller scopes, it is fine to keep multiple behaviors inline inside a single `scenario.md` and split them into separate behavior files only when it improves readability, review, reuse, or parallel work.
- Keep Intent implementation-agnostic; reserve contracts and specifications for Blueprint files.
- Link to external content where necessary; do not embed full external specs in intent files.
