#!/usr/bin/env bash
#
# sync.sh - Synchronize custom skills from this repository to local AI agent configurations.
#
# Supported Environments:
#   - CodeBuddy:       ~/.codebuddy/skills
#   - Antigravity:     ~/.gemini/config/skills
#   - Agents / Claude: ~/.agents/skills
#
# Usage:
#   ./sync.sh              # Auto-detects installed AI agents, or prepares all if none detected
#   ./sync.sh --codebuddy  # Force sync to CodeBuddy (~/.codebuddy/skills)
#   ./sync.sh --gemini     # Force sync to Antigravity (~/.gemini/config/skills)
#   ./sync.sh --agents     # Force sync to Agents (~/.agents/skills)
#   ./sync.sh --all        # Force sync to all supported environments
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"

# Determine base home directory (support Linux, macOS, WSL, and Windows Git Bash/MSYS2)
if command -v cygpath >/dev/null 2>&1 && [ -n "${USERPROFILE:-}" ]; then
    BASE_HOME="$(cygpath -u "$USERPROFILE")"
else
    BASE_HOME="$HOME"
fi

GEMINI_SKILLS="$BASE_HOME/.gemini/config/skills"
AGENTS_SKILLS="$BASE_HOME/.agents/skills"
CODEBUDDY_SKILLS="$BASE_HOME/.codebuddy/skills"

FORCE_CODEBUDDY=0
FORCE_GEMINI=0
FORCE_AGENTS=0
FORCE_ALL=0

print_help() {
    cat <<EOF
Usage: ./skills/sync.sh [OPTIONS]

Synchronize skills from this repository to AI agent configuration directories.

Options:
  -c, --codebuddy    Explicitly sync to CodeBuddy (~/.codebuddy/skills)
  -g, --gemini       Explicitly sync to Antigravity (~/.gemini/config/skills)
      --agents       Explicitly sync to Agents / Claude (~/.agents/skills)
  -a, --all          Sync to all supported environments (CodeBuddy, Antigravity, Agents)
  -h, --help         Show this help message

If no option is specified, the script automatically detects existing agent directories
on your machine. If none are detected, it prepares all standard locations.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -c|--codebuddy)
            FORCE_CODEBUDDY=1
            shift
            ;;
        -g|--gemini|--antigravity)
            FORCE_GEMINI=1
            shift
            ;;
        --agents)
            FORCE_AGENTS=1
            shift
            ;;
        -a|--all)
            FORCE_ALL=1
            shift
            ;;
        -h|--help)
            print_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            print_help
            exit 1
            ;;
    esac
done

TARGET_DIRS=()

add_target_dir() {
    local raw_dir="$1"
    mkdir -p "$raw_dir"

    local canonical
    if command -v realpath >/dev/null 2>&1; then
        canonical="$(realpath "$raw_dir")"
    else
        canonical="$(readlink -f "$raw_dir" 2>/dev/null || echo "$raw_dir")"
    fi

    for existing in "${TARGET_DIRS[@]}"; do
        if [ "$existing" = "$canonical" ]; then
            return 0
        fi
    done
    TARGET_DIRS+=("$canonical")
}

# 1. Handle explicit flags
if [ "$FORCE_ALL" -eq 1 ]; then
    add_target_dir "$CODEBUDDY_SKILLS"
    add_target_dir "$GEMINI_SKILLS"
    add_target_dir "$AGENTS_SKILLS"
else
    if [ "$FORCE_CODEBUDDY" -eq 1 ]; then
        add_target_dir "$CODEBUDDY_SKILLS"
    fi
    if [ "$FORCE_GEMINI" -eq 1 ]; then
        add_target_dir "$GEMINI_SKILLS"
    fi
    if [ "$FORCE_AGENTS" -eq 1 ]; then
        add_target_dir "$AGENTS_SKILLS"
    fi
fi

# 2. If no explicit targets were specified, perform auto-detection
if [ ${#TARGET_DIRS[@]} -eq 0 ]; then
    # Detect CodeBuddy (directory or CLI command)
    if [ -d "$HOME/.codebuddy" ] || [ -d "$CODEBUDDY_SKILLS" ] || command -v codebuddy >/dev/null 2>&1; then
        add_target_dir "$CODEBUDDY_SKILLS"
    fi

    # Detect Antigravity / Gemini
    if [ -d "$HOME/.gemini/config" ] || [ -d "$GEMINI_SKILLS" ]; then
        add_target_dir "$GEMINI_SKILLS"
    fi

    # Detect Agents / Claude
    if [ -d "$HOME/.agents" ] || [ -d "$AGENTS_SKILLS" ]; then
        add_target_dir "$AGENTS_SKILLS"
    fi

    # Fallback: if no environments were detected at all on a fresh machine, prepare all standard targets
    if [ ${#TARGET_DIRS[@]} -eq 0 ]; then
        echo "[i] No existing AI agent directories found. Preparing standard targets..."
        add_target_dir "$CODEBUDDY_SKILLS"
        add_target_dir "$GEMINI_SKILLS"
        add_target_dir "$AGENTS_SKILLS"
    fi
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
echo "Supported environments (CodeBuddy / Antigravity / Agents) will automatically discover them."
