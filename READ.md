# Agent Workspace Setup

This repo uses two shell scripts:

- [agents-init.sh]: initializes the generic agent workspace
- [project-skills-init.sh]: links project-specific skills from a bundle file

## What `agents-init.sh` does

`agents-init.sh` is the universal initializer. It should be reusable across different projects.

It does three things:

1. Creates the `.agents/` workspace structure.
2. Creates generic/global skill symlinks under `.agents/skills/`.
3. Creates the canonical memory store under `.agents/memory-bank/` if files do not already exist.

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
bash agents-init.sh
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
bash project-skills-init.sh
```

That will create project-level skill overlays for the headless WordPress / Next.js project without changing the global bundle layout created by `agents-init.sh`.

## Skill Library Path

Both scripts resolve skills from:

```bash
LIB_PATH="${ANTIGRAVITY_SKILLS:-$HOME/.gemini/antigravity/skills}"
```

That means:

- preferred: have the skill library already installed at `$HOME/.gemini/antigravity/skills`
- or: set `ANTIGRAVITY_SKILLS` to the your agents skills location before running the scripts

Important Note: 

All referenced skills are sourced from the [antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills).

If the skills are not installed in the default location and `ANTIGRAVITY_SKILLS` is not set, the scripts will not be able to create the symlinks.

## Recommended Workflow

1. Install the Antigravity skill library, or set `ANTIGRAVITY_SKILLS` to its location.
2. Run the universal initializer:

```bash
bash "New folder/agents-init.sh"
```

3. Run the project bundle linker:

```bash
bash "New folder/project-skills-init.sh" "headlessWP_skills_bundles.md"
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
- The memory bank remains canonical at `.agents/memory-bank/`.
- The `memory-bank` symlink at repo root points to `.agents/memory-bank/`.
