# gstack-agent

Product-ready GitAgent adapter repository for multi-target AI workflows.

- CLI-first install/config UX
- Branch-aware adaptation for Claude, Cursor, and OpenCode
- Regression validation for all target branches
- Versioning system with tags and release guidance
- GitHub issue and PR templates for a real product workflow

**Current version:** 1.0.0

## What this repository delivers

gstack-agent is designed to be used as a production-ready AI agent repository. It is structured around:

- opinionated workflow skills for planning, review, shipping, QA, and retrospectives
- stable branch targets for specific runtime environments
- lightweight cross-platform initialization and install helpers
- robust validation tooling to prevent regressions

## Quick start

Clone and enter the repository:



Then initialize the repository for your environment:

Linux/macOS:



Windows:



Use --help for a quick overview:



## Branch adaptation matrix

| Branch | Target | Core artifacts | Use case |
|---|---|---|---|
| main | Product-ready source | README.md, VERSION, CHANGELOG.md, .github/, scripts/validate_branches.py | Canonical development and release branch |
| claude | Claude Code | agent.yaml, SOUL.md, RULES.md, skills/ | Default GitAgent/Claude runtime |
| cursor | Cursor IDE | .cursor/rules/*.mdc, skills/ | Cursor rule export adapted from the same agent source |
| opencode | OpenCode | AGENTS.md, opencode.json | OpenCode runtime configuration and instructions |
| codex | OpenAI Codex | CODEX.md, codex.json | OpenAI Codex runtime adapter |
| antigravity | Antigravity | ANTIGRAVITY.md, antigravity.json | Antigravity runtime adapter |
| vscode | VS Code AI | .vscode/agent.json, VSCODE.md | VS Code AI runtime adapter |
| copilot | GitHub Copilot | copilot.json, COPILOT.md | GitHub Copilot runtime adapter |
| phpstorm | PhpStorm Junie | .phpstorm/junie.json, PHPSTORM.md | PhpStorm Junie runtime adapter |

> Use git checkout <branch> to select the runtime target and validate the branch with python scripts/validate_branches.py.

## Install helper UX

The install helpers are intentionally ergonomic:

- detect existing adapter files
- recommend the best target automatically
- prompt before creating anything
- never overwrite existing configuration
- support both interactive and CLI-driven invocation

Supported commands:



## Validation and regression testing

This repository includes a branch-aware validation workflow:

- scripts/validate_branches.py checks every adaptation branch for the expected runtime artifacts
- GitHub Actions runs on push and pull request events
- VERSION and CHANGELOG.md are used for version discipline

Run validation locally:



## Versioning and release

This project uses semantic versioning via the VERSION file.

To release a new version:



Keep CHANGELOG.md updated with release notes.

## Contribution workflow

Use the provided GitHub templates:

- .github/ISSUE_TEMPLATE/bug_report.md
- .github/ISSUE_TEMPLATE/feature_request.md
- .github/PULL_REQUEST_TEMPLATE.md

See CONTRIBUTING.md for development and issue workflows.

## Repository structure



## Branch adaptation matrix

| Branch | Target | Core artifacts | Use case |
|---|---|---|---|
| `claude` | Claude Code | `agent.yaml`, `SOUL.md`, `RULES.md`, `skills/` | Default Open-GitAgent/Claude workflow |
| `cursor` | Cursor IDE | `.cursor/rules/*.mdc`, `skills/` | Cursor rule export adapted from the same agent source |
| `opencode` | OpenCode | `AGENTS.md`, `opencode.json` | OpenCode agent configuration and instructions |

> This branch is the Cursor adaptation branch. It includes Cursor rule files under `.cursor/rules/` and is intended to run via Cursor-compatible adapter tooling.

## Built with

[gitagent](https://github.com/open-gitagent/gitagent) — a git-native, framework-agnostic open standard for AI agents.
