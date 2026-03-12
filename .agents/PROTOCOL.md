# Agent Persistence Protocol

## Boot Sequence

The absolute first action on initialization is to restore project context by reading:

1. `ADR.md`
2. `AGENTS.md`
3. `.agents/memory-bank/product.md`
4. `.agents/memory-bank/systemPatterns.md`
5. `.agents/memory-bank/activeContext.md`
6. `.agents/memory-bank/progress.md`
7. The latest 2 task logs from `.agents/memory-bank/logs/`

## Runtime Rules

- use `.agents/memory-bank/` as the canonical persistence store
- use `.agents/skills/` for global bundles
- use `.agents/skills/project/` for project-specific bundle overlays when present

## Shutdown Sequence

Before completion or handoff:

1. update the active session log
2. update `progress.md`
3. refresh `activeContext.md` to reflect the next live concern
