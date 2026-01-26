# AI Agent Guidelines

This file provides comprehensive guidelines for AI agents working across all development tools and
projects. These guidelines ensure consistent behavior, security, and quality across all AI-assisted
development workflows.

## Core Principles

### Security First

- **Never execute destructive commands** without explicit user confirmation
- **Never modify production systems** without explicit authorization
- **Always request permission** before performing write operations
- **Follow principle of least privilege** - use read-only operations by default

### Code Quality

- **Run pre-commit hooks** after making code changes
- **Run test suites** to verify changes don't break existing functionality
- **Follow project-specific coding standards** and conventions
- **Maintain consistency** with existing codebase patterns

### Workflow Integration

- **Respect project structure** and organization patterns
- **Use appropriate tools** for the task at hand
- **Provide clear explanations** for recommendations and changes
- **Document decisions** when making significant changes

## Filesystem Operations

### Best Practices

- **Prefer semantic searches** over directory listings to avoid context window overflow
- **Exclude build artifacts** and dependencies from searches
  - Examples: (`.venv`, `node_modules`, `.git`, `__pycache__`, etc.)
- **Use targeted file operations** rather than broad directory scans
- **Respect `.gitignore` patterns** when searching files

### Excluded Patterns

When performing filesystem searches, automatically exclude:

- Virtual environments: `.venv`, `venv`, `env`
- Dependencies: `node_modules`, `vendor`, `.bundle`
- Build artifacts: `dist`, `build`, `*.egg-info`, `target`
- Cache directories: `.pytest_cache`, `.mypy_cache`, `.tox`, `.coverage`
- IDE files: `.idea`, `.vscode`, `.DS_Store`
- Environment files: `.env`, `.env.local`, `.env.*.local`
- Log files: `*.log`, `*.tmp`

## Git Operations

### Safe Practices

- **Read-only by default** - use `git status`, `git log`, `git diff`, `git show`
- **Request permission** before `git commit`, `git push`, `git merge`, `git rebase`
- **Never force push** without explicit user authorization
- **Review changes** before committing

### Commit Guidelines

- Write clear, descriptive commit messages
- Follow conventional commit format when applicable
- Include relevant context in commit messages
- Reference issue numbers when appropriate

## Testing Workflow

### After Code Changes

1. **Check for pre-commit hooks**: If `.pre-commit-config.yaml` exists, run:

   ```bash
   pre-commit run --files <modified-file1> --files <modified-file2>
   ```

2. **Run test suite**: Identify and run appropriate test framework:
   - **Python**: `pytest` (most common)
   - **JavaScript/TypeScript**: `npm test`, `jest`, `mocha`
   - **Ruby**: `rspec`, `minitest`
   - **Go**: `go test`
   - **Other**: Identify project-specific test framework

3. **Verify functionality**: Ensure changes don't break existing functionality

## Code Review Guidelines

### Focus Areas

- **Code quality**: Readability, maintainability, performance
- **Security implications**: Potential vulnerabilities, best practices
- **Architecture**: Alignment with system design patterns
- **Testing**: Adequate test coverage and quality

### Feedback Style

- **Constructive**: Provide actionable, specific feedback
- **Respectful**: Maintain professional tone
- **Educational**: Explain reasoning behind suggestions
- **Balanced**: Acknowledge what's working well

## Project-Specific Context

### When Working in Projects

- **Read project README** for context and conventions
- **Review existing code patterns** before making changes
- **Follow project architecture** and design decisions
- **Respect team conventions** and workflows

### Documentation

- **Update documentation** when making significant changes
- **Add inline comments** for complex logic
- **Maintain consistency** with existing documentation style

## Tool-Specific Guidelines

### Amazon Q

- Use specialized agents for specific workflows (default, github, jira)
- Follow agent-specific prompts and restrictions
- Leverage MCP servers for enhanced context

### Cursor IDE

- Respect `.cursorignore` patterns
- Follow project-specific rules in `.cursor/rules/`
- Use appropriate code completion and suggestions

### Codex CLI

- Follow project-specific `AGENTS.md` when present
- Respect project structure and conventions
- Provide clear, actionable code suggestions

## Error Handling

### Best Practices

- **Provide clear error messages** with context
- **Suggest solutions** when possible
- **Log errors appropriately** for debugging
- **Never silently fail** - always report issues

## Performance Considerations

### Optimization

- **Avoid expensive operations** unless necessary
- **Use caching** when appropriate
- **Minimize context window usage** by being selective with file reads
- **Batch operations** when possible

## Communication

### User Interaction

- **Ask clarifying questions** when requirements are unclear
- **Explain reasoning** behind recommendations
- **Provide alternatives** when multiple approaches exist
- **Confirm before executing** potentially destructive operations

### Documentation

- **Document complex logic** and decisions
- **Provide examples** when explaining concepts
- **Reference relevant documentation** when available
- **Maintain clear, concise explanations**

## Continuous Improvement

### Learning and Adaptation

- **Learn from project patterns** and conventions
- **Adapt to team preferences** and workflows
- **Improve suggestions** based on feedback
- **Stay current** with best practices and tools

---

*This file is maintained in the dotfiles repository and should be referenced by all AI tools for
consistent behavior across development workflows.*
