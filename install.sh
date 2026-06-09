#!/bin/bash
# ai-dotfiles install script
# Source of truth: ~/.ai/
# Symlinks to: ~/.opencode/skills, ~/.claude/skills, and tool-specific locations

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
FORCE=false
VERBOSE=false
NON_INTERACTIVE=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --force)
      FORCE=true
      shift
      ;;
    --verbose)
      VERBOSE=true
      shift
      ;;
    --non-interactive)
      NON_INTERACTIVE=true
      shift
      ;;
    --help)
      cat << 'EOF'
Usage: ./install.sh [OPTIONS]

Install unified AI configuration. Source of truth is ~/.ai/
Symlinks skills to selected AI tools

Options:
  --force              Overwrite existing configs without prompting
  --verbose            Show detailed output
  --non-interactive    Skip tool selection, install to all detected tools
  --help               Show this help message

Examples:
  ./install.sh                    # Interactive install
  ./install.sh --non-interactive  # Install to all detected tools
  ./install.sh --force            # Overwrite existing
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

AI_DIR="$HOME/.ai"

echo -e "${BLUE}🌐 ai-dotfiles installation${NC}"
echo -e "Source: ${GREEN}$SCRIPT_DIR${NC}"
echo -e "Target: ${GREEN}$AI_DIR${NC}"
echo ""

# Detect installed tools
detect_tools() {
  local tools=()
  
  # Claude Code
  if [ -d "$HOME/.claude" ] || command -v claude &> /dev/null; then
    tools+=("claude")
  fi
  
  # OpenCode
  if [ -d "$HOME/.opencode" ] || command -v opencode &> /dev/null; then
    tools+=("opencode")
  fi
  
  # Cursor
  if [ -d "$HOME/.cursor" ]; then
    tools+=("cursor")
  fi
  
  # Codex
  if [ -d "$HOME/.codex" ]; then
    tools+=("codex")
  fi
  
  # Hermes
  if [ -d "$HOME/.hermes" ] || command -v hermes &> /dev/null; then
    tools+=("hermes")
  fi
  
  echo "${tools[@]}"
}

# Interactive tool selection
select_tools() {
  local detected=($1)
  local selected=()
  local status=()
  
  # Initialize all as selected
  for tool in "${detected[@]}"; do
    selected+=("$tool")
    status+=("✓")
  done
  
  if [ ${#detected[@]} -eq 0 ]; then
    echo -e "${YELLOW}No AI tools detected. Installing to ~/.ai only.${NC}"
    echo ""
    return
  fi
  
  echo -e "${BLUE}Detected AI tools:${NC}"
  echo ""
  
  local current=0
  local total=${#detected[@]}
  
  while true; do
    # Clear previous menu
    for ((i=0; i<total+3; i++)); do
      echo -ne "\033[1A\033[2K"
    done
    
    echo -e "${BLUE}Select tools to install (use ↑↓ arrows, Space to toggle, Enter to confirm):${NC}"
    echo ""
    
    # Display menu
    for ((i=0; i<total; i++)); do
      local tool="${detected[$i]}"
      local marker=""
      if [ $i -eq $current ]; then
        marker="→"
      else
        marker=" "
      fi
      
      local check="${status[$i]}"
      if [ "$check" = "✓" ]; then
        echo -e "  $marker ${GREEN}✓${NC} $tool"
      else
        echo -e "  $marker ${RED}✗${NC} $tool"
      fi
    done
    
    echo ""
    
    # Read key
    read -rsn1 key
    
    case $key in
      $'\x1b')
        read -rsn2 -t 0.1 rest
        case $rest in
          '[A') # Up arrow
            current=$(( (current - 1 + total) % total ))
            ;;
          '[B') # Down arrow
            current=$(( (current + 1) % total ))
            ;;
        esac
        ;;
      ' ') # Space - toggle
        if [ "${status[$current]}" = "✓" ]; then
          status[$current]="✗"
        else
          status[$current]="✓"
        fi
        ;;
      '') # Enter - confirm
        break
        ;;
    esac
  done
  
  # Build selected array
  for ((i=0; i<total; i++)); do
    if [ "${status[$i]}" = "✓" ]; then
      selected+=("${detected[$i]}")
    fi
  done
  
  echo -e "${GREEN}Selected:${NC} ${selected[*]}"
  echo ""
  
  # Export selected tools
  SELECTED_TOOLS=("${selected[@]}")
}

# Track operations
INSTALLED=()
SKIPPED=()

# Helper: Backup existing
backup_if_exists() {
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

# Detect tools
DETECTED_TOOLS=($(detect_tools))

# Select tools interactively
if [ "$NON_INTERACTIVE" = false ]; then
  select_tools "${DETECTED_TOOLS[*]}"
else
  SELECTED_TOOLS=("${DETECTED_TOOLS[@]}")
  echo -e "${BLUE}Non-interactive mode. Installing to:${NC} ${SELECTED_TOOLS[*]}"
  echo ""
fi

# Step 1: Copy ai-dotfiles to ~/.ai
echo -e "${BLUE}Installing to ~/.ai...${NC}"

if [ -d "$AI_DIR" ] && [ ! -L "$AI_DIR" ]; then
  if [ "$FORCE" = true ]; then
    backup_if_exists "$AI_DIR"
  else
    echo -e "${YELLOW}~/.ai exists. Use --force to replace.${NC}"
    exit 1
  fi
fi

# Initialize submodules if needed
if [ -f "$SCRIPT_DIR/.gitmodules" ]; then
  echo -e "${BLUE}Initializing submodules...${NC}"
  cd "$SCRIPT_DIR"
  git submodule update --init --recursive 2>/dev/null || true
  cd - > /dev/null
fi

# Copy the entire ai-dotfiles structure to ~/.ai
mkdir -p "$AI_DIR"
cp -r "$SCRIPT_DIR/skills" "$AI_DIR/"
cp -r "$SCRIPT_DIR/rules" "$AI_DIR/" 2>/dev/null || true
cp -r "$SCRIPT_DIR/mcp" "$AI_DIR/" 2>/dev/null || true
cp -r "$SCRIPT_DIR/adapters" "$AI_DIR/" 2>/dev/null || true

# Copy AGENTS.md and add installation metadata
cp "$SCRIPT_DIR/AGENTS.md" "$AI_DIR/AGENTS.md"
INSTALL_NOTE="<!-- Installed from $SCRIPT_DIR with command: $0 $@ on $(date -Iseconds) -->"
# Remove any existing install note, then add new one at the top
sed -i '/^<!-- Installed from/d' "$AI_DIR/AGENTS.md"
sed -i "1i\\$INSTALL_NOTE" "$AI_DIR/AGENTS.md"

echo -e "${GREEN}  ✓${NC} Copied ai-dotfiles to ~/.ai"
INSTALLED+=("~/.ai")

# Install to selected tools
for tool in "${SELECTED_TOOLS[@]}"; do
  case $tool in
    claude)
      echo ""
      echo -e "${BLUE}Installing to Claude Code...${NC}"
      
      CLAUDE_DIR="$HOME/.claude"
      mkdir -p "$CLAUDE_DIR"
      symlink "$AI_DIR/skills" "$CLAUDE_DIR/skills" "~/.claude/skills"
      symlink "$AI_DIR/AGENTS.md" "$CLAUDE_DIR/CLAUDE.md" "~/.claude/CLAUDE.md (-> AGENTS.md)"
      ;;
      
    opencode)
      echo ""
      echo -e "${BLUE}Installing to OpenCode...${NC}"
      
      OPENCODE_DIR="$HOME/.opencode"
      mkdir -p "$OPENCODE_DIR"
      symlink "$AI_DIR/skills" "$OPENCODE_DIR/skills" "~/.opencode/skills"
      ;;
      
    cursor)
      echo ""
      echo -e "${BLUE}Installing to Cursor...${NC}"
      
      CURSOR_DIR="$HOME/.cursor"
      
      if [ -d "$AI_DIR/skills" ]; then
        mkdir -p "$CURSOR_DIR/rules"
        for skill_dir in "$AI_DIR/skills"/*; do
          if [ -d "$skill_dir" ]; then
            skill_name=$(basename "$skill_dir")
            if [ -f "$skill_dir/skill.md" ]; then
              ln -sf "$skill_dir/skill.md" "$CURSOR_DIR/rules/${skill_name}.mdc" 2>/dev/null || true
              echo -e "${GREEN}  ✓${NC} Rule: $skill_name.mdc"
              INSTALLED+=("cursor:$skill_name")
            fi
          fi
        done
      fi
      ;;
      
    codex)
      echo ""
      echo -e "${BLUE}Installing to Codex...${NC}"
      
      CODEX_DIR="$HOME/.codex"
      symlink "$AI_DIR/AGENTS.md" "$CODEX_DIR/AGENTS.md" "~/.codex/AGENTS.md"
      
      if [ -d "$AI_DIR/skills" ]; then
        for skill_dir in "$AI_DIR/skills"/*; do
          if [ -d "$skill_dir" ]; then
            skill_name=$(basename "$skill_dir")
            if [ -f "$skill_dir/skill.md" ]; then
              mkdir -p "$CODEX_DIR/skills/$skill_name"
              ln -sf "$skill_dir/skill.md" "$CODEX_DIR/skills/$skill_name/skill.md" 2>/dev/null || true
              echo -e "${GREEN}  ✓${NC} Skill: $skill_name"
              INSTALLED+=("codex:$skill_name")
            fi
          fi
        done
      fi
      ;;
      
    hermes)
      echo ""
      echo -e "${BLUE}Installing to Hermes...${NC}"
      
      HERMES_DIR="$HOME/.hermes"
      mkdir -p "$HERMES_DIR"
      symlink "$AI_DIR/skills" "$HERMES_DIR/skills" "~/.hermes/skills"
      ;;
  esac
done

# Summary
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

if [ ${#SKIPPED[@]} -gt 0 ]; then
  echo -e "${YELLOW}Skipped (${#SKIPPED[@]} items):${NC}"
  for item in "${SKIPPED[@]}"; do
    echo "  ⊘ $item"
  done
  echo ""
fi

echo -e "${BLUE}Structure:${NC}"
echo "  ~/.ai/                    # Source of truth"
echo "  ├── AGENTS.md             # Universal agent instructions"
echo "  ├── skills/               # All skills"
echo "  └── rules/                # Coding rules"
echo ""

echo -e "${BLUE}Next steps:${NC}"
echo "  • Edit files in ~/.ai/ to update all tools"
echo "  • Changes apply globally to all projects"
echo "  • Run ./install.sh again after adding new skills"
echo ""
