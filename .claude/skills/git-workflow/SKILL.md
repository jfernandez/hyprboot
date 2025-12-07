---
name: git-workflow
description: |
  Git commit and PR conventions using conventional commits.
  Use when creating commits, pull requests, or any git operations.
---

# Git Workflow

## Commits

Use conventional commit format: `type: lowercase description`

Types: `feat`, `fix`, `chore`, `ci`, `docs`, `refactor`, `test`

### Subject line

- Conventional commit prefix required
- Max 50 chars (soft limit), 72 chars (hard limit)
- Lowercase after colon
- Imperative mood: "add", "fix", "enable"
- No trailing period
- No scopes

### Body

- Wrap at 72 characters
- Explain WHY, not WHAT
- Separate from subject with blank line
- Optional - omit for self-explanatory changes

### Forbidden

- No Claude Code attribution
- No emojis
- No Co-Authored-By
- No "Generated with" footers

### GPG failures

Use `--no-gpg-sign` if signing fails.

## Pull Requests

### Single commit PR

Let GitHub auto-populate from the commit:

```bash
gh pr create --fill
```

### Multi-commit PR

Use commit message style - a short conventional commit title and plain body:

```bash
gh pr create --title "type: description" --body "$(cat <<'EOF'
Brief explanation of what this set of changes accomplishes
and why, written as plain prose. No markdown headers or
bullet points unless genuinely needed.
EOF
)"
```

Keep it natural. Write like a human explaining changes to a colleague.
