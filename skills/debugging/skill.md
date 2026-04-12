---
name: debugging
description: Systematic debugging workflow for tracking down issues
tags: [debug, troubleshoot, investigate]
---

# Debugging Skill

## When to Use

Activate this skill when:
- Application crashes or errors occur
- Unexpected behavior is observed
- Tests are failing intermittently
- Performance degrades

## Debugging Process

### 1. Information Gathering
- [ ] Reproduce the issue consistently
- [ ] Check recent changes (git log, deployments)
- [ ] Review error messages and stack traces
- [ ] Check logs (application, system, browser)
- [ ] Verify environment (versions, config, env vars)

### 2. Hypothesis Formation
- [ ] Identify what changed recently
- [ ] Consider likely failure points
- [ ] Check for common patterns (null references, type mismatches)
- [ ] Review similar past issues

### 3. Testing Hypotheses
- [ ] Add logging at key points
- [ ] Use debugger or breakpoints
- [ ] Isolate the failing component
- [ ] Test with minimal reproduction case

### 4. Fix Implementation
- [ ] Address root cause, not symptoms
- [ ] Add regression test
- [ ] Verify fix doesn't break other functionality
- [ ] Document the issue and solution

## Common Patterns

### JavaScript/TypeScript
- Check for `undefined` or `null` before accessing properties
- Verify async/await error handling
- Check type assertions and casts
- Review closure and scope issues

### Python
- Check for None before accessing attributes
- Verify exception handling
- Check mutable default arguments
- Review import cycles

### General
- Race conditions in async code
- Memory leaks in long-running processes
- Configuration/environment mismatches
- Dependency version conflicts

## Tools

- **Logging**: Add structured logs at key points
- **Debugger**: Use IDE debugger or pdb/node inspect
- **Git bisect**: Find which commit introduced the issue
- **Tests**: Write minimal reproduction test
