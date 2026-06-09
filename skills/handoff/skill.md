---
name: handoff
description: >
  Compact the current conversation into a handoff document for another agent
  to pick up. Auto-activate when: (1) user says "handoff", "save state", "compact this",
  (2) conversation exceeds ~50 messages or context window is filling, (3) user mentions
  switching sessions, models, or agents, (4) work is being paused and will resume later,
  (5) complex multi-step work has been completed and needs documentation.
---

# Handoff

Write a handoff document summarizing the current conversation so a fresh agent can continue the work. Save to the temporary directory of the user's OS - not the current workspace.

## What to Include

- **Context**: What was the user trying to accomplish?
- **Progress**: What was completed? What's in progress?
- **Decisions**: What architectural or design decisions were made?
- **Blockers**: What's stuck? What needs user input?
- **Next Steps**: What should the next agent do first?
- **Key Files**: Which files are most relevant?

## Format

Use this structure:

```markdown
# Handoff: [Brief Description]

## Context
[What was the user trying to accomplish?]

## Progress
### Done
- [Completed items]

### In Progress
- [Current work]

### Blocked
- [What's stuck]

## Decisions
- [Key architectural/design decisions made]

## Next Steps
1. [First thing to do]
2. [Second thing]
3. [Third thing]

## Key Files
- `path/to/file1.ts` - [Why it matters]
- `path/to/file2.ts` - [Why it matters]

## Notes
[Any other context the next agent needs]
```

## Guidelines

- **Be specific**: Don't say "worked on the API" - say "added GET /users endpoint with pagination"
- **Include file paths**: The next agent needs to know where to look
- **Capture decisions**: Why did we choose X over Y?
- **Note blockers**: What's preventing progress?
- **Skip pleasantries**: This is for agents, not humans
- **Redact secrets**: Never include API keys, passwords, or PII

## When to Use

- User explicitly asks for handoff
- Conversation is getting long and context is degrading
- User wants to switch to a different model or agent
- Work is paused and will resume later

## When NOT to Use

- Simple Q&A conversations
- Quick bug fixes that are already done
- Exploratory conversations with no clear outcome
