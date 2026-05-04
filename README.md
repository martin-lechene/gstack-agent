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

> This branch is the OpenCode adaptation branch. It includes `AGENTS.md` and `opencode.json` and is intended for OpenCode-compatible execution.

## How to use each branch

1. `git checkout claude`
   - `npx @open-gitagent/gitagent run .`
   - Uses the existing Claude-first manifest in `agent.yaml`
2. `git checkout cursor`
   - `git diff --name-only` to review `.cursor/rules/`
   - `gitagent run --adapter cursor .` or use `gitagent export --format cursor` to generate Cursor artifacts
3. `git checkout opencode`
   - `git diff --name-only` to review `AGENTS.md` and `opencode.json`
   - `gitagent run --adapter opencode .` or use `gitagent export --format opencode`

## Built with

[gitagent](https://github.com/open-gitagent/gitagent) — a git-native, framework-agnostic open standard for AI agents.
