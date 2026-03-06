# Kiro CLI Session Management

Hybrid session storage for Kiro CLI conversations.

## Storage Strategy

- **Git repositories**: Sessions saved as git notes (`refs/notes/kiro/sessions`)
- **Non-git directories**: Sessions saved to `~/.kiro/sessions/`

## Usage

### Save Session

```bash
# In Kiro CLI chat
> /chat save-via-script $DOTFILES_DIR/bin/kiro-save-session [session-name]
```

### Load Session

```bash
# In git repo - load from current commit
> /chat load-via-script $DOTFILES_DIR/bin/kiro-load-session

# In git repo - load from specific commit
> /chat load-via-script $DOTFILES_DIR/bin/kiro-load-session abc123

# Outside git repo - load specific session
> /chat load-via-script $DOTFILES_DIR/bin/kiro-load-session 20260306-131500
```

## Git Aliases

```bash
# List all sessions stored in git notes
git sessions

# Show session for specific commit
git session-show HEAD
git session-show abc123
```

## Syncing Sessions (Git Notes)

Sessions stored as git notes can be pushed/pulled:

```bash
# Push sessions to remote
git push origin refs/notes/kiro/sessions

# Fetch sessions from remote
git fetch origin refs/notes/kiro/sessions:refs/notes/kiro/sessions
```

## Benefits

- **Context preservation**: Sessions tied to exact code state
- **No file clutter**: Git notes are metadata, not working tree files
- **Survives rebases**: Notes configured to follow commits
- **Shareable**: Push/pull sessions across machines
- **Fallback**: Global sessions for non-git work
