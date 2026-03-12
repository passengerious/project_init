# System Patterns & Persistence
## Architecture Rules
- [Rule 1: e.g., Logic stays in services]
## Workflow Rules
- **Boot Protocol**: Read `ADR.md`, `.agents/PROTOCOL.md`, shared memory files, and the latest 2 logs from `logs/`.
- **State Persistence**: Update `activeContext.md` at start and after major direction changes; update `progress.md` and the current log on completion.
- **Logging**: Use `logs/YYYY-MM-DD_short-task-slug.md`.

## Write Policy (Deterministic Targets)
1. **Context Initialization**: Update `activeContext.md` with the current objective, constraints, and plan.
2. **Session Persistence**: Record milestone updates and major decisions in the current file under `logs/`.
3. **Clean Handoff**: Update `progress.md`, link the session log in `Milestones`, and mark the task log status.
