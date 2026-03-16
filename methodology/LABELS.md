# IDD Labels

This file defines semantic labeling behavior for IDD.

## Use This File When

- deciding whether an artifact may introduce semantic labels
- distinguishing structural fields from labels
- proposing a future label extension to IDD

## Labeling Mode

IDD is in explicit no-label mode. Agents and developers should not invent a
semantic label taxonomy during normal IDD runs.

## Structural Elements That Are Not Labels

Headings, metadata fields, section names, IDs, `Refs` lines, and template
fields are structural parts of IDD artifacts. They are not semantic labels.

## Extension Rule

If IDD later adopts labels, they must be added through the methodology
contract surface. Labels are not part of the current runtime model.
