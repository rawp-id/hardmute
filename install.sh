#!/bin/bash

# Hardmute TUI Multi-Agent Installer
# A lightweight execution protocol for AI agents.

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
NC='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

# Icons
CHECK="✓"
UNCHECKED="○"
CHECKED="◉"
INFO="ℹ"
X_MARK="✗"
GEAR="⚙"
ARROW="➜"

# Setup
AGENT_NAMES=("Antigravity/Gemini" "Claude Code" "Windsurf" "Cursor (Global)" "OpenAI Codex" "Other Agents")
AGENT_PATHS=("$HOME/.gemini/antigravity/skills" "$HOME/.claude/skills" "$HOME/.windsurf/skills" "$HOME/.cursor/skills" "$HOME/.codex/skills" "$HOME/.agents/skills")
SKILLS=("hardmute" "hardmute-info" "hardmute-detail" "hardmute-trace")

# Detection
DETECTED_NAMES=()
DETECTED_PATHS=()

for i in "${!AGENT_NAMES[@]}"; do
    if [ -d "$(dirname "${AGENT_PATHS[$i]}")" ]; then
        DETECTED_NAMES+=("${AGENT_NAMES[$i]}")
        DETECTED_PATHS+=("${AGENT_PATHS[$i]}")
    fi
done

# Fallback if none detected
if [ ${#DETECTED_NAMES[@]} -eq 0 ]; then
    DETECTED_NAMES=("Antigravity/Gemini")
    DETECTED_PATHS=("$HOME/.gemini/antigravity/skills")
fi

# TUI Menu Helper
# Usage: multi_select "Title" "OptionsArray" "SelectionsArray"
multi_select() {
    local title=$1
    shift
    local options=("$@")
    local len=${#options[@]}
    local current=0
    local selections=()
    
    # Initialize selections (all unselected by default)
    for ((i=0; i<len; i++)); do selections[i]=0; done

    while true; do
        clear
        echo -e "${BLUE}${BOLD}========================================${NC}"
        echo -e "${CYAN}${BOLD}   $title${NC}"
        echo -e "${BLUE}${BOLD}========================================${NC}"
        echo -e "${DIM}Use [↑/↓] to move, [Space] to toggle, [Enter] to confirm, [q] to quit${NC}\n"

        for i in "${!options[@]}"; do
            if [ $i -eq $current ]; then
                prefix="${MAGENTA}${ARROW}${NC} "
                style="${BOLD}${WHITE}"
            else
                prefix="  "
                style="${NC}"
            fi

            if [ "${selections[$i]}" == "1" ]; then
                echo -e "$prefix ${GREEN}${CHECKED}${NC} ${style}${options[$i]}${NC}"
            else
                echo -e "$prefix ${DIM}${UNCHECKED}${NC} ${style}${options[$i]}${NC}"
            fi
        done
        echo -e "\n${BLUE}${BOLD}========================================${NC}"

        # Read key (without -e to prevent exit on read failure)
        set +e
        IFS= read -rsn1 key
        
        case "$key" in
            $'\x1b') # Escape sequence
                read -rsn2 -t 0.1 next_key
                case "$next_key" in
                    '[A'|'OA') ((current--)) ;; # Up
                    '[B'|'OB') ((current++)) ;; # Down
                esac
                ;;
            ' ') # Toggle (Explicit Space)
                if [ "${selections[$current]}" == "1" ]; then
                    selections[$current]=0
                else
                    selections[$current]=1
                fi
                ;;
            "") # Enter
                set -e
                break
                ;;
            q|Q) # Quit
                echo -e "\n${RED}Installation cancelled.${NC}"
                exit 0
                ;;
        esac
        set -e

        # Wrap around
        if [ $current -lt 0 ]; then current=$((len-1)); fi
        if [ $current -ge $len ]; then current=0; fi
    done

    # Return selections via a global variable
    RET_SELECTIONS=("${selections[@]}")
}

# Source directory logic
SRC_DIR="$(pwd)/skills"
if [ ! -d "$SRC_DIR" ]; then
    clear
    echo -e "${INFO} Skills directory not found. Downloading...${NC}"
    TEMP_DIR=$(mktemp -d)
    git clone --depth 1 https://github.com/rawp-id/hardmute.git "$TEMP_DIR" > /dev/null 2>&1
    SRC_DIR="$TEMP_DIR/skills"
    trap 'rm -rf "$TEMP_DIR"' EXIT
fi

# 1. Select Agents
multi_select "Select Agents to Install" "${DETECTED_NAMES[@]}"
SELECTED_AGENT_NAMES=()
SELECTED_AGENT_PATHS=()
for i in "${!RET_SELECTIONS[@]}"; do
    if [ "${RET_SELECTIONS[$i]}" == "1" ]; then
        SELECTED_AGENT_NAMES+=("${DETECTED_NAMES[$i]}")
        SELECTED_AGENT_PATHS+=("${DETECTED_PATHS[$i]}")
    fi
done

# 2. Select Skills
multi_select "Select Skills to Install" "${SKILLS[@]}"
SELECTED_SKILLS=()
for i in "${!RET_SELECTIONS[@]}"; do
    if [ "${RET_SELECTIONS[$i]}" == "1" ]; then
        SELECTED_SKILLS+=("${SKILLS[$i]}")
    fi
done

# Final Confirmation
if [ ${#SELECTED_AGENT_NAMES[@]} -eq 0 ] || [ ${#SELECTED_SKILLS[@]} -eq 0 ]; then
    echo -e "${RED}${X_MARK} No agents or skills selected. Aborting.${NC}"
    exit 0
fi

clear
echo -e "${BLUE}${BOLD}========================================${NC}"
echo -e "${GREEN}${BOLD}   Installing Hardmute...${NC}"
echo -e "${BLUE}${BOLD}========================================${NC}"

for i in "${!SELECTED_AGENT_NAMES[@]}"; do
    target_name="${SELECTED_AGENT_NAMES[$i]}"
    target_path="${SELECTED_AGENT_PATHS[$i]}"
    
    echo -e "\n${CYAN}${GEAR} Target: $target_name${NC}"
    echo -e "  Path: $target_path"
    
    mkdir -p "$target_path"
    
    for skill in "${SELECTED_SKILLS[@]}"; do
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
echo -e "\n${CYAN}Enjoy your noise-free execution environment.${NC}"
