# Intent-Driven Development (IDD)

IDD is a methodology for agent-assisted software development that keeps user
intent, implementation contracts, and code aligned as work changes.

## Start Here

- Read [methodology/IDD.md](methodology/IDD.md) for the IDD model, boundaries,
  and companion documents.
- Use [methodology/ARC.md](methodology/ARC.md) as the runtime entrypoint when
  executing or resuming an IDD run.
- Use [setup/idd-setup.md](setup/idd-setup.md) to install IDD into a target
  repo.
- Use [library/overview.md](library/overview.md) when you need local library
  guidance such as pass support or claim support.
- Run `scripts/verify-idd.sh` from this source repo to verify the source
  package or an installed target repo.

## What IDD Optimizes

- Durable product context in Intent and Blueprint artifacts instead of
  chat-only context.
- Explicit contracts that tell agents what must be true before code is
  generated or changed.
- Bounded runtime execution through Arc so a run can be resumed, reviewed, and
  audited without guessing.

## Repository Surfaces

- `methodology/`: the core IDD contract set, including `IDD.md`, `ARC.md`,
  `ARTIFACTS.md`, `LIBRARY.md`, `LABELS.md`, Arc contracts, templates, and
  artifact guidance.
- `library/`: the starter runtime library entrypoint plus the IDD pass catalog
  for authoring quality across the Intent pipeline and the claim catalog for
  Arc-scoped evidence, including `pass-effect`.
- `setup/`: installation and bootstrap guidance for target repos.
- `scripts/`: helper scripts for install and verification.

## Open Source Use

IDD helps open-source repos publish durable product intent alongside code.
That makes it easier for contributors and downstream users to understand what
the system is supposed to do, change behavior safely, and participate without
reverse-engineering the implementation first.

## Contributing

Please see our [Contributing Guide](CONTRIBUTING.md) for details.

Run `scripts/verify-idd.sh` and
`npx --yes markdownlint-cli --disable MD013 -- "**/*.md"` before opening a
pull request.

Source code files should include `SPDX-License-Identifier: (CC0-1.0 OR 0BSD)`
where applicable.

## License

This project is released under a dual-license model. Choose either:

- **[CC0-1.0](LICENSE.CC0-1.0)** - Creative Commons Zero v1.0 Universal
- **[0BSD](LICENSE.0BSD)** - Zero-Clause BSD

This applies to all project materials.
