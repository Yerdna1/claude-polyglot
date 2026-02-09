#!/bin/bash
# Claude Code Multi-Provider Wrapper - Installation Script
# This script adds the wrapper commands to your PATH

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$SCRIPT_DIR/bin"
ENV_FILE="$SCRIPT_DIR/.env"
ENV_EXAMPLE="$SCRIPT_DIR/.env.example"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

echo -e "${CYAN}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║     Claude Code Multi-Provider Wrapper Installation       ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Make all scripts executable
echo -e "${YELLOW}Making scripts executable...${NC}"
chmod +x "$BIN_DIR"/*
echo -e "${GREEN}Done!${NC}"

# Create .env from example if it doesn't exist
if [[ ! -f "$ENV_FILE" ]]; then
    echo -e "${YELLOW}Creating .env file from template...${NC}"
    cp "$ENV_EXAMPLE" "$ENV_FILE"
    echo -e "${GREEN}Created $ENV_FILE${NC}"
    echo -e "${YELLOW}Please edit this file to add your API keys!${NC}"
fi

# Detect shell configuration file
detect_shell_config() {
    if [[ -n "$ZSH_VERSION" ]] || [[ "$SHELL" == */zsh ]]; then
        if [[ -f "$HOME/.zshrc" ]]; then
            echo "$HOME/.zshrc"
        else
            echo "$HOME/.zprofile"
        fi
    elif [[ -n "$BASH_VERSION" ]] || [[ "$SHELL" == */bash ]]; then
        if [[ -f "$HOME/.bashrc" ]]; then
            echo "$HOME/.bashrc"
        else
            echo "$HOME/.bash_profile"
        fi
    else
        echo "$HOME/.profile"
    fi
}

SHELL_CONFIG=$(detect_shell_config)
PATH_EXPORT="export PATH=\"$BIN_DIR:\$PATH\""

# Check if PATH is already configured
if grep -q "$BIN_DIR" "$SHELL_CONFIG" 2>/dev/null; then
    echo -e "${GREEN}PATH already configured in $SHELL_CONFIG${NC}"
else
    echo ""
    echo -e "${BOLD}Add to PATH?${NC}"
    echo "This will add the following line to $SHELL_CONFIG:"
    echo -e "${CYAN}  $PATH_EXPORT${NC}"
    echo ""
    read -p "Add to PATH? [Y/n] " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        echo "" >> "$SHELL_CONFIG"
        echo "# Claude Code Multi-Provider Wrapper" >> "$SHELL_CONFIG"
        echo "$PATH_EXPORT" >> "$SHELL_CONFIG"
        echo -e "${GREEN}Added to $SHELL_CONFIG${NC}"
        echo -e "${YELLOW}Run 'source $SHELL_CONFIG' or restart your terminal${NC}"
    else
        echo -e "${YELLOW}Skipped. You can manually add this line to your shell config:${NC}"
        echo -e "${CYAN}  $PATH_EXPORT${NC}"
    fi
fi

# Create symlinks option (alternative installation)
echo ""
echo -e "${BOLD}Create symlinks in /usr/local/bin?${NC}"
echo "This allows running commands without modifying PATH."
read -p "Create symlinks? [y/N] " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Creating symlinks (may require sudo)...${NC}"

    for script in "$BIN_DIR"/*; do
        script_name=$(basename "$script")
        target="/usr/local/bin/$script_name"

        if [[ -L "$target" ]] || [[ -f "$target" ]]; then
            echo -e "${YELLOW}  $script_name already exists, skipping${NC}"
        else
            sudo ln -sf "$script" "$target" 2>/dev/null || {
                echo -e "${RED}  Failed to create symlink for $script_name (try with sudo)${NC}"
            }
            echo -e "${GREEN}  Created symlink: $script_name${NC}"
        fi
    done
fi

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Installation Complete!                       ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BOLD}Next steps:${NC}"
echo "  1. Edit your API keys in: ${CYAN}$ENV_FILE${NC}"
echo "  2. Restart terminal or run: ${CYAN}source $SHELL_CONFIG${NC}"
echo ""
echo -e "${BOLD}Available commands:${NC}"
echo "  ${YELLOW}claude${NC}        - Original Claude Code (unchanged)"
echo "  ${YELLOW}claude-poly${NC}   - Multi-provider launcher"
echo "  ${YELLOW}GLM${NC}           - Launch with GLM-4"
echo "  ${YELLOW}MINIMAX${NC}       - Launch with MiniMax"
echo "  ${YELLOW}GEMINI${NC}        - Launch with Google Gemini"
echo "  ${YELLOW}GPT${NC}           - Launch with GPT-4o"
echo "  ${YELLOW}DEEPSEEK${NC}      - Launch with DeepSeek"
echo "  ${YELLOW}QWEN${NC}          - Launch with Qwen"
echo "  ${YELLOW}GROQ${NC}          - Launch with Groq"
echo ""
echo "Run ${CYAN}claude-poly list${NC} to see all available providers."
echo ""
