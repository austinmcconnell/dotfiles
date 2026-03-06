# Kiro CLI Session Management - Quick Reference

## Save Current Session

```bash
/chat save-via-script $DOTFILES_DIR/bin/kiro-save-session
```

## Load Session

```bash
# Git repo: load from current commit
/chat load-via-script $DOTFILES_DIR/bin/kiro-load-session

# Git repo: load from specific commit
/chat load-via-script $DOTFILES_DIR/bin/kiro-load-session abc123

# Non-git: load specific session
/chat load-via-script $DOTFILES_DIR/bin/kiro-load-session 20260306-131500
```

## View Sessions

```bash
# In git repo
git sessions
git session-show HEAD

# Outside git repo
ls ~/.kiro/sessions/
```

## Sync Sessions (Git Only)

```bash
git push origin refs/notes/kiro/sessions
git fetch origin refs/notes/kiro/sessions:refs/notes/kiro/sessions
```
