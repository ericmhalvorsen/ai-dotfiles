# ai-dotfiles

dotfiles for ai coding tools. skills, commands, rules. installs to ~/.ai and symlinks to claude code, opencode, cursor, codex.

## install

```
git clone https://github.com/yourusername/ai-dotfiles
cd ai-dotfiles
./install.sh
```

that's it. edit files in ~/.ai, they propagate everywhere.

## structure

```
~/.ai/
├── AGENTS.md      # system prompt, always loaded
├── skills/        # loaded on demand
├── commands/      # slash commands
└── rules/         # coding rules
```

## skills

caveman - compressed communication mode
diagnose - bug diagnosis loop
grill-with-docs - interview about designs until shared understanding
handoff - compact conversation for session handoff
tdd - test-driven development workflow
user-expertise - collaboration protocol and design principles

## adding skills

```
mkdir ~/.ai/skills/my-skill
vim ~/.ai/skills/my-skill/skill.md
./install.sh
```

frontmatter with name and description is required. the description determines when the skill gets loaded.

## updating

edit files in ~/.ai directly, or update this repo and rerun install.sh.
