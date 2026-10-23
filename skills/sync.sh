#!/usr/bin/env bash
#
# sync.sh - Synchronize custom skills from this repository to local agent configurations.
# Works across Linux and macOS.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"

# Determine target directories
# 1. Antigravity global config path: ~/.gemini/config/skills
# 2. General agent config path: ~/.agents/skills
TARGET_DIRS=()

GEMINI_SKILLS="$HOME/.gemini/config/skills"
AGENTS_SKILLS="$HOME/.agents/skills"

# If ~/.gemini/config/skills is a symlink, resolve canonical target to avoid duplicate links
if [ -L "$GEMINI_SKILLS" ]; then
    CANONICAL_TARGET="$(readlink -f "$GEMINI_SKILLS")"
    TARGET_DIRS+=("$CANONICAL_TARGET")
elif [ -d "$GEMINI_SKILLS" ]; then
    TARGET_DIRS+=("$GEMINI_SKILLS")
fi

if [ -d "$AGENTS_SKILLS" ]; then
    CANONICAL_AGENTS="$(readlink -f "$AGENTS_SKILLS")"
    # Only add if not already in TARGET_DIRS
    ALREADY_ADDED=0
    for dir in "${TARGET_DIRS[@]}"; do
        if [ "$dir" = "$CANONICAL_AGENTS" ]; then
            ALREADY_ADDED=1
            break
        fi
    done
    if [ "$ALREADY_ADDED" -eq 0 ]; then
        TARGET_DIRS+=("$CANONICAL_AGENTS")
    fi
fi

# If neither directory exists, create standard Antigravity skills directory
if [ ${#TARGET_DIRS[@]} -eq 0 ]; then
    mkdir -p "$GEMINI_SKILLS"
    TARGET_DIRS+=("$GEMINI_SKILLS")
fi

echo "=================================================="
echo " Synchronizing Agent Skills to Local Environment"
echo "=================================================="
echo "Source: $SKILLS_DIR"
for t in "${TARGET_DIRS[@]}"; do
    echo "Target: $t"
done
echo "--------------------------------------------------"

SYNCED_COUNT=0

for skill_path in "$SKILLS_DIR"/*; do
    [ -e "$skill_path" ] || continue
    [ -d "$skill_path" ] || continue

    skill_name="$(basename "$skill_path")"

    # Skip non-skill folders or hidden dirs if any
    if [[ "$skill_name" =~ ^\. ]]; then
        continue
    fi

    for target_dir in "${TARGET_DIRS[@]}"; do
        mkdir -p "$target_dir"
        dest_link="$target_dir/$skill_name"

        # If dest exists as a real directory (not symlink), backup first
        if [ -d "$dest_link" ] && [ ! -L "$dest_link" ]; then
            backup_dir="${dest_link}.bak.$(date +%Y%m%d%H%M%S)"
            echo "[!] Existing real directory found at $dest_link. Moving to $backup_dir"
            mv "$dest_link" "$backup_dir"
        fi

        ln -sfn "$skill_path" "$dest_link"
        echo "[✓] Linked: $skill_name -> $dest_link"
    done
    SYNCED_COUNT=$((SYNCED_COUNT + 1))
done

echo "--------------------------------------------------"
echo "Done! Successfully synchronized $SYNCED_COUNT skill(s)."
echo "Antigravity and supported AI agents will automatically discover them."
