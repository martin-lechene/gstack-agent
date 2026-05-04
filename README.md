# gstack-agent

Product-ready GitAgent adapter repository for multi-target AI workflows.

- CLI-first install and initialization experience
- Branch-aware adaptation for multiple runtime targets
- Built-in validation for branch artifacts and release discipline
- Version-controlled release workflow with `VERSION` and `CHANGELOG.md`
- GitHub-native templates and CI validation for real development use

**Current version:** 1.0.0

## Overview

gstack-agent is an adapter repository for AI workflows that target different runtime environments from a shared source base. The repository is structured to:

- keep `main` as the canonical development and release branch
- support focused runtime branches for Claude, Cursor, OpenCode, Codex, Antigravity, VS Code, Copilot, and PhpStorm
- provide install helpers for cross-platform onboarding
- validate expected branch artifacts automatically during development
- preserve a clean git workflow through branch validation and release guidance

## Quick start

Clone the repository and enter the project directory:

```bash
git clone https://github.com/shreyas-lyzr/gstack-agent.git
cd gstack-agent
```

Run the install helper for your platform:

```bash
./install.sh
```

```powershell
.\build.bat
```

Use the helper with `--help` to see available options and runtime detection behavior:

```bash
./install.sh --help
```

```powershell
.\build.bat --help
```

## Branch development model

This repository relies on one canonical branch plus runtime-specific adaptation branches.

| Branch | Target | Core artifacts | Purpose |
|---|---|---|---|
| `main` | Product-ready source | `README.md`, `VERSION`, `CHANGELOG.md`, `.github/`, `scripts/validate_branches.py` | Canonical development and release branch |
| `claude` | Claude Code | `agent.yaml`, `SOUL.md`, `RULES.md`, `skills/` | Default GitAgent/Claude runtime adaptation |
| `cursor` | Cursor IDE | `.cursor/rules/*.mdc`, `skills/` | Cursor rule export and runtime target |
| `opencode` | OpenCode | `AGENTS.md`, `opencode.json` | OpenCode runtime adapter |
| `codex` | OpenAI Codex | `CODEX.md`, `codex.json` | Codex runtime adapter |
| `antigravity` | Antigravity | `ANTIGRAVITY.md`, `antigravity.json` | Antigravity runtime adapter |
| `vscode` | VS Code AI | `.vscode/agent.json`, `VSCODE.md` | VS Code AI runtime adapter |
| `copilot` | GitHub Copilot | `copilot.json`, `COPILOT.md` | GitHub Copilot runtime adapter |
| `phpstorm` | PhpStorm Junie | `.phpstorm/junie.json`, `PHPSTORM.md` | PhpStorm runtime adapter |

### Branch workflow

1. Develop new features on `main` and keep `main` stable.
2. Use dedicated runtime branches for adapter-specific artifacts.
3. Sync runtime branches with `main` regularly so shared source content remains aligned.
4. Use `scripts/validate_branches.py` before pushing or opening pull requests.

## Validation and regression testing

The repository includes branch-aware validation tooling to ensure each target branch contains the proper files and metadata.

Run validation locally:

```bash
python scripts/validate_branches.py
```

This script will:

- verify the working tree is clean
- fetch origin branch refs
- check out each available branch
- ensure required runtime branch files exist
- validate shell script syntax for `install.sh`
- validate Python syntax for `scripts/validate_branches.py`

### GitHub Actions

Validation is also wired into CI via `.github/workflows/validate.yml`.

Keep branch artifacts aligned with workflow expectations and update this README if branch requirements change.

## Install helper UX

The install helpers are designed to be ergonomic and safe:

- detect existing adapter files
- recommend the best runtime target automatically
- prompt before creating or overwriting anything
- preserve existing configuration when possible
- support both interactive and CLI-driven invocation

## Versioning and release

This repository uses simple semantic versioning managed by the `VERSION` file.

To release a new version:

1. Update `VERSION`
2. Add release notes to `CHANGELOG.md`
3. Verify all branches and validate the repo
4. Push `main` and open release PRs as needed

## Contribution workflow

Use the repository templates for issues and pull requests:

- `.github/ISSUE_TEMPLATE/bug_report.md`
- `.github/ISSUE_TEMPLATE/feature_request.md`
- `.github/PULL_REQUEST_TEMPLATE.md`

Read `CONTRIBUTING.md` for detailed contribution guidance, branch policies, and issue handling.

## Repository structure

- `agent.yaml` — shared GitAgent adapter configuration
- `CHANGELOG.md` — release notes and change history
- `CONTRIBUTING.md` — contributor guidelines and workflows
- `install.bat` / `install.sh` — install and initialization helpers
- `knowledge/` — project knowledge and workflow documentation
- `README.md` — this repository overview and development guide
- `RULES.md`, `SOUL.md` — shared agent rules and intent guidance
- `scripts/validate_branches.py` — branch artifact validation and regression checks
- `skills/` — workflow skill definitions for planning, review, shipping, and retrospectives
- `.github/` — GitHub templates and CI workflows
- `VERSION` — current semantic release version

## Remote branch guidance

The validation script uses `origin` by default to verify remote branch refs. Confirm your Git remotes with:

```bash
git remote -v
```

If you have multiple remotes, ensure `origin` points to your primary repository before pushing changes.

## Built with

[gitagent](https://github.com/open-gitagent/gitagent) — a git-native, framework-agnostic open standard for AI agents.
