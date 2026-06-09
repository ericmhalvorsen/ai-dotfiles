# ai-dotfiles

dotfiles for ai coding tools. skills and rules. installs to ~/.ai and symlinks to claude code, opencode, cursor, codex.

## Install

```
git clone https://github.com/yourusername/ai-dotfiles
cd ai-dotfiles
./install.sh
```

edit files in ~/.ai, they propagate everywhere.

## Structure

```
~/.ai/
├── AGENTS.md      # system prompt, always loaded
├── skills/        # loaded on demand
└── rules/         # coding rules
```

## Skills

caveman - compressed communication mode
diagnose - bug diagnosis loop
grill-with-docs - interview about designs until shared understanding
handoff - compact conversation for session handoff
tdd - test-driven development workflow
user-expertise - collaboration protocol and design principles

## Updating

edit files in ~/.ai directly, or update this repo and rerun install.sh.
