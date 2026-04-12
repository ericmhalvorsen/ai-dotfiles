# Usage Guide

## Global Installation (Recommended)

Install once, use everywhere:

```bash
# Clone to ~/.ai
git clone https://github.com/YOUR_USERNAME/ai-dotfiles.git ~/.ai

# Run installer
cd ~/.ai && ./install.sh

# Verify
ls -la ~/.claude  # Should show skills, commands, settings.json
ls -la ~/.codex   # Should show skills, prompts, config.toml
ls .cursor/rules  # Should show .mdc files from skills/
```

## Project Installation

For team-shared configuration:

```bash
# In your project root
git clone https://github.com/YOUR_USERNAME/ai-dotfiles.git .ai
./.ai/install.sh --local

# Commit the .ai directory
git add .ai
git commit -m "Add AI configuration"
```

## Understanding the Structure

### Unified Sources (Edit These)

```
~/.ai/
├── skills/              # Universal skills (edit once, applies everywhere)
│   ├── code-review/
│   │   └── skill.md    # Available in Claude, Cursor, and Codex
│   └── debugging/
│       └── skill.md
├── commands/            # Universal commands
│   └── commit.md       # Available as /commit in Claude, prompt in Codex
├── mcp/
│   └── servers.yaml    # MCP servers (converted to each tool's format)
└── AGENTS.md           # Universal instructions (all tools read this)
```

### Tool-Specific Adapters (Rarely Edit)

```
~/.ai/adapters/
├── claude/
│   ├── settings.json   # Claude-specific settings (permissions, hooks)
│   └── commands/       # Claude-only commands
├── cursor/
│   └── rules/          # Cursor-only rules
└── codex/
    ├── config.toml     # Codex-specific config
    └── prompts/        # Codex-only prompts
```

## Adding a New Skill

The killer feature: define once, use everywhere.

### 1. Create the Skill

```bash
mkdir -p ~/.ai/skills/my-skill
vim ~/.ai/skills/my-skill/skill.md
```

Use this template:
```markdown
---
name: my-skill
description: What this skill does
tags: [tag1, tag2]
---

# My Skill

## When to Use
Describe when to activate this skill.

## Process
1. Step one
2. Step two
3. Step three

## Output Format
Describe expected output format.
```

### 2. Propagate to All Tools

```bash
cd ~/.ai && ./install.sh
```

This creates:
- `~/.claude/skills/my-skill/SKILL.md` (hard link)
- `.cursor/rules/my-skill.mdc` (symlink with .mdc extension)
- `~/.codex/skills/my-skill/skill.md` (hard link)

### 3. Use It

**Claude**: "Use the my-skill skill to..."

**Cursor**: The skill is always available as a rule

**Codex**: "Apply my-skill to..."

## Adding MCP Servers

Edit `~/.ai/mcp/servers.yaml`:

```yaml
servers:
  my-server:
    type: local
    command: npx
    args: ["-y", "@org/mcp-server"]
```

Run `./install.sh` to convert to each tool's format:
- Claude: Updates `settings.json`
- Cursor: Creates `mcp.json`
- Codex: Updates `config.toml`

## Customization

### Global vs Project

**Global** (`~/.ai/`):
- Applies to all projects
- Use for personal preferences
- Store in your dotfiles repo

**Project** (`.ai/` in project):
- Applies to specific project only
- Use for team standards
- Commit to project git

### Tool-Specific Overrides

Need something only for one tool?

```bash
# Claude-only setting
vim ~/.ai/adapters/claude/settings.json

# Cursor-only rule
vim ~/.ai/adapters/cursor/rules/editor-preferences.mdc

# Codex-only config
vim ~/.ai/adapters/codex/config.toml
```

### Local Overrides (Gitignored)

Create `.local` files that aren't committed:

```bash
# Claude local settings
cp ~/.ai/adapters/claude/settings.json ~/.ai/adapters/claude/settings.local.json
vim ~/.ai/adapters/claude/settings.local.json
```

These are in `.gitignore` by default.

## File Formats Reference

### Skills: Universal Markdown + YAML

```markdown
---
name: skill-name
description: What it does
tags: [review, debug]
---

# Skill Title

## When to Use
...

## Process
...
```

Works in all tools. Install script handles the mapping.

### Claude: JSON

`adapters/claude/settings.json`:
```json
{
  "permissions": {
    "allow": ["Bash(npm run *)"],
    "deny": ["Read(./.env)"]
  },
  "hooks": {
    "postEdit": [{"command": "npm run lint"}]
  }
}
```

### Cursor: MDC (Markdown + YAML)

`adapters/cursor/rules/my-rule.mdc`:
```yaml
---
alwaysApply: true
description: Rule description
globs: ["*.ts"]
---
# Rule content
```

### Codex: TOML

`adapters/codex/config.toml`:
```toml
[features]
multi_agent = true

[permissions]
allow = ["npm run *"]
deny = ["sudo *"]
```

## Commands

### Install
```bash
./install.sh              # Global install
./install.sh --local      # Project install
./install.sh --force      # Overwrite existing
./install.sh --verbose    # Detailed output
```

### Update
```bash
cd ~/.ai && git pull
./install.sh
```

### Add Skill
```bash
mkdir -p ~/.ai/skills/new-skill
vim ~/.ai/skills/new-skill/skill.md
cd ~/.ai && ./install.sh
```

## Troubleshooting

### "File exists" errors

Use `--force` to backup and overwrite:
```bash
./install.sh --force
```

### Skills not appearing in Cursor

Check that `.cursor/rules/*.mdc` files exist:
```bash
ls -la .cursor/rules/
```

The install script should create symlinks like:
```
.cursor/rules/code-review.mdc -> ~/.ai/skills/code-review/skill.md
```

### Claude not loading skills

Check the structure:
```bash
ls -la ~/.claude/skills/code-review/
# Should show: SKILL.md
```

### Changes not applying

1. Re-run installer: `cd ~/.ai && ./install.sh`
2. Restart your AI tool
3. Check file syntax is valid

## How It Works

The install script uses **hard links and symlinks**:

```bash
# Same content, different locations
ln ~/.ai/skills/code-review/skill.md ~/.claude/skills/code-review/SKILL.md
ln ~/.ai/skills/code-review/skill.md .cursor/rules/code-review.mdc
ln ~/.ai/skills/code-review/skill.md ~/.codex/skills/code-review/skill.md
```

Edit `~/.ai/skills/code-review/skill.md` once, all tools see the update.

## Best Practices

1. **Define skills in `skills/`** - Universal format works everywhere
2. **Use `adapters/` for tool-specific tweaks** - Don't clutter unified sources
3. **Version control your dotfiles** - Track changes to AI standards
4. **Test in each tool** - Verify skills work as expected
5. **Keep AGENTS.md updated** - This is the universal context

## Uninstalling

```bash
# Remove symlinks (keeps ~/.ai directory)
rm ~/.claude ~/.codex .cursor/rules

# Or remove everything
rm -rf ~/.ai ~/.claude ~/.codex
```
