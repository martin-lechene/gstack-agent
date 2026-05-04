# gstack-agent

Product-ready GitAgent adapter repository for multi-target AI workflows.

- CLI-first install/config UX
- Branch-aware adaptation for Claude, Cursor, and OpenCode
- Regression validation for all target branches
- Versioning system with tags and release guidance
- GitHub issue and PR templates for a real product workflow

**Current version:** `1.0.0`

## What this repository delivers

`gstack-agent` is designed to be used as a production-ready AI agent repository. It is structured around:

- opinionated workflow skills for planning, review, shipping, QA, and retrospectives
- stable branch targets for specific runtime environments
- lightweight cross-platform initialization and install helpers
- robust validation tooling to prevent regressions

## Quick start

Clone and enter the repository:

```bash
git clone https://github.com/martin-lechene/gstack-agent.git
cd gstack-agent
```

Then initialize the repository for your environment:

Linux/macOS:

```bash
bash install.sh
```

Windows:

```bat
install.bat
```

Use `--help` for a quick overview:

```bash
bash install.sh --help
```

## Branch adaptation matrix

| Branch | Target | Core artifacts | Use case |
|---|---|---|---|
| `main` | Product-ready source | `README.md`, `VERSION`, `CHANGELOG.md`, `.github/`, `scripts/validate_branches.py` | Canonical development and release branch |
| `claude` | Claude Code | `agent.yaml`, `SOUL.md`, `RULES.md`, `skills/` | Default GitAgent/Claude runtime |
| `cursor` | Cursor IDE | `.cursor/rules/*.mdc`, `skills/` | Cursor rule export adapted from the same agent source |
| `opencode` | OpenCode | `AGENTS.md`, `opencode.json` | OpenCode runtime configuration and instructions |

> Use `git checkout <branch>` to select the runtime target and validate the branch with `python scripts/validate_branches.py`.

## Install helper UX

The install helpers are intentionally ergonomic:

- detect existing adapter files
- recommend the best target automatically
- prompt before creating anything
- never overwrite existing configuration
- support both interactive and CLI-driven invocation

Supported commands:

```bash
bash install.sh [--target cursor|opencode|claude]
install.bat [cursor|opencode|claude]
```

## Validation and regression testing

This repository includes a branch-aware validation workflow:

- `scripts/validate_branches.py` checks every adaptation branch for the expected runtime artifacts
- GitHub Actions runs on push and pull request events
- `VERSION` and `CHANGELOG.md` are used for version discipline

Run validation locally:

```bash
python scripts/validate_branches.py
```

## Versioning and release

This project uses semantic versioning via the `VERSION` file.

To release a new version:

```bash
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin --tags
```

Keep `CHANGELOG.md` updated with release notes.

## Contribution workflow

Use the provided GitHub templates:

- `.github/ISSUE_TEMPLATE/bug_report.md`
- `.github/ISSUE_TEMPLATE/feature_request.md`
- `.github/PULL_REQUEST_TEMPLATE.md`

See `CONTRIBUTING.md` for development and issue workflows.

## Repository structure

```
gstack-agent/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md
│   │   └── feature_request.md
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── workflows/
│       └── validate.yml
├── agent.yaml
├── CHANGELOG.md
├── CONTRIBUTING.md
├── README.md
├── VERSION
├── scripts/
│   └── validate_branches.py
├── install.sh
├── install.bat
├── skills/
└── knowledge/
```

## Built with

[gitagent](https://github.com/open-gitagent/gitagent) — a git-native, framework-agnostic open standard for AI agents.
