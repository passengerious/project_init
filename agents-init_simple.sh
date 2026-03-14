#!/bin/bash

# 1. Determine Environment (Hub vs. Spoke)
if git rev-parse --is-inside-work-tree > /dev/null 2>&1 && [ "$(git rev-parse --git-dir)" != ".git" ]; then
    IS_WORKTREE=true
    HUB_PATH=$(dirname "$(git rev-parse --git-dir)")
    echo "🌿 Worktree detected. Operating in Spoke mode. Hub located at: $HUB_PATH"
else
    IS_WORKTREE=false
    echo "🏗️ Main repository detected. Operating in Hub mode."
fi

set -e

PROJECT_NAME=$(basename "$(pwd)")
MEMORY_DIR=".agents/memory-bank"
LOGS_DIR="$MEMORY_DIR/logs"

echo "🚀 Launching Universal Agentic Factory for [$PROJECT_NAME]..."

# Simplified directory structure (Skills managed via npx skills CLI)
mkdir -p .agents/storage
mkdir -p "$LOGS_DIR"

# 2. Helper Functions (Defined before execution)
write_if_missing() {
    local path=$1

    if [ -e "$path" ]; then
        echo "↩️ Preserved existing $path"
        return
    fi

    cat > "$path"
    echo "📝 Created $path"
}

link_to_hub() {
    local file_path=$1
    local target_path="$HUB_PATH/$file_path"
    
    if [ ! -f "$target_path" ]; then
        echo "❌ Error: Cannot link $file_path. It does not exist in the Hub."
        exit 1
    fi

    ln -sfn "$target_path" "$file_path"
    echo "🔗 Symlinked $file_path to Hub"
}

echo "🧠 Injecting Deterministic Persistence Templates..."

# 3. Context Execution Logic (Hub vs. Spoke routing)
if [ "$IS_WORKTREE" = true ]; then
    echo "🔗 Linking Strategic Context to Hub..."
    link_to_hub "ADR.md"
    link_to_hub "AGENTS.md"
    link_to_hub ".agents/PROTOCOL.md"
    link_to_hub "$MEMORY_DIR/product.md"
    link_to_hub "$MEMORY_DIR/systemPatterns.md"
else
    echo "📝 Generating Strategic Templates for Hub..."
    
    write_if_missing "ADR.md" <<EOF
# Architecture Decision Records (ADR)

This document tracks the core architectural choices made during the project lifecycle. 
Both the Architect and autonomous agents must append new decisions here to maintain execution alignment.

## ADR-001: [Baseline Workspace Architecture]
**Date:** $(date +%Y-%m-%d)
**Status:** [Proposed/Accepted]
**Context:** The project requires a decentralized, parallel execution environment and dynamic skill provisioning.
**Decision:** [Agent or Architect to formally record the persistence structure, Git Worktree rules, and \`npx skills\` execution constraints here before feature development begins.]

## ADR-002: [Template - Next Feature Decision]
**Date:** YYYY-MM-DD
**Status:** [Proposed/Accepted/Rejected]
**Context:** [What is the technical challenge or feature requirement?]
**Decision:** [What is the chosen approach and why?]
EOF

    write_if_missing "AGENTS.md" <<'EOF'
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

- Skills are provisioned dynamically via `npx skills` CLI.
EOF

    write_if_missing ".agents/PROTOCOL.md" <<'EOF'
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
- use `npx skills` for capability provisioning

## Shutdown Sequence

Before completion or handoff:

1. update the active session log
2. update `progress.md`
3. refresh `activeContext.md` to reflect the next live concern
EOF

    write_if_missing "$MEMORY_DIR/product.md" <<EOF
# Product Goals: $PROJECT_NAME
- **Vision**: [Agent or Architect to define core purpose]
- **Target Audience**: [Agent to define target users]
- **Core Outcomes**: [Agent to define success metrics]
- **Non-Goals**: [Agent to define out of scope items]
EOF

    write_if_missing "$MEMORY_DIR/systemPatterns.md" <<'EOF'
# System Patterns & Persistence
## Architecture Rules
- [Agent to define structural and architectural rules]
- [Agent to define logic constraints]

## Workflow Rules
- **Boot Protocol**: Read `ADR.md`, `.agents/PROTOCOL.md`, shared memory files, and the latest 2 logs from `logs/`.
- **State Persistence**: Update `activeContext.md` at start and after major direction changes; update `progress.md` and the current log on completion.
- **Logging**: Use `logs/YYYY-MM-DD_short-task-slug.md`.

## Write Policy (Deterministic Targets)
1. **Context Initialization**: Update `activeContext.md` with the current objective, constraints, and plan.
2. **Session Persistence**: Record milestone updates and major decisions in the current file under `logs/`.
3. **Clean Handoff**: Update `progress.md`, link the session log in `Milestones`, and mark the task log status.
EOF
fi

# 4. Always Create Tactical Context Templates
echo "🧠 Injecting Isolated Tactical Context Templates..."

write_if_missing "$MEMORY_DIR/activeContext.md" <<EOF
# Active Context
- **Current Objective**: [Agent to define immediate task]
- **Immediate Constraints**: [Agent to list current blockers or environment limits]
- **Open Questions**: [Agent to list items requiring clarification]
- **Current Plan**: [Agent to define step-by-step execution plan]
- **Last Updated By**: [Agent Name / Architect]
EOF

write_if_missing "$MEMORY_DIR/progress.md" <<EOF
# Project Progress
## Completed
- [x] Initial Exoskeleton Bootstrapped

## In Progress
- [ ] [Agent to define current active milestone]

## Next
- [ ] [Agent to define upcoming milestone]

## Milestones
- [ ] Link recent session logs here as they are created.
EOF

write_if_missing "$LOGS_DIR/TEMPLATE.md" <<'EOF'
# Task: [Name]

## Date
YYYY-MM-DD

## Summary
[Brief description]

## Milestones
- [Sub-task completed]

## Decisions
- [Key technical choice]

## Files Touched
- [Path list]

## Skills Used
- [List CLI skills provisioned]

## Next Steps
- [Follow-up action]

## Status
IN-PROGRESS
EOF

echo "✅ Initialization complete. Protocol-Ready."