# ai-dotfiles

> **Unified AI coding configuration for Claude, Cursor, and Codex**
> 
> One skill definition. All agents. Zero duplication.

## The Problem

You have 3 AI coding tools, each with different config locations and formats:
- **Claude Code**: Skills in `.claude/skills/*/SKILL.md`, rules in `.claude/rules/`
- **Cursor**: Rules in `.cursor/rules/*.mdc`  
- **OpenAI Codex**: Skills in `.codex/skills/`

Add a skill to Claude? You have to manually copy/adapt it for Cursor and Codex. Update it? Do it 3 times.

## The Solution

Define once in `skills/` and `rules/`. The install script maps it everywhere:

```
skills/
├── devils-advocate/
│   └── skill.md          ← Detailed skill with protocols & intensity levels
├── code-review/
│   └── skill.md          ← Multi-phase analysis skill
└── debugging/
    └── skill.md          ← Systematic debugging workflow

rules/
├── caveman.md            ← Communication style with intensity levels
└── core.md               ← Always-on constraints

Install script creates:
~/.claude/skills/         → skills/ (SKILL.md format)
~/.claude/rules/          → rules/ (rule format)
.cursor/rules/            → skills/ + rules/ (.mdc format)
~/.codex/skills/          → skills/ (Codex format)
```

## Quick Start

```bash
# Global install (recommended)
git clone https://github.com/YOUR_USERNAME/ai-dotfiles.git ~/.ai
cd ~/.ai && ./install.sh

# Or project-specific
git clone https://github.com/YOUR_USERNAME/ai-dotfiles.git .ai
./.ai/install.sh --local
```

## What Gets Installed

The install script intelligently maps unified definitions to each tool:

| Unified Source | Claude | Cursor | Codex |
|----------------|--------|--------|-------|
| `skills/*/` | `~/.claude/skills/*/` | `.cursor/rules/*.mdc` | `~/.codex/skills/*/` |
| `commands/*.md` | `~/.claude/commands/*.md` | (as rules) | `~/.codex/prompts/*.md` |
| `mcp/servers.yaml` | `~/.claude/settings.json` | `.cursor/mcp.json` | `~/.codex/config.toml` |
| `adapters/claude/settings.json` | `~/.claude/settings.json` | - | - |
| `adapters/cursor/rules/` | - | `.cursor/rules/` | - |
| `adapters/codex/config.toml` | - | - | `~/.codex/config.toml` |

## Directory Structure

```
~/.ai/
├── README.md
├── install.sh              # Smart installer
├── skills/                 # Universal skills (define once)
│   ├── code-review/
│   │   └── skill.md
│   ├── debugging/
│   │   └── skill.md
│   └── testing/
│       └── skill.md
├── commands/               # Universal commands
│   ├── commit.md
│   └── test.md
├── mcp/                    # Unified MCP configuration
│   └── servers.yaml
├── adapters/               # Tool-specific adapter configs
│   ├── claude/
│   │   ├── settings.json   # Claude-specific settings
│   │   └── commands/       # Claude-only commands
│   ├── cursor/
│   │   └── rules/          # Cursor-only rules
│   └── codex/
│       ├── config.toml     # Codex-specific config
│       └── prompts/        # Codex-only prompts
└── AGENTS.md               # Universal instructions (all tools read this)
```

## Universal Skill Format

Skills use a common markdown format with YAML frontmatter that works across all tools:

```markdown
---
name: code-review
description: Review code for quality and best practices
tags: [review, quality]
---

# Code Review Skill

## When to Use
Use this skill when reviewing code for:
- Logic errors
- Security issues  
- Performance problems
- Maintainability concerns

## Process
1. Read the code carefully
2. Check against project standards
3. Identify issues with severity (critical/warning/suggestion)
4. Provide specific, actionable feedback

## Output Format
```
[CRITICAL] Issue description
[WARNING] Issue description  
[SUGGESTION] Improvement idea
```
```

The install script handles the rest:
- **Claude**: Creates `~/.claude/skills/code-review/SKILL.md`
- **Cursor**: Creates `.cursor/rules/code-review.mdc` (symlink with extension handling)
- **Codex**: Creates `~/.codex/skills/code-review/skill.md`

## MCP Server Management

Define MCP servers once in `mcp/servers.yaml`:

```yaml
servers:
  fetch:
    type: http
    url: https://mcp-fetch.example.com
    
  sequential-thinking:
    type: local
    command: npx
    args: [-y, @anthropic-ai/mcp-sequentialthinking]
```

The install script converts this to each tool's format:
- **Claude**: Updates `settings.json` with MCP servers
- **Cursor**: Creates `.cursor/mcp.json`
- **Codex**: Updates `config.toml` with MCP servers

## Commands

### Global Install
```bash
./install.sh
```

Creates symlinks in your home directory:
- `~/.claude/` → `~/.ai/adapters/claude/`
- `~/.claude/skills/` → `~/.ai/skills/`  
- `~/.codex/` → `~/.ai/adapters/codex/`
- `~/.codex/skills/` → `~/.ai/skills/`
- `.cursor/rules/` → `~/.ai/skills/` (with .mdc extension mapping)

### Project Install
```bash
./install.sh --local
```

Creates symlinks in current project:
- `./.claude/` → `./.ai/adapters/claude/`
- `./.cursor/rules/` → `./.ai/skills/`
- `./.codex/` → `./.ai/adapters/codex/`
- `./AGENTS.md` → `./.ai/AGENTS.md`

### Force Overwrite
```bash
./install.sh --force
```

Backs up existing configs and replaces with symlinks.

## Adding a New Skill

1. Create skill definition:
```bash
mkdir -p ~/.ai/skills/my-skill
vim ~/.ai/skills/my-skill/skill.md
```

2. Re-run installer to propagate:
```bash
cd ~/.ai && ./install.sh
```

3. Available immediately in all tools!

## How It Works

The install script uses **symlinks with extension mapping**:

```bash
# For tools that use same content, different extension:
ln -s ~/.ai/skills/code-review/skill.md ~/.claude/skills/code-review/SKILL.md
ln -s ~/.ai/skills/code-review/skill.md .cursor/rules/code-review.mdc
ln -s ~/.ai/skills/code-review/skill.md ~/.codex/skills/code-review/skill.md
```

Same file content, three locations, three tools. Edit once, apply everywhere.

## Tool-Specific Overrides

Need something specific to one tool? Use the adapters:

```bash
# Claude-only setting
vim ~/.ai/adapters/claude/settings.json

# Cursor-only rule  
vim ~/.ai/adapters/cursor/rules/editor-preferences.mdc

# Codex-only config
vim ~/.ai/adapters/codex/config.toml
```

## Best Practices

1. **Put universal stuff in `skills/` and `commands/`** - Works everywhere
2. **Put tool-specific stuff in `adapters/<tool>/`** - Only that tool sees it
3. **Use the install script** - Don't manually create symlinks
4. **Version control your dotfiles** - Track changes to AI standards
5. **Test in each tool** - Verify skills work as expected

## Troubleshooting

### "File exists" errors
Use `--force` to backup and overwrite:
```bash
./install.sh --force
```

### Skills not showing up
1. Check symlink: `ls -la ~/.claude/skills/`
2. Verify file format is valid markdown
3. Restart the AI tool

### Cursor not loading .mdc files
Cursor requires `.mdc` extension. The install script handles this automatically.

## Inspired By

- [notdp/.dotfiles](https://github.com/notdp/.dotfiles) - Multi-agent symlink approach
- [wdonofrio/ai-config](https://github.com/wdonofrio/ai-config) - Shared/tool-specific split
- [universal-ai-config](https://github.com/fabis94/universal-ai-config) - Format conversion concept

## License

MIT - Share your AI config like you share your dotfiles.
