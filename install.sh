#!/bin/bash
# ai-dotfiles install script
# Maps unified skills/commands to each tool's specific format and location

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Parse arguments
LOCAL_INSTALL=false
FORCE=false
VERBOSE=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --local)
      LOCAL_INSTALL=true
      shift
      ;;
    --force)
      FORCE=true
      shift
      ;;
    --verbose)
      VERBOSE=true
      shift
      ;;
    --help)
      cat << 'EOF'
Usage: ./install.sh [OPTIONS]

Install unified AI configuration across Claude Code, Cursor, and Codex.

Options:
  --local      Install in current project (not global)
  --force      Overwrite existing configs without prompting
  --verbose    Show detailed output
  --help       Show this help message

Examples:
  ./install.sh              # Global install
  ./install.sh --local      # Project install
  ./install.sh --force      # Overwrite existing
EOF
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Logging
log() {
  if [ "$VERBOSE" = true ]; then
    echo "$@"
  fi
}

# Determine target directories
if [ "$LOCAL_INSTALL" = true ]; then
  TARGET_BASE="$(pwd)"
  echo -e "${BLUE}🔧 Project-level installation${NC}"
else
  TARGET_BASE="$HOME"
  echo -e "${BLUE}🌐 Global installation${NC}"
fi

echo -e "Source: ${GREEN}$SCRIPT_DIR${NC}"
echo -e "Target: ${GREEN}$TARGET_BASE${NC}"
echo ""

# Track operations
INSTALLED=()
SKIPPED=()
CONVERTED=()

# Helper: Backup existingackup_if_exists() {
  local target="$1"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
    mv "$target" "$backup"
    echo -e "${YELLOW}  Backed up: $(basename "$target")${NC}"
  fi
}

# Helper: Create symlink with optional force
symlink() {
  local src="$1"
  local dst="$2"
  local name="$3"
  
  if [ -L "$dst" ]; then
    local current=$(readlink "$dst" 2>/dev/null || true)
    if [ "$current" = "$src" ]; then
      log "  ✓ $name (already linked)"
      return 0
    else
      rm "$dst"
    fi
  elif [ -e "$dst" ]; then
    if [ "$FORCE" = true ]; then
      backup_if_exists "$dst"
    else
      echo -e "${YELLOW}  ⊘ $name (exists, use --force)${NC}"
      SKIPPED+=("$name")
      return 0
    fi
  fi
  
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo -e "${GREEN}  ✓${NC} $name"
  INSTALLED+=("$name")
}

# Helper: Create hard link (for same content, different location)
hardlink() {
  local src="$1"
  local dst="$2"
  local name="$3"
  
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    if [ "$FORCE" = true ]; then
      backup_if_exists "$dst"
    else
      echo -e "${YELLOW}  ⊘ $name (exists, use --force)${NC}"
      SKIPPED+=("$name")
      return 0
    fi
  fi
  
  mkdir -p "$(dirname "$dst")"
  ln "$src" "$dst" 2>/dev/null || ln -s "$src" "$dst"
  echo -e "${GREEN}  ✓${NC} $name"
  INSTALLED+=("$name")
}

# Convert MCP servers.yaml to Claude settings.json format
convert_mcp_claude() {
  local yaml_file="$SCRIPT_DIR/mcp/servers.yaml"
  local settings_file="$1"
  
  if [ ! -f "$yaml_file" ]; then
    return 0
  fi
  
  # Simple YAML to JSON conversion for MCP servers
  # This is a basic implementation - for complex cases, use yq
  if command -v yq &> /dev/null; then
    yq -o=json "$yaml_file" > /tmp/mcp_servers.json
    # Merge into settings.json
    if [ -f "$settings_file" ]; then
      # Read existing settings and merge MCP
      cat "$settings_file" | jq --slurpfile mcp /tmp/mcp_servers.json '. + {mcpServers: $mcp[0].servers}' > /tmp/settings_new.json
      mv /tmp/settings_new.json "$settings_file"
    fi
  fi
}

# Convert MCP servers.yaml to Cursor mcp.json format
convert_mcp_cursor() {
  local yaml_file="$SCRIPT_DIR/mcp/servers.yaml"
  local mcp_file="$1"
  
  if [ ! -f "$yaml_file" ]; then
    return 0
  fi
  
  if command -v yq &> /dev/null; then
    yq -o=json "$yaml_file" > "$mcp_file"
    echo -e "${GREEN}  ✓${NC} MCP config (Cursor)"
    CONVERTED+=("MCP Cursor")
  fi
}

# Convert MCP servers.yaml to Codex config.toml format
convert_mcp_codex() {
  local yaml_file="$SCRIPT_DIR/mcp/servers.yaml"
  local config_file="$1"
  
  if [ ! -f "$yaml_file" ]; then
    return 0
  fi
  
  # Append MCP section to config.toml
  if [ -f "$yaml_file" ]; then
    echo "" >> "$config_file"
    echo "# MCP Servers (auto-converted from mcp/servers.yaml)" >> "$config_file"
    echo "[mcp]" >> "$config_file"
    
    # Simple conversion - extract server names and commands
    grep -A 5 "^  [a-z-]*:" "$yaml_file" | grep -E "(type:|command:|args:)" | sed 's/^  //' >> "$config_file"
    
    echo -e "${GREEN}  ✓${NC} MCP config (Codex)"
    CONVERTED+=("MCP Codex")
  fi
}

echo -e "${BLUE}Installing Claude Code configuration...${NC}"

CLAUDE_DIR="$TARGET_BASE/.claude"
if [ "$LOCAL_INSTALL" = true ]; then
  symlink "$SCRIPT_DIR/adapters/claude" "$CLAUDE_DIR" "Claude config"
  symlink "$SCRIPT_DIR/AGENTS.md" "$TARGET_BASE/CLAUDE.md" "CLAUDE.md"
else
  symlink "$SCRIPT_DIR/adapters/claude" "$CLAUDE_DIR" "~/.claude"
  symlink "$SCRIPT_DIR/AGENTS.md" "$CLAUDE_DIR/CLAUDE.md" "~/.claude/CLAUDE.md"
fi

# Install skills for Claude (directory structure)
if [ -d "$SCRIPT_DIR/skills" ]; then
  for skill_dir in "$SCRIPT_DIR/skills"/*; do
    if [ -d "$skill_dir" ]; then
      skill_name=$(basename "$skill_dir")
      if [ -f "$skill_dir/skill.md" ]; then
        mkdir -p "$CLAUDE_DIR/skills/$skill_name"
        hardlink "$skill_dir/skill.md" "$CLAUDE_DIR/skills/$skill_name/SKILL.md" "  Skill: $skill_name"
      fi
    fi
  done
fi

# Install commands for Claude
if [ -d "$SCRIPT_DIR/commands" ]; then
  mkdir -p "$CLAUDE_DIR/commands"
  for cmd_file in "$SCRIPT_DIR/commands"/*.md; do
    if [ -f "$cmd_file" ]; then
      cmd_name=$(basename "$cmd_file")
      hardlink "$cmd_file" "$CLAUDE_DIR/commands/$cmd_name" "  Command: ${cmd_name%.md}"
    fi
  done
fi

# Convert MCP config
convert_mcp_claude "$CLAUDE_DIR/settings.json"

echo ""
echo -e "${BLUE}Installing Cursor configuration...${NC}"

CURSOR_DIR="$TARGET_BASE/.cursor"
mkdir -p "$CURSOR_DIR"

# Install adapter rules
if [ -d "$SCRIPT_DIR/adapters/cursor/rules" ]; then
  symlink "$SCRIPT_DIR/adapters/cursor/rules" "$CURSOR_DIR/rules" "Cursor rules"
fi

# Install skills as .mdc rules
if [ -d "$SCRIPT_DIR/skills" ]; then
  mkdir -p "$CURSOR_DIR/rules"
  for skill_dir in "$SCRIPT_DIR/skills"/*; do
    if [ -d "$skill_dir" ]; then
      skill_name=$(basename "$skill_dir")
      if [ -f "$skill_dir/skill.md" ]; then
        # Create .mdc version (symlink with different extension)
        # Cursor uses .mdc extension
        ln -sf "$skill_dir/skill.md" "$CURSOR_DIR/rules/${skill_name}.mdc" 2>/dev/null || true
        echo -e "${GREEN}  ✓${NC} Rule: $skill_name.mdc"
        INSTALLED+=("cursor:$skill_name")
      fi
    fi
  done
fi

# Convert MCP config
convert_mcp_cursor "$CURSOR_DIR/mcp.json"

echo ""
echo -e "${BLUE}Installing OpenAI Codex configuration...${NC}"

CODEX_DIR="$TARGET_BASE/.codex"
if [ "$LOCAL_INSTALL" = true ]; then
  symlink "$SCRIPT_DIR/adapters/codex" "$CODEX_DIR" "Codex config"
  symlink "$SCRIPT_DIR/AGENTS.md" "$TARGET_BASE/AGENTS.md" "AGENTS.md"
else
  symlink "$SCRIPT_DIR/adapters/codex" "$CODEX_DIR" "~/.codex"
  symlink "$SCRIPT_DIR/AGENTS.md" "$CODEX_DIR/AGENTS.md" "~/.codex/AGENTS.md"
fi

# Install skills for Codex
if [ -d "$SCRIPT_DIR/skills" ]; then
  for skill_dir in "$SCRIPT_DIR/skills"/*; do
    if [ -d "$skill_dir" ]; then
      skill_name=$(basename "$skill_dir")
      if [ -f "$skill_dir/skill.md" ]; then
        mkdir -p "$CODEX_DIR/skills/$skill_name"
        hardlink "$skill_dir/skill.md" "$CODEX_DIR/skills/$skill_name/skill.md" "  Skill: $skill_name"
      fi
    fi
  done
fi

# Install commands as prompts for Codex
if [ -d "$SCRIPT_DIR/commands" ]; then
  mkdir -p "$CODEX_DIR/prompts"
  for cmd_file in "$SCRIPT_DIR/commands"/*.md; do
    if [ -f "$cmd_file" ]; then
      cmd_name=$(basename "$cmd_file")
      hardlink "$cmd_file" "$CODEX_DIR/prompts/$cmd_name" "  Prompt: ${cmd_name%.md}"
    fi
  done
fi

# Convert MCP config
convert_mcp_codex "$CODEX_DIR/config.toml"

echo ""
echo -e "${BLUE}Installing Windsurf/OpenCode (via AGENTS.md)...${NC}"
# These tools read AGENTS.md automatically
if [ "$LOCAL_INSTALL" = true ]; then
  if [ ! -e "$TARGET_BASE/AGENTS.md" ]; then
    symlink "$SCRIPT_DIR/AGENTS.md" "$TARGET_BASE/AGENTS.md" "AGENTS.md"
  fi
fi
echo -e "${GREEN}  ✓${NC} AGENTS.md (universal)"
INSTALLED+=("AGENTS.md")

echo ""
echo -e "${BLUE}========================${NC}"
echo -e "${GREEN}Installation complete!${NC}"
echo ""

if [ ${#INSTALLED[@]} -gt 0 ]; then
  echo -e "${GREEN}Installed (${#INSTALLED[@]} items):${NC}"
  for item in "${INSTALLED[@]}"; do
    echo "  ✓ $item"
  done
  echo ""
fi

if [ ${#CONVERTED[@]} -gt 0 ]; then
  echo -e "${GREEN}Converted (${#CONVERTED[@]} items):${NC}"
  for item in "${CONVERTED[@]}"; do
    echo "  ✓ $item"
  done
  echo ""
fi

if [ ${#SKIPPED[@]} -gt 0 ]; then
  echo -e "${YELLOW}Skipped (${#SKIPPED[@]} items):${NC}"
  for item in "${SKIPPED[@]}"; do
    echo "  ⊘ $item"
  done
  echo ""
fi

echo -e "${BLUE}Next steps:${NC}"
if [ "$LOCAL_INSTALL" = true ]; then
  echo "  • Skills available in: ./.claude/skills/, ./.cursor/rules/, ./.codex/skills/"
  echo "  • Edit files in ./.ai/skills/ to update all tools"
  echo "  • Commit ./.ai/ directory to git"
else
  echo "  • Skills available in: ~/.claude/skills/, .cursor/rules/, ~/.codex/skills/"
  echo "  • Edit files in ~/.ai/skills/ to update all tools"
  echo "  • Changes apply globally to all projects"
fi
echo ""
echo -e "${BLUE}To add a new skill:${NC}"
echo "  1. Create: mkdir ~/.ai/skills/my-skill && vim ~/.ai/skills/my-skill/skill.md"
echo "  2. Re-run: cd ~/.ai && ./install.sh"
echo "  3. Available immediately in Claude, Cursor, and Codex!"
echo ""
