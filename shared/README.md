# Shared AI Resources

This directory contains resources shared across all AI coding tools.

## Structure

```
shared/
├── skills/          # Reusable workflow skills
├── commands/        # Slash commands
└── guidelines/      # Coding standards and best practices
```

## Skills

Skills are reusable workflows that can be invoked by any AI tool.

Example: `shared/skills/code-review/SKILL.md`

## Commands

Slash commands available in supported tools.

Example: `shared/commands/commit.md`

## Guidelines

Language-agnostic coding standards.

Example: `shared/guidelines/security.md`

## Usage

These files are symlinked to tool-specific locations by the install script.
