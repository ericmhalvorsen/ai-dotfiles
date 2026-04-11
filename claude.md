# CLAUDE.md - Claude Code Context

> **Instructions for Claude Code**
> 
> Claude Code reads this file automatically from ~/.claude/CLAUDE.md (global) or ./CLAUDE.md (project)

## My Context

### Background
- [Your professional background]
- [Your domain expertise]
- [Technologies you work with]

### Preferences
- Code style: [concise/verbose/documented]
- Communication: [direct/collaborative/teaching]
- Error handling: [strict/permissive]

## Workflow

### Before Starting
1. Check for existing patterns in the codebase
2. Read relevant documentation
3. Understand the scope

### While Working
1. Follow existing conventions
2. Add tests for new code
3. Update documentation
4. Run linters and type checkers

### Before Finishing
1. Verify tests pass
2. Check for secrets in code
3. Ensure documentation is updated
4. Review for edge cases

## Commands

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

## Code Quality Standards

### TypeScript
- Strict mode enabled
- No `any` types
- Explicit return types on exports

### Testing
- Unit tests for utilities
- Integration tests for APIs
- E2E tests for critical paths

### Documentation
- JSDoc for public APIs
- README updates for features
- CHANGELOG for releases

## Security

### Never
- Hardcode secrets
- Log sensitive data
- Skip input validation
- Use eval or similar

### Always
- Validate inputs with Zod
- Use parameterized queries
- Sanitize user content
- Follow OWASP guidelines

---

*This file is personalized for Claude Code. For team-wide standards, see AGENTS.md*
