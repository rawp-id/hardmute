#!/bin/bash

# Hardmute Multi-Agent Installation Script
# A lightweight execution protocol for AI agents.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Icons
CHECK="✓"
INFO="ℹ"
X_MARK="✗"
GEAR="⚙"

echo -e "${BLUE}${BOLD}========================================${NC}"
echo -e "${CYAN}${BOLD}   Hardmute Multi-Agent Installer${NC}"
echo -e "${BLUE}${BOLD}========================================${NC}"

# Define potential agent skill paths (Compatible with Bash 3.2+)
AGENT_NAMES=("Antigravity/Gemini" "Claude Code" "Windsurf" "Cursor (Global)" "OpenAI Codex" "Other Agents")
AGENT_PATHS=("$HOME/.gemini/antigravity/skills" "$HOME/.claude/skills" "$HOME/.windsurf/skills" "$HOME/.cursor/skills" "$HOME/.codex/skills" "$HOME/.agents/skills")

# Detected targets
DETECTED_TARGETS=()
SKILLS=("hardmute" "hardmute-info" "hardmute-detail" "hardmute-trace")

# Source directory logic
SRC_DIR="$(pwd)/skills"
if [ ! -d "$SRC_DIR" ]; then
    echo -e "${INFO} Skills directory not found locally. Attempting remote download...${NC}"
    TEMP_DIR=$(mktemp -d)
    git clone --depth 1 https://github.com/rawp-id/hardmute.git "$TEMP_DIR" > /dev/null 2>&1
    SRC_DIR="$TEMP_DIR/skills"
    trap 'rm -rf "$TEMP_DIR"' EXIT
fi

if [ ! -d "$SRC_DIR" ]; then
    echo -e "${RED}${X_MARK} Error: Cannot find 'skills' directory.${NC}"
    exit 1
fi

# Detection phase
echo -e "${BOLD}Detecting compatible agents...${NC}"
for i in "${!AGENT_NAMES[@]}"; do
    name="${AGENT_NAMES[$i]}"
    path="${AGENT_PATHS[$i]}"
    # Check if the parent directory of the skills folder exists
    parent_dir=$(dirname "$path")
    if [ -d "$parent_dir" ]; then
        echo -e "  ${GREEN}${CHECK}${NC} Found ${BOLD}$name${NC}"
        DETECTED_TARGETS+=("$path|$name")
    fi
done

if [ ${#DETECTED_TARGETS[@]} -eq 0 ]; then
    echo -e "${YELLOW}${INFO} No known agents detected. Defaulting to Gemini path.${NC}"
    DETECTED_TARGETS+=("${AGENT_PATHS[0]}|${AGENT_NAMES[0]}")
fi

# Installation phase
echo -e "\n${BOLD}Starting installation...${NC}"

for entry in "${DETECTED_TARGETS[@]}"; do
    IFS="|" read -r target_path target_name <<< "$entry"
    
    echo -e "\n${CYAN}${GEAR} Target: $target_name${NC}"
    echo -e "  Path: $target_path"
    
    mkdir -p "$target_path"
    
    for skill in "${SKILLS[@]}"; do
        if [ -d "$SRC_DIR/$skill" ]; then
            echo -ne "  Installing ${BOLD}$skill${NC}... "
            cp -r "$SRC_DIR/$skill" "$target_path/"
            echo -e "${GREEN}${CHECK}${NC}"
        else
            echo -e "  ${RED}${X_MARK} Skill '$skill' not found${NC}"
        fi
    done
done

echo -e "\n${BLUE}${BOLD}========================================${NC}"
echo -e "${GREEN}${BOLD}   Multi-Agent Installation Complete!${NC}"
echo -e "${BLUE}${BOLD}========================================${NC}"
echo -e "\nYou can now use hardmute modes in your agents:"
echo -e "  ${BOLD}/hardmute${NC}        - Silent execution"
echo -e "  ${BOLD}/hardmute-info${NC}   - Minimal info"
echo -e "  ${BOLD}/hardmute-detail${NC} - Execution details"
echo -e "  ${BOLD}/hardmute-trace${NC}  - Debug on failure"
echo -e "\n${CYAN}Enjoy your noise-free execution environment.${NC}"
