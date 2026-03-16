# Finalize Arc

Use this phase to synthesize completed step proof against the Arc completion
rule and record the final Arc outcome.

## Use This Phase When

- every step in the `Step Register` is `complete`
- `Arc Status` is `finalizing`, or the final step has just completed
- final proof synthesis and closeout are the only Arc-level work remaining

## Required Inputs

- `.methodologies/idd/scratch/arc/arc.md`
- every completed step file in `.methodologies/idd/scratch/arc/`
- the Arc evidence run
- the Arc `Completion Rule`

## Required Updates

- update `Final Validation`
- synthesize the Arc evidence run and completed step proof against the Arc
  `Completion Rule`
- update `Closeout`
- set `Arc Status` to `complete` only when final proof passes

## Outcomes

- if final proof finds more work, add new `planned` steps immediately, create
  the new active step file immediately, update the `Step Register`, set
  `Arc Status` to `planning`, and leave `Closeout` open
- if final proof passes, record `Arc outcome: complete` and set `Arc Status` to
  `complete`

## Recording Rules

- record the final Arc outcome in `arc.md` `Closeout`
- add a final note in `arc.md` `Notes` when a short Arc-level closeout trail is
  useful beyond the structured fields

## Exit Conditions

- `Arc Status` is `planning` or `complete`
- `Final Validation` and `Closeout` match the current Arc posture
