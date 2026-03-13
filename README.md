# Agent Workspace Setup

This repo uses two shell scripts:

- [agents-init.sh]: initializes the generic agent workspace
- [project-skills-init.sh]: links project-specific skills from a bundle file

## What `agents-init.sh` does

`agents-init.sh` is the universal initializer. It should be reusable across different projects.

It does three things:

1. Creates the `.agents/` workspace structure with memory store under `.agents/memory-bank/`.
2. Creates generic/global skill symlinks under `.agents/skills/`.

The global skill bundles it scaffolds are:

- `git-collaboration`
- `planning-execution`
- `engineering-best-practices`
- `architecture-design`
- `debugging-quality`
- `documentation-knowledge`
- `agent-workflow`
- `security-review`

It does not create project-stack-specific bundles such as frontend, backend, database, deployment, WordPress, Next.js, or other repo-specific stacks.

Run it from the project root:

```bash
cd ~/your-workspace/your-project
chmod +x agents-init.sh
./agents-init.sh
```

## What `project-skills-init.sh` does

`project-skills-init.sh` is the project overlay step.

It reads a Markdown bundle file and creates project-specific skill symlinks under:

```text
.agents/skills/project/<section-slug>/<bundle-slug>/@skill
```

For this repo, the Example project bundle file is:

- [headlessWP_skills_bundles.md]

Example usage:

```bash
cd ~/your-workspace/your-project
chmod +x project-skills-init.sh
./project-skills-init.sh
```

That will create project-level skill overlays for the headless WordPress / Next.js project without changing the global bundle layout created by `agents-init.sh`.

## Skill Library Path

Both scripts resolve skills from:

```bash
LIB_PATH="${LIB_PATH:-$HOME/.agents/skills}"
```

That means:

- preferred: have the skill library already installed at `$HOME/.agents/skills`
- or: set `LIB_PATH` to the your agents skills location before running the scripts

Important Note: 

All referenced skills are sourced from the [antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills).

🚀 Installation & Skills Architecture
To ensure maximum compatibility across different CLI agents and to prevent crashes associated with default pathing in recent updates, we use a Global Warehouse approach.

1. Install the Skill Warehouse
Install all skills to the industry-standard path. This keeps your skills isolated from tool-specific configurations:

Bash

npx antigravity-awesome-skills --path ~/.agents/skills
2. Why use ~/.agents/skills?
While the default npx installation targets .gemini/antigravity/skills/, we strongly recommend using the ~/.agents/skills directory.

Stability: Prevents agent crashes caused by recent Antigravity updates regarding default path resolution.

Interoperability: Aligns with the Agent Skills Standard, making your skills instantly discoverable by tools like KiloCode, Codex, and others.

Portability: Allows you to maintain one "Gold Standard" library and symlink it to multiple CLI agents.

🛠️ Configuration & Environment
If you use a custom installation path, you must ensure your environment is aware of it. The provided automation scripts rely on the LIB_PATH variable to establish symlinks.

Set your Library Path
Add this to your .bashrc or .zshrc:

Bash

export LIB_PATH="$HOME/.agents/skills"
[!IMPORTANT]
If skills are installed in a non-default location and LIB_PATH is not set, the initialization scripts will fail to map the skill bundles, resulting in an empty agent exoskeleton.

🏛️ Structural Example
A properly initialized environment should look like this:

Plaintext

~/.agents/skills/          <-- Your Physical Warehouse
└── brainstorming/
└── software-architecture/
~/.local/share/kilo/skills/ --> Symlinked to ~/.agents/skills/
~/projects/my-app/.agents/  --> Project-specific links to Warehouse

## Recommended Workflow

1. Install the Antigravity skill library, or set `LIB_PATH` to its location.
2. Run the universal initializer:

```bash
cd ~/your-workspace/your-project
chmod +x agents-init.sh
./agents-init.sh
```

3. Run the project bundle linker:

```bash
chmod +x project-skills-init.sh
./project-skills-init.sh "headlessWP_skills_bundles.md"
```

4. Confirm the results under:

```text
.agents/skills/
.agents/skills/project/
.agents/memory-bank/
```

## Notes

- `agents-init.sh` is intentionally global-only.
- `project-skills-init.sh` is intentionally project-specific.

The structure is complete enough to start.

  - the persistence contract is defined in AGENTS.md, ADR.md, and .agents/PROTOCOL.md
  - the logs directory exists with a template

  What is still incomplete is content, not structure. Several files are still placeholders:

  - product.md
  - systemPatterns.md
  - activeContext.md
  - progress.md

That is normal for a new project. During the first session (new agents works on a blank project, initiated with the agents-init.sh script) prompt agent to:

  - create the first session log
  - replace placeholder text in the memory files with actual project context
