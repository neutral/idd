# Claim Type

Claim type name: `boundary-compliance`
Summary: preserve whether the Arc and its steps stayed inside approved scope,
permissions, and explicit out-of-scope handling.
Why this claim matters: technically correct work is still untrustworthy if it
crossed the wrong boundary.
Primary trust question: did the Arc respect scope, permissions, and explicit
out-of-scope handling?
Default evidence kind: Arc boundary proof thread

## Use This Claim When

- the Arc computes effective scope from `.methodologies/idd/status.md`
- a step discovers adjacent work that must stay untouched
- the Arc stops, narrows, or defers because of boundary restrictions

## Claim Sentence Template

- `<Arc or scoped work>` stayed within `<operating scope and permission
  posture>`, touched `<paths or artifacts>`, and handled `<out-of-scope issue>`
  by `<defer, stop, or escalate>`.

## Required Inputs

- `.methodologies/idd/status.md`
- `arc.md`
- relevant step files and touched paths

## Update These Artifacts When

- the Arc evidence index needs current boundary coverage
- a step summary should reference the boundary evidence it relied on
- the Arc plan narrows or splits because of boundary limits

## Related Claim Types

- `intent-target`
- `authority-basis`
- `verification-posture`
