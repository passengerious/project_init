# Agent Instructions

## Required Startup Read

On startup, the agent must read:

1. `ADR.md`
2. `.agents/PROTOCOL.md`
3. `.agents/memory-bank/product.md`
4. `.agents/memory-bank/systemPatterns.md`
5. `.agents/memory-bank/activeContext.md`
6. `.agents/memory-bank/progress.md`
7. The latest 2 logs from `.agents/memory-bank/logs/`, if available

## Required Persistence

During work, the agent should treat `.agents/memory-bank/` as the canonical project memory.

At minimum:

- update `activeContext.md` when the current objective or plan changes
- update the current session log for major milestones or decisions
- update `progress.md` before completion or handoff

## Skill Model

- global bundles live under `.agents/skills/`
- project-level bundles may be linked under `.agents/skills/project/`
