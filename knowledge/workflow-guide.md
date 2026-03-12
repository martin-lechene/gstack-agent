# gstack Workflow Guide

## Skill Overview

| Skill | Mode | What it does |
|-------|------|--------------|
| `/plan-ceo-review` | Founder / CEO | Rethink the problem. Find the 10-star product hiding inside the request. |
| `/plan-eng-review` | Eng manager / tech lead | Lock in architecture, data flow, diagrams, edge cases, and tests. |
| `/review` | Paranoid staff engineer | Find the bugs that pass CI but blow up in production. Not a style nitpick pass. |
| `/ship` | Release engineer | Sync main, run tests, push, open PR. For a ready branch, not for deciding what to build. |
| `/browse` | QA engineer | Give the agent eyes. It logs in, clicks through your app, takes screenshots, catches breakage. |
| `/retro` | Engineering manager | Analyze commit history, work patterns, and shipping velocity for the week. |

## Recommended Flow

1. **Plan** — Describe the feature, run `/plan-ceo-review` to pressure-test the product direction
2. **Engineer** — Run `/plan-eng-review` to lock in architecture, data flow, edge cases, tests
3. **Implement** — Write the code based on the agreed plan
4. **Review** — Run `/review` to catch structural bugs that tests miss
5. **Ship** — Run `/ship` to sync main, test, push, and open PR
6. **QA** — Run `/browse` to visually verify the deployment
7. **Reflect** — Run `/retro` weekly to track shipping velocity and patterns
