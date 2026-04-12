---
name: devils-advocate
description: >
  Adversarial analysis for challenging plans, proposals, architecture decisions, and code before
  execution. Invoke with /devils-advocate or auto-triggers during planning/thinking modes.
  Configurable intensity: quick (1-pass), balanced (3 rounds), deep (5 rounds with forced disagreement).
tags: [review, planning, architecture]
---

# Devil's Advocate — Adversarial Analysis

Structured adversarial review that challenges proposals, surfaces hidden assumptions, and stress-tests decisions before committing.

## When to Use

**Explicit invocation:** `/devils-advocate [quick|balanced|deep]`

**Auto-trigger:** Planning/design tasks, sequential-thinking MCP engaged, user asks "what could go wrong", "red team this"

## Analysis Protocol

### Phase 1: First Principles
1. What problem is actually being solved?
2. What are the core assumptions?
3. What constraints are real vs. inherited?
4. Are there simpler ways to achieve the same goal?

### Phase 2: Red Team / Blue Team Debate

**Red Team** (Attacker): Find genuine weaknesses. Must raise at least one substantive concern per round. Exit early if no genuine issues.

**Blue Team** (Defender): Defend or concede with evidence.

**Intensity Levels:**

| Level | Rounds | Forced Disagreement | Early Exit |
|-------|--------|---------------------|------------|
| quick | 1 | No | N/A |
| balanced | 3 | Yes, rounds 1-2 | Consensus in round 3 |
| deep | 5 | Yes, rounds 1-4 | Consensus in round 5 |

**Priority Order:**
1. Correctness — does it actually solve the problem?
2. Security — can it be exploited?
3. Data integrity — can it corrupt/lose data?
4. Performance — will it scale?
5. Reliability — failure modes, error handling
6. Maintainability — complexity, coupling
7. Testing gaps — what isn't covered?

### Phase 3: Assumption Audit

For each assumption:
- State it explicitly
- Rate confidence (high/medium/low)
- What happens if wrong?
- How to verify it?

### Phase 4: Competing Alternatives

Generate 2-3 genuinely viable alternatives. For each:
- How it differs
- What it does better
- What it sacrifices
- Why original might still win

## Output Format

```
## Devil's Advocate Review [{intensity}]

### Problem Statement
[1-2 sentences — what are we actually solving?]

### Key Assumptions
| # | Assumption | Confidence | If wrong... |
|---|-----------|------------|-------------|
| 1 | ... | high/med/low | ... |

### Debate Summary
**Round {n}:**
- Red Team: [concern]
- Blue Team: [defense or concession]
- Outcome: [resolved / open / conceded]

### Surviving Critiques
| # | Issue | Severity | Mitigation |
|---|-------|----------|------------|
| 1 | ... | critical/high/medium/low | ... |

### Alternatives Considered
[Genuinely viable alternatives only]

### Recommendation
[Proceed / Proceed with mitigations / Reconsider / Stop]
[1-2 sentences on why]
```

## Rules

- Be specific — point to exact code, queries, or design elements
- Every criticism must include a fix direction
- Do not invent problems — evidence-based only
- Do not manufacture critiques to fill rounds
- Balance risk vs. velocity — don't block indefinitely
- Filter weak objections — only surface what matters
