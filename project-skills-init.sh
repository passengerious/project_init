#!/bin/bash
set -e

LIB_PATH="$HOME/.agents/skills"
PROJECT_SKILLS_ROOT=".agents/skills/project"

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <project-skills-bundles.md>" >&2
    exit 1
fi

BUNDLE_FILE=$1

if [ ! -f "$BUNDLE_FILE" ]; then
    echo "Bundle file not found: $BUNDLE_FILE" >&2
    exit 1
fi

mkdir -p "$PROJECT_SKILLS_ROOT"

slugify() {
    printf '%s' "$1" \
        | tr '[:upper:]' '[:lower:]' \
        | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//'
}

link_skill() {
    local source_path=$1
    local destination_path=$2

    if [ -e "$destination_path" ] && [ ! -L "$destination_path" ]; then
        echo "⚠️ Preserved existing path at $destination_path"
        return
    fi

    ln -sfn "$source_path" "$destination_path"
    echo "✅ Linked $(basename "$destination_path")"
}

current_section=""

while IFS= read -r line || [ -n "$line" ]; do
    if [[ $line =~ ^###[[:space:]]+(.+)$ ]]; then
        current_section=$(slugify "${BASH_REMATCH[1]}")
        mkdir -p "$PROJECT_SKILLS_ROOT/$current_section"
        continue
    fi

    if [[ $line =~ ^-[[:space:]]+([^:]+):[[:space:]]+(.+)$ ]]; then
        if [ -z "$current_section" ]; then
            continue
        fi

        bundle_name=$(slugify "${BASH_REMATCH[1]}")
        bundle_dir="$PROJECT_SKILLS_ROOT/$current_section/$bundle_name"
        mkdir -p "$bundle_dir"

        while IFS= read -r skill; do
            skill_name=${skill#\`}
            skill_name=${skill_name%\`}

            if [ -d "$LIB_PATH/$skill_name" ]; then
                link_skill "$LIB_PATH/$skill_name" "$bundle_dir/@$skill_name"
            else
                echo "⚠️ Missing skill library entry: $skill_name"
            fi
        done < <(printf '%s\n' "${BASH_REMATCH[2]}" | grep -oE '`[^`]+`' || true)
    fi
done < "$BUNDLE_FILE"

echo "✅ Project skill linking complete."
