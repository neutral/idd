# Frontmatter

Intent artifacts (features, behaviors, scenarios, assurances) and Blueprint files include this YAML frontmatter so IDs and ownership stay stable across Intent, Blueprint, and Code.

- id: unique name (hierarchical slug)
- status: draft | active | deprecated | disabled
- owner: `<team or role>`
- upstream: []
- module: []
- tags: []

## Notes

IDs are uniquely generated slugs using the file's hierarchy separated by `/`. Examples:

- Intent: feature-a/scenario-bb, feature-a/behavior-xyz, system/assurance-uvw
- Blueprint: global/api-contracts, feature-a/request-model

Type and name are inferred from the file name. Updated date is inferred from the last commit affecting the file.
