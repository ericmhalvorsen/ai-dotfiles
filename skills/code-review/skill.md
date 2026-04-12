---
name: code-review
description: Review code for quality, security, and best practices
tags: [review, quality, security]
---

# Code Review Skill

## When to Use

Activate this skill when:
- Reviewing pull requests
- Checking code before commit
- Auditing for security issues
- Ensuring project standards compliance

## Review Checklist

### Critical (Must Fix)
- [ ] Security vulnerabilities (SQL injection, XSS, etc.)
- [ ] Logic errors that could cause crashes
- [ ] Data loss risks
- [ ] Authentication/authorization flaws

### Warnings (Should Fix)
- [ ] Error handling gaps
- [ ] Performance issues (N+1 queries, unnecessary loops)
- [ ] Type safety violations
- [ ] Hardcoded secrets or credentials

### Suggestions (Nice to Have)
- [ ] Code style improvements
- [ ] Documentation additions
- [ ] Refactoring opportunities
- [ ] Test coverage gaps

## Output Format

Provide structured feedback:

```
[CRITICAL] <file>:<line> - Issue description + fix suggestion
[WARNING] <file>:<line> - Issue description + fix suggestion  
[SUGGESTION] <file>:<line> - Improvement idea
```

## Standards Reference

Check against project standards in AGENTS.md:
- TypeScript strict mode compliance
- Error handling patterns
- Testing requirements
- Security guidelines

## Process

1. Read the code thoroughly
2. Check against this checklist
3. Identify issues with specific line references
4. Provide actionable fix suggestions
5. Note any positive patterns (reinforce good habits)
