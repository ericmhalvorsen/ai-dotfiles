#!/bin/bash
# ai-dotfiles install script
# Symlinks AI configuration to tool-specific locations

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Parse arguments
LOCAL_INSTALL=false
FORCE=false

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
    --help)
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --local    Install in current project (not global)"
      echo "  --force    Overwrite existing configs without prompting"
      echo "  --help     Show this help message"
      echo ""
      echo "Examples:"
      echo "  $0                    # Global install to ~/.claude, ~/.codex, etc."
      echo "  $0 --local            # Project install to ./.claude, ./.codex, etc."
      echo "  $0 --force            # Overwrite existing configs"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Run '$0 --help' for usage"
      exit 1
      ;;
  esac
done

# Determine target directories
if [ "$LOCAL_INSTALL" = true ]; then
  # Project-level install
  TARGET_BASE="$(pwd)"
  echo -e "${BLUE}🔧 Project-level installation${NC}"
  echo -e "Target: ${GREEN}$TARGET_BASE${NC}"
else
  # Global install
  TARGET_BASE="$HOME"
  echo -e "${BLUE}🌐 Global installation${NC}"
  echo -e "Target: ${GREEN}$TARGET_BASE${NC}"
fi

echo ""
echo -e "${BLUE}Source: ${GREEN}$SCRIPT_DIR${NC}"
echo ""

# Track what we installed
INSTALLED=()
SKIPPED=()

# Helper: Create symlink with backup
create_symlink() {
  local src="$1"
  local dst="$2"
  local name="$3"
  
  # Check if destination exists
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    if [ -L "$dst" ]; then
      # It's already a symlink, check if it points to us
      local current_target=$(readlink "$dst" 2>/dev/null || true)
      if [ "$current_target" = "$src" ]; then
        echo -e "  ${GREEN}✓${NC} $name (already linked)"
        INSTALLED+=("$name")
        return 0
      fi
    fi
    
    # Exists but not our symlink
    if [ "$FORCE" = true ]; then
      echo -e "  ${YELLOW}⚠${NC} $name (backing up existing)"
      mv "$dst" "${dst}.backup.$(date +%Y%m%d_%H%M%S)"
    else
      echo -e "  ${YELLOW}⊘${NC} $name (exists, use --force to overwrite)"
      SKIPPED+=("$name")
      return 0
    fi
  fi
  
  # Create parent directory if needed
  mkdir -p "$(dirname "$dst")"
  
  # Create the symlink
  ln -s "$src" "$dst"
  echo -e "  ${GREEN}✓${NC} $name"
  INSTALLED+=("$name")
}

# Helper: Create directory symlink
create_dir_symlink() {
  local src="$1"
  local dst="$2"
  local name="$3"
  
  if [ -d "$dst" ] && [ ! -L "$dst" ]; then
    if [ "$FORCE" = true ]; then
      echo -e "  ${YELLOW}⚠${NC} $name (backing up existing directory)"
      mv "$dst" "${dst}.backup.$(date +%Y%m%d_%H%M%S)"
    else
      echo -e "  ${YELLOW}⊘${NC} $name (directory exists, use --force)"
      SKIPPED+=("$name")
      return 0
    fi
  fi
  
  # Remove existing symlink if wrong target
  if [ -L "$dst" ]; then
    local current_target=$(readlink "$dst" 2>/dev/null || true)
    if [ "$current_target" = "$src" ]; then
      echo -e "  ${GREEN}✓${NC} $name (already linked)"
      INSTALLED+=("$name")
      return 0
    fi
    rm "$dst"
  fi
  
  ln -s "$src" "$dst"
  echo -e "  ${GREEN}✓${NC} $name"
  INSTALLED+=("$name")
}

echo -e "${BLUE}Installing Claude Code configuration...${NC}"
if [ "$LOCAL_INSTALL" = true ]; then
  create_dir_symlink "$SCRIPT_DIR/claude" "$TARGET_BASE/.claude" "claude/"
  create_symlink "$SCRIPT_DIR/claude.md" "$TARGET_BASE/CLAUDE.md" "CLAUDE.md"
else
  create_dir_symlink "$SCRIPT_DIR/claude" "$TARGET_BASE/.claude" "~/.claude"
  create_symlink "$SCRIPT_DIR/claude.md" "$TARGET_BASE/.claude/CLAUDE.md" "~/.claude/CLAUDE.md"
fi
echo ""

echo -e "${BLUE}Installing Cursor configuration...${NC}"
if [ "$LOCAL_INSTALL" = true ]; then
  create_dir_symlink "$SCRIPT_DIR/cursor" "$TARGET_BASE/.cursor" ".cursor/"
else
  # Cursor doesn't really have global config, it's project-based
  echo -e "  ${YELLOW}⊘${NC} Cursor (project-only, use --local)"
  SKIPPED+=("cursor")
fi
echo ""

echo -e "${BLUE}Installing GitHub Copilot configuration...${NC}"
if [ "$LOCAL_INSTALL" = true ]; then
  create_dir_symlink "$SCRIPT_DIR/github" "$TARGET_BASE/.github" ".github/"
else
  # Copilot can have global instructions
  mkdir -p "$TARGET_BASE/.github"
  create_symlink "$SCRIPT_DIR/github/copilot-instructions.md" "$TARGET_BASE/.github/copilot-instructions.md" "~/.github/copilot-instructions.md"
fi
echo ""

echo -e "${BLUE}Installing OpenAI Codex configuration...${NC}"
if [ "$LOCAL_INSTALL" = true ]; then
  create_dir_symlink "$SCRIPT_DIR/codex" "$TARGET_BASE/.codex" ".codex/"
  create_symlink "$SCRIPT_DIR/agents.md" "$TARGET_BASE/AGENTS.md" "AGENTS.md"
else
  create_dir_symlink "$SCRIPT_DIR/codex" "$TARGET_BASE/.codex" "~/.codex"
  create_symlink "$SCRIPT_DIR/agents.md" "$TARGET_BASE/.codex/AGENTS.md" "~/.codex/AGENTS.md"
fi
echo ""

echo -e "${BLUE}Installing shared resources...${NC}"
if [ "$LOCAL_INSTALL" = false ]; then
  # Global: create ~/.ai-shared symlink
  create_dir_symlink "$SCRIPT_DIR/shared" "$TARGET_BASE/.ai-shared" "~/.ai-shared"
fi
echo ""

# Summary
echo -e "${BLUE}========================${NC}"
echo -e "${GREEN}Installation complete!${NC}"
echo ""

if [ ${#INSTALLED[@]} -gt 0 ]; then
  echo -e "${GREEN}Installed (${#INSTALLED[@]}):${NC}"
  for item in "${INSTALLED[@]}"; do
    echo "  ✓ $item"
  done
  echo ""
fi

if [ ${#SKIPPED[@]} -gt 0 ]; then
  echo -e "${YELLOW}Skipped (${#SKIPPED[@]}):${NC}"
  for item in "${SKIPPED[@]}"; do
    echo "  ⊘ $item"
  done
  echo ""
fi

echo -e "${BLUE}Next steps:${NC}"
if [ "$LOCAL_INSTALL" = true ]; then
  echo "  1. Edit files in $SCRIPT_DIR/"
  echo "  2. Changes apply to this project only"
  echo "  3. Commit .ai/ directory to git"
else
  echo "  1. Edit files in ~/.ai/"
  echo "  2. Changes apply globally to all projects"
  echo "  3. Run 'ai-dotfiles --local' in specific projects if needed"
fi
echo ""
