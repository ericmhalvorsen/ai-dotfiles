# GitHub Copilot Instructions

> **Project-specific instructions for GitHub Copilot**
> 
> Copilot reads this file automatically from `.github/copilot-instructions.md`

## Project Context

This is a [project type] built with [stack].

## Coding Standards

### General Principles
- Write clean, maintainable code
- Follow existing patterns in the codebase
- Add comments only when logic is complex
- Prefer composition over inheritance

### Language-Specific
- TypeScript: Strict mode enabled, no `any` types
- Python: Type hints required, follow PEP 8
- Go: Idiomatic Go, handle all errors
- Rust: Safe code preferred, document unsafe blocks

## Review Checklist

When Copilot suggests code, verify:
- [ ] Follows project conventions
- [ ] Includes error handling
- [ ] Has appropriate types
- [ ] No hardcoded secrets
- [ ] Matches existing patterns

## Common Patterns

### API Response Format
```typescript
{
  success: boolean;
  data?: T;
  error?: {
    message: string;
    code: string;
  }
}
```

## Testing
- Write tests for new functionality
- Use descriptive test names
- Follow AAA pattern (Arrange, Act, Assert)
- Mock external dependencies

## Performance
- Avoid unnecessary re-renders
- Use memoization when beneficial
- Lazy load heavy components
- Optimize database queries
