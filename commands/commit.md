---
name: commit
description: Generate conventional commit messages from staged changes
tags: [git, commit, workflow]
---

# Commit Command

## Usage

Run this command to generate a conventional commit message:

```
/commit
```

## Process

1. Check staged files: `git diff --cached --name-only`
2. Analyze the changes:
   - What files were modified?
   - What type of changes (feat, fix, refactor, docs, test, chore)?
   - What is the scope (component, module, area)?
3. Generate commit message following Conventional Commits:
   ```
   <type>(<scope>): <description>
   
   [optional body]
   
   [optional footer]
   ```

## Commit Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation only
- **style**: Code style (formatting, no logic change)
- **refactor**: Code change that neither fixes bug nor adds feature
- **perf**: Performance improvement
- **test**: Adding or correcting tests
- **chore**: Build process, dependencies, etc.

## Examples

```
feat(auth): add OAuth2 login support

fix(api): resolve race condition in user update

docs(readme): update installation instructions

refactor(utils): simplify date formatting logic
```

## Output

Provide 3 options:
1. **Safe** - Conservative, clear description
2. **Detailed** - Includes scope and body with context
3. **Concise** - Short and to the point

Let user choose or edit before committing.
