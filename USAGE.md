# Usage Guide

## Global Installation (Recommended)

Install once, use everywhere:

```bash
# Clone to ~/.ai
git clone https://github.com/YOUR_USERNAME/ai-dotfiles.git ~/.ai

# Run installer
cd ~/.ai && ./install.sh

# Verify
ls -la ~/.claude  # Should show symlink to ~/.ai/claude
ls -la ~/.codex   # Should show symlink to ~/.ai/codex
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

## Customization

### 1. Edit Global Config

```bash
# Edit your global settings
vim ~/.ai/claude/settings.json    # Claude permissions, hooks
vim ~/.ai/codex/config.toml       # Codex config (TOML format!)
vim ~/.ai/claude.md               # Personal Claude instructions
```

### 2. Add Project-Specific Rules

```bash
# Create project-specific cursor rules
vim .ai/cursor/rules/project.mdc

# Create path-specific copilot instructions
vim .ai/github/instructions/api.instructions.md
```

### 3. Use Local Overrides (Gitignored)

```bash
# Create a local override that's not committed
cp ~/.ai/claude/settings.json ~/.ai/claude/settings.local.json
vim ~/.ai/claude/settings.local.json
```

## File Formats Reference

### Claude Code: JSON

`claude/settings.json`:
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

`cursor/rules/my-rule.mdc`:
```yaml
---
alwaysApply: true
description: Rule description
globs: ["*.ts"]
---
# Rule content in Markdown
```

### GitHub Copilot: Markdown + YAML

`github/copilot-instructions.md`:
```markdown
# Instructions

Your content here.
```

Path-specific:
```yaml
---
applyTo: "src/**/*.ts"
---
# TypeScript-specific rules
```

### OpenAI Codex: TOML

`codex/config.toml`:
```toml
[features]
multi_agent = true

[permissions]
allow = ["npm run *"]
deny = ["sudo *"]
```

## Troubleshooting

### "File exists" errors

Use `--force` to backup and overwrite:
```bash
./install.sh --force
```

### Symlinks not working on Windows

On Windows, you may need to:
1. Run as Administrator, OR
2. Enable Developer Mode in Windows Settings

### Changes not applying

1. Restart your AI tool
2. Check the symlink target: `ls -la ~/.claude`
3. Verify file syntax is correct

## Updating

```bash
# Update your dotfiles
cd ~/.ai && git pull

# Re-run installer to update symlinks
./install.sh
```

## Uninstalling

```bash
# Remove symlinks (keeps your ~/.ai directory)
rm ~/.claude ~/.codex ~/.cursor ~/.github/copilot-instructions.md

# Or remove everything
rm -rf ~/.ai ~/.claude ~/.codex
```
