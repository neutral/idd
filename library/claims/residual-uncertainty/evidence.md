# Evidence Capture

Capture this claim type in the shared Arc evidence shape: claim, context or
method, observations and raw artifacts, and verdict.

## Claim

- state the concrete uncertainty, skipped check, or deferred work
- record why it still matters
- record what it limits

## Methodology References

- record the claim type folder path
- link `arc.md`, relevant step refs, and the evidence index
- link verification notes, decision refs, or follow-up obligations when needed

## Method Or Context

- explain how the uncertainty was discovered
- record whether it emerged during execution, proof, or final validation

## Observations

- record the concrete unknown or deferred item
- record the current impact on trust
- record the trigger for revisiting it

## Raw Artifacts

- verification outputs
- blocked-check notes
- follow-up decisions or issue refs

## Verdict Guidance

- `supported`: the residual limit is explicit and appropriately bounded
- `mixed`: the uncertainty is explicit but still broad or only partly bounded
- `open`: the uncertainty is still being investigated
- `incomplete`: the thread exists but not enough support is recorded yet
- `failed`: a material uncertainty was hidden or falsely treated as closed

## Evidence Thread Rules

- create a new item when an independent uncertainty needs separate handling
- enrich the existing item when the same uncertainty gains more detail
- do not mix residual uncertainty with final ownership or outcome posture when
  those need their own threads

## Closeout Conditions

- the uncertainty is explicit
- its trust impact is explicit
- a revisit trigger or carry-forward path is preserved
