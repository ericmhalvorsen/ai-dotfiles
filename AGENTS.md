# AGENTS.md - Universal AI Instructions

> **Read by: Claude Code, Cursor, GitHub Copilot, OpenAI Codex, Windsurf, OpenCode**
> 
> This file provides context to all AI coding agents working in this repository.

## Agent Collaboration Protocol

**Default mode**: Interview the user about plans and designs until reaching shared understanding. Walk down each branch of the decision tree, resolving dependencies between decisions one-by-one. For complex designs with domain implications, load the **grill-with-docs** skill for structured documentation updates.

**Load these skills when triggered**:
- **user-expertise** — Identity, communication protocol, design principles, testing philosophy. Always reference for collaboration norms.
- **caveman** — Ultra-compressed communication. Use when user says "caveman mode", "less tokens", "be brief".
- **diagnose** — Disciplined bug diagnosis loop. Use when debugging, reporting bugs, or investigating failures.
- **tdd** — Test-driven development with red-green-refactor. Use when building features test-first.
- **handoff** — Compact conversation into handoff document. Use when user says "handoff" or "save state".
- **grill-with-docs** — Relentless interview about plans/designs until shared understanding. Use when user says "grill me", wants to stress-test a plan, or when exploring complex decisions. Default mode for design discussions.
- **last30days** — Research any topic across Reddit, X, YouTube, HN, Polymarket. Use when user says "last30days", wants current research, or needs to understand what people are saying about something right now.

## Project Identity

**Name**: [Your Project Name]
**Type**: [Web/Mobile/API/CLI/Library]
**Stack**: [Framework + Language + Key Dependencies]

## Quick Reference

### Build
```bash
npm run build
```

### Test
```bash
npm run test
```

### Lint
```bash
npm run lint
```

### Type Check
```bash
npm run typecheck
```

## Architecture

### Directory Structure
```
[Describe your project structure]
```

### Key Patterns
- **Pattern 1**: Description
- **Pattern 2**: Description

## Coding Standards

### Language & Style
- Language: [TypeScript/Python/Go/etc]
- Strict mode: enabled
- Indentation: 2 spaces
- Quotes: single

### Conventions
- Follow existing patterns
- Never use `any` types
- Always handle errors
- Validate inputs with Zod

## Tech Stack

### Core Dependencies
- Framework: [name@version]
- Database: [name]
- Testing: [framework]

### Development Tools
- Package manager: [npm/pnpm/yarn]
- Build tool: [Vite/Webpack/etc]
- Linter: [ESLint/Biome/etc]

## Testing Strategy
- Unit tests: [framework + location]
- Integration tests: [framework + location]
- Coverage threshold: 80%

## Security

### Never
- Hardcode secrets
- Skip input validation
- Use eval or similar

### Always
- Validate inputs
- Use parameterized queries
- Sanitize user content

## Common Tasks

### Adding a Feature
1. Check existing patterns
2. Implement with tests
3. Run lint/typecheck
4. Update docs

## References
- Documentation: [URL]
- API Reference: [URL]

---

*Keep this file under 200 lines for best results.*
