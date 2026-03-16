# Evidence Capture

Capture this claim type in the shared Arc evidence shape: claim, context or
method, observations and raw artifacts, and verdict.

## Claim

- state the checks or review methods that ran
- record the observed results
- record blind spots, skipped checks, or blocked verification

## Methodology References

- record the claim type folder path
- link `arc.md`, relevant step refs, and the evidence index
- link commands, reports, screenshots, or review notes when they matter

## Method Or Context

- explain how the verification bar was selected
- record whether verification was automated, manual, or review-based
- note when verification was intentionally partial

## Observations

- record each meaningful check and its result
- record failures, skips, or flaky outcomes
- record which important surfaces remain unverified

## Raw Artifacts

- command output or test reports
- review notes or screenshots
- changed code, tests, and description files tied to the checks

## Verdict Guidance

- `supported`: meaningful checks support the current Arc outcome
- `mixed`: some checks support it, but important gaps or failures remain
- `open`: verification is still in progress or waiting on prerequisites
- `incomplete`: the thread exists but not enough checking is recorded yet
- `failed`: required checks failed or were omitted in a way that blocks trust

## Evidence Thread Rules

- create a new item when a distinct verification target needs independent proof
- enrich the existing item when more checks run against the same target
- do not mix verification posture with overall outcome or ownership posture

## Closeout Conditions

- meaningful checks and blind spots are explicit
- the verdict reflects the best available support at Arc closeout
- final validation can cite this thread directly
