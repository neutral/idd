# Intent-Driven Development (IDD)

Intent-Driven Development (IDD) is a software development methodology designed to accelerate delivery with agentic coding tools. It does this by explicitly capturing Intent (what the user needs) and using that Intent to generate Code that matches it—reliably and within organizational constraints.

IDD improves speed and correctness by front-loading the work that typically causes churn in AI-assisted development: missing context, unclear requirements, inconsistent assumptions, and ambiguous acceptance criteria. When Intent and implementation constraints are captured cleanly, teams spend less time reviewing and rewriting generated output—and more time shipping.

IDD organizes context so both developers and agents can prompt effectively, operate predictably, and produce software that can also be rapidly updated later with new requirements. It also maximizes correctness within today’s limited context sizes and reasoning windows by creating and maintaining a small set of high-signal artifacts that can be fed into agentic coding tools.

At its core, IDD is a deliberate information-gathering and codification practice that keeps pace with shifting user needs. Intent files and Blueprint files are the sources of truth; code is the implementation output.

Arc provides the operating loop for sizing, sequencing, and executing work at a predictable cadence across humans and agents.

## This Repo

- The `methodology/` folder contains templates and guidance for IDD artifacts and organization.
- The `setup/` folder contains guides for setting up IDD (Intent + Blueprint) in a target repo.

## Open Source

IDD can further democratize open-source software. When an open-source repository includes well-defined Intent files and Blueprint files, contributors and downstream users can:

- Understand “what the software is supposed to do” without reverse-engineering code
- Customize behavior safely by changing Intent/Blueprint and regenerating the implementation
- Participate meaningfully even if they are unfamiliar with the codebase internals

In other words: clear Intent + Blueprint artifacts make customization and contribution substantially more accessible.

## 🤝 Contributing

Please see our [Contributing Guide](CONTRIBUTING.md) for details.

Source code files should include `SPDX-License-Identifier: (CC0-1.0 OR 0BSD)` where applicable.

## License

This project is released under a dual-license model. Choose either:

- **[CC0-1.0](LICENSE.CC0-1.0)** - Creative Commons Zero v1.0 Universal
- **[0BSD](LICENSE.0BSD)** - Zero-Clause BSD

This applies to all project materials.
