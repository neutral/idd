# Step Expansion Template

## Scope

- `<Scope of the step>`

## Source to Add or Modify

- `<File path>`: `<purpose>`

## Description Files

- Create:
  - `<path>`: `<purpose>` (Refs: `<ids>`)
- Update:
  - `<path>`: `<purpose>` (Refs: `<ids>`)

## Intent Updates

- `<intent file path>`: `<fields to add or update>`

## Blueprint Updates

- `<blueprint file path>`: `<changes to make>`
- `<ADR path>`: `<status and consequence>`
- `<user flow path>`: `<updates>`

## Request and Response Shape (if applicable)

- `<field>`: `<type>` - `<notes>`

## Algorithm

- `<validation and processing steps>`

## Database Interactions (if applicable)

- `<query or update>`: `<tables, columns, conditions>`

## Policies and Limits

- `<policy or limit>`: `<how to verify>`

## Sequencing

- `<dependencies or workarounds>`

## Tests

- Happy path:
  - `<test path>`: `<case>`
- Negative cases:
  - `<test path>`: `<case>`
- Invariants:
  - `<assertions>`
- Commands:
  - `<command>`

## Verification

- Unit checks:
  - `<command>`
- Manual checks:
  - `<command>`
- User verification commands:

  ```bash
  <copy/paste commands>
  ```

- Fix-forward loop:
  - Re-run tests until all pass.

## Checks

- `<check>`

## Notes

- `<notes>`

## Refs

- Goals:
- Behaviors:
- Assurances:
- Blueprint:
- Decisions:

## Example (Optional)

Step: 1 - Initialize repo

- Context: scaffold structure and meta files to unblock builds and docs.
- Structure: verify `server/`, `web/`, `intents/` exist; root `.gitignore` present.
- Source to add: `.editorconfig` (UTF-8, LF, trim, final newline; 2 spaces for TS/MD/JSON; tabs for Go).
- Description files to add: `server/server.desc.md` (Refs: R-PLAT-2,R-PLAT-3,R-SEC-UV); `web/web.desc.md` (Refs: R-PLAT-1,R-UI-2BTN).
- Intent updates: none in this step; future steps will add behaviors and assurances when interfaces or policies change.
- Blueprint updates: none in this step; add Refs under step; do not mark other steps in progress.
- Verification: `git status` shows only the three new files; `test -f .editorconfig`; `ls server server/internal web/src intents` exit 0.
- Notes: no code changes in this pass; actual file creation occurs during implementation.
