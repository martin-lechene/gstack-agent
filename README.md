# gstack-agent

Six opinionated workflow skills that turn your AI coding assistant into a team of specialists — CEO/founder for product thinking, eng manager for architecture, staff engineer for review, release engineer for shipping, QA engineer for browser testing, and engineering manager for retrospectives. Based on [Garry Tan's gstack](https://github.com/garrytan/gstack).

## Run

```bash
npx @open-gitagent/gitagent run -r https://github.com/shreyas-lyzr/gstack-agent
```

## What It Can Do

- **/plan-ceo-review** — Founder/CEO mode: rethink the problem, find the 10-star product, challenge premises
- **/plan-eng-review** — Eng manager mode: lock in architecture, data flow, diagrams, edge cases, tests
- **/review** — Paranoid staff engineer mode: find bugs that pass CI but break in production
- **/ship** — Release engineer mode: sync main, run tests, bump version, push, open PR — fully automated
- **/browse** — QA engineer mode: headless Chromium browser for visual QA, form filling, screenshots
- **/retro** — Engineering manager mode: weekly retrospective with commit analysis, velocity metrics, trends

## Structure

```
gstack-agent/
├── agent.yaml
├── SOUL.md
├── RULES.md
├── README.md
├── skills/
│   ├── plan-ceo-review/
│   │   └── SKILL.md
│   ├── plan-eng-review/
│   │   └── SKILL.md
│   ├── review/
│   │   ├── SKILL.md
│   │   └── checklist.md
│   ├── ship/
│   │   └── SKILL.md
│   ├── browse/
│   │   └── SKILL.md
│   └── retro/
│       └── SKILL.md
└── knowledge/
    ├── index.yaml
    └── workflow-guide.md
```

## Branch adaptation matrix

| Branch | Target | Core artifacts | Use case |
|---|---|---|---|
| `claude` | Claude Code | `agent.yaml`, `SOUL.md`, `RULES.md`, `skills/` | Default Open-GitAgent/Claude workflow |
| `cursor` | Cursor IDE | `.cursor/rules/*.mdc`, `skills/` | Cursor rule export adapted from the same agent source |
| `opencode` | OpenCode | `AGENTS.md`, `opencode.json` | OpenCode agent configuration and instructions |
| `codex` | OpenAI Codex / Copilot | `agent.yaml`, `skills/`, runtime-specific helpers | Codex runtime adaptation branch |
| `antigravity` | Antigravity | `agent.yaml`, `skills/`, runtime-specific helpers | Antigravity runtime adaptation branch |
| `vscode` | VS Code AI | `.vscode/*`, `skills/`, runtime-specific helpers | VS Code AI runtime adaptation branch |
| `copilot` | GitHub Copilot | `agent.yaml`, `skills/`, runtime-specific helpers | Copilot runtime adaptation branch |
| `phpstorm` | PhpStorm / Junie | `.phpstorm/*`, `skills/`, runtime-specific helpers | PhpStorm Junie runtime adaptation branch |

> Use `git checkout <branch>` to pick the adaptation target, then follow the branch-specific README and artifacts for Cursor, OpenCode, or other runtime-specific execution.

## Install helper

This repository includes simple install helpers in `main`:

- `./install.sh` for Linux/macOS
- `install.bat` for Windows

These scripts detect existing setup files and recommend the best target. They only create missing support files and do not overwrite existing user configuration.

Example usage:

```bash
bash install.sh
```

On Windows:

```bat
install.bat
```

## Built with

[gitagent](https://github.com/open-gitagent/gitagent) — a git-native, framework-agnostic open standard for AI agents.
