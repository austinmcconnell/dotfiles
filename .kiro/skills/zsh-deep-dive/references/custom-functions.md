# Custom Functions

## Overview

Custom functions in Zsh are autoloaded from `~/.config/zsh/functions/` directory.

**Autoloading benefits:**

- Functions defined on first use (lazy loading)
- No need to source explicitly
- Faster startup

## Creating Custom Functions

### Basic Function

**Create file:**

```bash
cat > ~/.config/zsh/functions/myfunction <<'EOF'
# Description of what function does
echo "Hello from myfunction"
EOF

chmod +x ~/.config/zsh/functions/myfunction
```

**Use it:**

```bash
myfunction
```

### Function with Arguments

```bash
cat > ~/.config/zsh/functions/git-branch-delete <<'EOF'
# Delete git branch locally and remotely
# Usage: git-branch-delete branch-name

if [[ -z "$1" ]]; then
  echo "Usage: git-branch-delete <branch-name>"
  return 1
fi

git branch -d "$1"
git push origin --delete "$1"
EOF
```

### Function with Options

```bash
cat > ~/.config/zsh/functions/docker-clean <<'EOF'
# Clean Docker resources
# Usage: docker-clean [-a|--all] [-v|--volumes]

local clean_all=false
local clean_volumes=false

while [[ $# -gt 0 ]]; do
  case $1 in
    -a|--all)
      clean_all=true
      shift
      ;;
    -v|--volumes)
      clean_volumes=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      return 1
      ;;
  esac
done

docker container prune -f
docker image prune -f

if [[ "$clean_all" == true ]]; then
  docker system prune -a -f
fi

if [[ "$clean_volumes" == true ]]; then
  docker volume prune -f
fi
EOF
```

## Function Naming Conventions

**Use hyphens for multi-word functions:**

```bash
git-cleanup
docker-logs
aws-profile
```

**Prefix with topic for organization:**

```bash
git-*      # Git-related functions
docker-*   # Docker-related functions
aws-*      # AWS-related functions
k8s-*      # Kubernetes-related functions
```

## Common Function Patterns

### Git Functions

**Clean merged branches:**

```bash
cat > ~/.config/zsh/functions/git-cleanup <<'EOF'
# Remove merged branches
git branch --merged | grep -v "\*" | grep -v "main\|master" | xargs -n 1 git branch -d
EOF
```

**Fuzzy checkout:**

```bash
cat > ~/.config/zsh/functions/git-checkout-fuzzy <<'EOF'
# Fuzzy find and checkout branch
local branch
branch=$(git branch --all | grep -v HEAD | sed 's/^..//' | fzf)
if [[ -n "$branch" ]]; then
  git checkout "$branch"
fi
EOF
```

**Show file history:**

```bash
cat > ~/.config/zsh/functions/git-file-history <<'EOF'
# Show git history for a file
# Usage: git-file-history <file>

if [[ -z "$1" ]]; then
  echo "Usage: git-file-history <file>"
  return 1
fi

git log --follow -p -- "$1"
EOF
```

### Docker Functions

**Container logs with follow:**

```bash
cat > ~/.config/zsh/functions/docker-logs <<'EOF'
# Follow logs for a container
# Usage: docker-logs <container>

if [[ -z "$1" ]]; then
  echo "Usage: docker-logs <container>"
  return 1
fi

docker logs -f "$1"
EOF
```

**Interactive container shell:**

```bash
cat > ~/.config/zsh/functions/docker-shell <<'EOF'
# Open shell in running container
# Usage: docker-shell <container>

if [[ -z "$1" ]]; then
  echo "Usage: docker-shell <container>"
  return 1
fi

docker exec -it "$1" /bin/sh
EOF
```

### Kubernetes Functions

**Pod logs:**

```bash
cat > ~/.config/zsh/functions/k8s-logs <<'EOF'
# Follow logs for a pod
# Usage: k8s-logs <pod> [namespace]

local pod=$1
local namespace=${2:-default}

if [[ -z "$pod" ]]; then
  echo "Usage: k8s-logs <pod> [namespace]"
  return 1
fi

kubectl logs -f "$pod" -n "$namespace"
EOF
```

**Port forward:**

```bash
cat > ~/.config/zsh/functions/k8s-port-forward <<'EOF'
# Port forward to a pod
# Usage: k8s-port-forward <pod> <local-port> <remote-port> [namespace]

local pod=$1
local local_port=$2
local remote_port=$3
local namespace=${4:-default}

if [[ -z "$pod" || -z "$local_port" || -z "$remote_port" ]]; then
  echo "Usage: k8s-port-forward <pod> <local-port> <remote-port> [namespace]"
  return 1
fi

kubectl port-forward "$pod" "$local_port:$remote_port" -n "$namespace"
EOF
```

### AWS Functions

**Switch profile:**

```bash
cat > ~/.config/zsh/functions/aws-profile <<'EOF'
# Switch AWS profile
# Usage: aws-profile <profile-name>

if [[ -z "$1" ]]; then
  echo "Current profile: ${AWS_PROFILE:-default}"
  echo "Available profiles:"
  aws configure list-profiles
  return 0
fi

export AWS_PROFILE=$1
echo "Switched to profile: $AWS_PROFILE"
EOF
```

**SSO login:**

```bash
cat > ~/.config/zsh/functions/aws-sso-login <<'EOF'
# Login to AWS SSO
# Usage: aws-sso-login [profile]

local profile=${1:-$AWS_PROFILE}

if [[ -z "$profile" ]]; then
  echo "Usage: aws-sso-login [profile]"
  return 1
fi

aws sso login --profile "$profile"
EOF
```

### Utility Functions

**Create directory and cd:**

```bash
cat > ~/.config/zsh/functions/mkcd <<'EOF'
# Create directory and cd into it
# Usage: mkcd <directory>

if [[ -z "$1" ]]; then
  echo "Usage: mkcd <directory>"
  return 1
fi

mkdir -p "$1" && cd "$1"
EOF
```

**Extract archives:**

```bash
cat > ~/.config/zsh/functions/extract <<'EOF'
# Extract various archive formats
# Usage: extract <file>

if [[ -z "$1" ]]; then
  echo "Usage: extract <file>"
  return 1
fi

if [[ -f "$1" ]]; then
  case "$1" in
    *.tar.bz2)   tar xjf "$1"     ;;
    *.tar.gz)    tar xzf "$1"     ;;
    *.bz2)       bunzip2 "$1"     ;;
    *.rar)       unrar x "$1"     ;;
    *.gz)        gunzip "$1"      ;;
    *.tar)       tar xf "$1"      ;;
    *.tbz2)      tar xjf "$1"     ;;
    *.tgz)       tar xzf "$1"     ;;
    *.zip)       unzip "$1"       ;;
    *.Z)         uncompress "$1"  ;;
    *.7z)        7z x "$1"        ;;
    *)           echo "Cannot extract '$1'" ;;
  esac
else
  echo "'$1' is not a valid file"
fi
EOF
```

## Function with FZF Integration

**Fuzzy find and cd:**

```bash
cat > ~/.config/zsh/functions/fcd <<'EOF'
# Fuzzy find directory and cd
local dir
dir=$(fd --type d | fzf)
if [[ -n "$dir" ]]; then
  cd "$dir"
fi
EOF
```

**Fuzzy find and edit:**

```bash
cat > ~/.config/zsh/functions/fe <<'EOF'
# Fuzzy find file and edit
local file
file=$(fd --type f | fzf)
if [[ -n "$file" ]]; then
  ${EDITOR:-vim} "$file"
fi
EOF
```

## Error Handling

**Check for required commands:**

```bash
cat > ~/.config/zsh/functions/docker-stats <<'EOF'
# Show docker stats

if ! command -v docker &>/dev/null; then
  echo "Error: docker not found"
  return 1
fi

docker stats
EOF
```

**Validate arguments:**

```bash
cat > ~/.config/zsh/functions/git-commit-message <<'EOF'
# Commit with message
# Usage: git-commit-message <message>

if [[ -z "$1" ]]; then
  echo "Error: commit message required"
  echo "Usage: git-commit-message <message>"
  return 1
fi

git commit -m "$1"
EOF
```

## Function Documentation

**Use comments:**

```bash
cat > ~/.config/zsh/functions/myfunction <<'EOF'
# Short description of function
#
# Usage: myfunction <arg1> [arg2]
#
# Arguments:
#   arg1 - Description of arg1
#   arg2 - Optional description of arg2
#
# Examples:
#   myfunction foo
#   myfunction foo bar

# Function implementation here
EOF
```

## Testing Functions

**Test in current shell:**

```bash
# Source function directly
source ~/.config/zsh/functions/myfunction

# Test it
myfunction
```

**Test in new shell:**

```bash
# Reload shell
exec zsh

# Test function
myfunction
```

## Debugging Functions

**Enable debug mode:**

```bash
set -x
myfunction
set +x
```

**Print variables:**

```bash
echo "Variable: $var"
```

**Check return codes:**

```bash
myfunction
echo "Return code: $?"
```

## Best Practices

1. **One function per file** - Easy to manage
2. **Use descriptive names** - Clear purpose
3. **Add documentation** - Usage and examples
4. **Validate arguments** - Check required args
5. **Handle errors** - Check command availability
6. **Use local variables** - Prevent pollution
7. **Make executable** - `chmod +x`
8. **Test thoroughly** - Verify behavior
9. **Prefix with topic** - Organization
10. **Keep it simple** - Single responsibility

## Quick Reference

**Create function:**

```bash
cat > ~/.config/zsh/functions/myfunction <<'EOF'
# Function code
EOF
chmod +x ~/.config/zsh/functions/myfunction
```

**Test function:**

```bash
exec zsh
myfunction
```

**Debug function:**

```bash
set -x
myfunction
set +x
```

**List functions:**

```bash
ls ~/.config/zsh/functions/
```
