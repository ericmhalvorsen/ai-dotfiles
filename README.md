# ai-dotfiles

> **Universal AI coding configuration**
>
> Share commands, skills, and instructions across Claude Code, Cursor, GitHub Copilot, and OpenAI Codex.

## The Problem

Every AI coding tool uses different config locations:
- **Claude Code**: `~/.claude/` + `CLAUDE.md`
- **Cursor**: `.cursor/rules/*.mdc`
- **GitHub Copilot**: `.github/copilot-instructions.md`
- **OpenAI Codex**: `~/.codex/` + `AGENTS.md`

This repo provides a **single source of truth** that symlinks to all the right places.

## Quick Start

```bash
# Install globally (recommended)
git clone https://github.com/YOUR_USERNAME/ai-dotfiles.git ~/.ai
cd ~/.ai && ./install.sh

# Or install in a specific project
git clone https://github.com/YOUR_USERNAME/ai-dotfiles.git .ai
./.ai/install.sh --local
```

## What It Does

Symlinks from this repo to every tool's config location:

```
~/.claude/           → ~/.ai/claude/
~/.codex/            → ~/.ai/codex/
.cursor/rules/       → ~/.ai/cursor/rules/
.github/             → ~/.ai/github/
AGENTS.md            → ~/.ai/agents.md
CLAUDE.md            → ~/.ai/claude.md
```

Edit once in `~/.ai/`, apply everywhere.

## Directory Structure

```
~/.ai/
├── README.md
├── install.sh
├── shared/              # Common to all tools
│   ├── skills/          # Reusable skills
│   ├── commands/        # Slash commands
│   └── guidelines/      # Coding standards
├── claude/              # Claude Code specific
│   ├── settings.json    # Permissions, hooks, MCP
│   ├── skills/          # Claude-specific skills
│   └── commands/        # Claude slash commands
├── cursor/              # Cursor specific
│   └── rules/           # .mdc rule files
├── codex/               # Codex specific
│   ├── config.toml      # Codex config (TOML!)
│   ├── skills/          # Codex skills
│   └── prompts/         # Codex prompts
├── github/              # GitHub Copilot
│   ├── copilot-instructions.md      # Main instructions
│   └── instructions/                # Path-specific rules
│       └── typescript.instructions.md
├── agents.md            # Universal AGENTS.md (symlinked to AGENTS.md)
└── claude.md            # Universal CLAUDE.md (symlinked to CLAUDE.md)
```

## Supported Tools

| Tool | Global Config | Project Config | Status |
|------|--------------|----------------|---------|
| Claude Code | `~/.claude/` | `.claude/` | ✅ Full |
| Cursor | `~/.cursor/` | `.cursor/rules/` | ✅ Full |
| GitHub Copilot | `~/.github/` | `.github/` | ✅ Full |
| OpenAI Codex | `~/.codex/` | `.codex/` | ✅ Full |
| Windsurf | `~/.windsurf/` | `.windsurf/` | ✅ Full |

## File Formats

### Claude Code
- **Settings**: `.claude/settings.json` (JSON with schema)
- **Instructions**: `CLAUDE.md` (Markdown)
- **Skills**: `.claude/skills/*/SKILL.md`
- **Commands**: `.claude/commands/*.md`

### Cursor
- **Rules**: `.cursor/rules/*.mdc` (Markdown with YAML frontmatter)
- **Format**:
  ```yaml
  ---
  alwaysApply: true
  description: Rule description
  globs: ["*.ts", "*.tsx"]
  ---
  # Rule content
  ```

### GitHub Copilot
- **Main**: `.github/copilot-instructions.md` (Markdown)
- **Path-specific**: `.github/instructions/*.instructions.md`
- **Format**:
  ```yaml
  ---
  applyTo: "src/**/*.ts"
  ---
  # Rule content
  ```

### OpenAI Codex
- **Config**: `.codex/config.toml` (TOML, not JSON!)
- **Instructions**: `AGENTS.md` (Markdown)
- **Skills**: `.codex/skills/` (various formats)

## Customization

### Global vs Project

**Global** (`~/.ai/` + `install.sh`):
- Applies to all projects
- Use for personal preferences
- Stored in your home directory

**Project** (clone into `.ai/` + `install.sh --local`):
- Applies to specific project only
- Use for team standards
- Committed to git

### Personal Overrides

Create `.local` files that are gitignored:
- `claude/settings.local.json`
- `codex/config.local.toml`
- `cursor/rules/personal.local.mdc`

### Adding New Skills

1. Create in `shared/skills/my-skill/SKILL.md`
2. Run `./install.sh` to symlink everywhere
3. Available in all tools immediately

## Best Practices

1. **Keep shared/ for universal stuff** - Language-agnostic guidelines
2. **Use tool-specific folders** for format-specific features
3. **Don't duplicate** - One source of truth per concept
4. **Version control** - Track changes to your AI standards
5. **Test changes** - Verify rules work in each tool

## Inspired By

- [notdp/.dotfiles](https://github.com/notdp/.dotfiles) - Multi-agent symlink approach
- [wdonofrio/ai-config](https://github.com/wdonofrio/ai-config) - Shared/tool-specific split
- [dotagent](https://github.com/johnlindquist/dotagent) - Universal format conversion

## License

MIT - Share your AI config like you share your dotfiles.
