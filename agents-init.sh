#!/bin/bash
set -e

LIB_PATH="$HOME/.agents/skills"
PROJECT_NAME=$(basename "$(pwd)")
MEMORY_DIR=".agents/memory-bank"
LOGS_DIR="$MEMORY_DIR/logs"

# Check if the path exists AND is a directory
if [ -d "$LIB_PATH" ]; then
    echo "✅ Skill Warehouse found at $LIB_PATH"
else
    echo "❌ Error: Skill Warehouse missing at $LIB_PATH"
    echo "Please ensure your 'Gold Standard' skills are located there."
    exit 1
fi

echo "🚀 Launching Universal Agentic Factory for [$PROJECT_NAME]..."

mkdir -p .agents/{skills/{git-collaboration,planning-execution,engineering-best-practices,architecture-design,debugging-quality,documentation-knowledge,agent-workflow,security-review},storage}
mkdir -p "$LOGS_DIR"

declare -A git_collaboration_skills=(
    ["git-advanced-workflows"]="git-advanced-workflows"
    ["git-pr-workflows-git-workflow"]="git-pr-workflows-git-workflow"
    ["git-pr-workflows-onboard"]="git-pr-workflows-onboard"
    ["git-pr-workflows-pr-enhance"]="git-pr-workflows-pr-enhance"
    ["git-pushing"]="git-pushing"
    ["using-git-worktrees"]="using-git-worktrees"
    ["commit"]="commit"
    ["create-branch"]="create-branch"
    ["create-pr"]="create-pr"
    ["iterate-pr"]="iterate-pr"
    ["gh-review-requests"]="gh-review-requests"
    ["differential-review"]="differential-review"
    ["code-review-checklist"]="code-review-checklist"
    ["code-review-excellence"]="code-review-excellence"
    ["receiving-code-review"]="receiving-code-review"
    ["requesting-code-review"]="requesting-code-review"
    ["fix-review"]="fix-review"
    ["git-hooks-automation"]="git-hooks-automation"
    ["gitlab-ci-patterns"]="gitlab-ci-patterns"
    ["gitops-workflow"]="gitops-workflow"
    ["address-github-comments"]="address-github-comments"
    ["github-actions-templates"]="github-actions-templates"
    ["github-automation"]="github-automation"
    ["github-issue-creator"]="github-issue-creator"
    ["github-workflow-automation"]="github-workflow-automation"
    ["gitlab-automation"]="gitlab-automation"
    ["bitbucket-automation"]="bitbucket-automation"
)
declare -A planning_execution_skills=(
    ["brainstorming"]="brainstorming"
    ["ask-questions-if-underspecified"]="ask-questions-if-underspecified"
    ["audit-context-building"]="audit-context-building"
    ["writing-plans"]="writing-plans"
    ["planning-with-files"]="planning-with-files"
    ["concise-planning"]="concise-planning"
    ["executing-plans"]="executing-plans"
    ["progressive-estimation"]="progressive-estimation"
    ["verification-before-completion"]="verification-before-completion"
)
declare -A engineering_best_practices_skills=(
    ["clean-code"]="clean-code"
    ["uncle-bob-craft"]="uncle-bob-craft"
    ["cc-skill-coding-standards"]="cc-skill-coding-standards"
    ["code-refactoring-refactor-clean"]="code-refactoring-refactor-clean"
    ["code-refactoring-tech-debt"]="code-refactoring-tech-debt"
    ["legacy-modernizer"]="legacy-modernizer"
    ["dependency-management-deps-audit"]="dependency-management-deps-audit"
    ["dependency-upgrade"]="dependency-upgrade"
)
declare -A architecture_design_skills=(
    ["software-architecture"]="software-architecture"
    ["architecture-patterns"]="architecture-patterns"
    ["architecture-decision-records"]="architecture-decision-records"
    ["domain-driven-design"]="domain-driven-design"
    ["ddd-context-mapping"]="ddd-context-mapping"
    ["ddd-strategic-design"]="ddd-strategic-design"
    ["antigravity-design-expert"]="antigravity-design-expert"
    ["design-orchestration"]="design-orchestration"
    ["design-spells"]="design-spells"
    ["tool-design"]="tool-design"
    ["blueprint"]="blueprint"
    ["backend-architect"]="backend-architect"
    ["microservices-patterns"]="microservices-patterns"
    ["workflow-orchestration-patterns"]="workflow-orchestration-patterns"
)
declare -A debugging_quality_skills=(
    ["systematic-debugging"]="systematic-debugging"
    ["debugging-strategies"]="debugging-strategies"
    ["error-detective"]="error-detective"
    ["find-bugs"]="find-bugs"
    ["test-driven-development"]="test-driven-development"
    ["testing-patterns"]="testing-patterns"
    ["testing-qa"]="testing-qa"
    ["test-fixing"]="test-fixing"
    ["clarity-gate"]="clarity-gate"
    ["lint-and-validate"]="lint-and-validate"
    ["quality-nonconformance"]="quality-nonconformance"
)
declare -A documentation_knowledge_skills=(
    ["documentation"]="documentation"
    ["documentation-templates"]="documentation-templates"
    ["code-documentation-code-explain"]="code-documentation-code-explain"
    ["code-documentation-doc-generate"]="code-documentation-doc-generate"
    ["postmortem-writing"]="postmortem-writing"
    ["wiki-architect"]="wiki-architect"
    ["wiki-page-writer"]="wiki-page-writer"
    ["wiki-researcher"]="wiki-researcher"
    ["wiki-changelog"]="wiki-changelog"
    ["wiki-onboarding"]="wiki-onboarding"
    ["context-manager"]="context-manager"
    ["context-management-context-save"]="context-management-context-save"
    ["context-management-context-restore"]="context-management-context-restore"
    ["context-window-management"]="context-window-management"
    ["manifest"]="manifest"
)
declare -A agent_workflow_skills=(
    ["ai-agents-architect"]="ai-agents-architect"
    ["agent-orchestrator"]="agent-orchestrator"
    ["multi-agent-patterns"]="multi-agent-patterns"
    ["agent-memory-systems"]="agent-memory-systems"
    ["prompt-engineering-patterns"]="prompt-engineering-patterns"
    ["prompt-library"]="prompt-library"
)
declare -A security_review_skills=(
    ["security-auditor"]="security-auditor"
    ["threat-modeling-expert"]="threat-modeling-expert"
    ["sast-configuration"]="sast-configuration"
    ["security-scanning-security-sast"]="security-scanning-security-sast"
    ["security-compliance-compliance-check"]="security-compliance-compliance-check"
    ["security-scanning-security-hardening"]="security-scanning-security-hardening"
    ["security-scanning-security-dependencies"]="security-scanning-security-dependencies"
    ["production-code-audit"]="production-code-audit"
    ["architect-review"]="architect-review"
    ["vibe-code-auditor"]="vibe-code-auditor"
)

link_bundle() {
    local bundle=$1
    local -n skills_ref=$2
    local target
    local destination

    for alias in "${!skills_ref[@]}"; do
        target="${skills_ref[$alias]}"
        if [ -d "$LIB_PATH/$target" ]; then
            destination=".agents/skills/$bundle/@$alias"
            link_skill "$LIB_PATH/$target" "$destination" "[$bundle] linked @$alias"
        fi
    done
}

link_skill() {
    local source_path=$1
    local destination_path=$2
    local success_message=$3

    if [ -e "$destination_path" ] && [ ! -L "$destination_path" ]; then
        echo "⚠️ Preserved existing path at $destination_path"
        return
    fi

    ln -sfn "$source_path" "$destination_path"
    echo "✅ $success_message"
}

link_bundle "git-collaboration" git_collaboration_skills
link_bundle "planning-execution" planning_execution_skills
link_bundle "engineering-best-practices" engineering_best_practices_skills
link_bundle "architecture-design" architecture_design_skills
link_bundle "debugging-quality" debugging_quality_skills
link_bundle "documentation-knowledge" documentation_knowledge_skills
link_bundle "agent-workflow" agent_workflow_skills
link_bundle "security-review" security_review_skills

echo "🧠 Injecting Deterministic Persistence Layer..."

write_if_missing() {
    local path=$1

    if [ -e "$path" ]; then
        echo "↩️ Preserved existing $path"
        return
    fi

    cat > "$path"
    echo "📝 Created $path"
}

write_if_missing "ADR.md" <<EOF
# Architecture Decision Records (ADR)

## ADR-001: Agentic Workspace and Persistence
**Status:** Accepted
**Decision:** Use the \`.agents/\` directory as the agent workspace and \`.agents/memory-bank/\` as the canonical persistence store.
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

- global bundles live under `.agents/skills/`
- project-level bundles may be linked under `.agents/skills/project/`
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
- use `.agents/skills/` for global bundles
- use `.agents/skills/project/` for project-specific bundle overlays when present

## Shutdown Sequence

Before completion or handoff:

1. update the active session log
2. update `progress.md`
3. refresh `activeContext.md` to reflect the next live concern
EOF

write_if_missing "$MEMORY_DIR/product.md" <<EOF
# Product Goals: $PROJECT_NAME
- **Vision**: [Define core purpose]
- **Target Audience**: [Who is this for?]
- **Core Outcomes**: [Success metrics]
- **Non-Goals**: [Out of scope items]
EOF

write_if_missing "$MEMORY_DIR/systemPatterns.md" <<'EOF'
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
EOF

write_if_missing "$MEMORY_DIR/activeContext.md" <<EOF
# Active Context
- **Current Objective**: Define requirements.
- **Immediate Constraints**: [e.g., Time, API limits]
- **Open Questions**: [Items requiring clarification]
- **Current Plan**: [The step-by-step]
- **Last Updated By**: Agent/Human
EOF

write_if_missing "$MEMORY_DIR/progress.md" <<EOF
# Project Progress
## Completed
- [x] Base Exoskeleton Initialized
## In Progress
- [ ] Requirements Refinement
## Next
- [ ] Architecture Design
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
- [@architecture/@brainstorming]

## Next Steps
- [Follow-up action]

## Status
IN-PROGRESS
EOF

echo "✅ Initialization complete. Protocol-Ready."
