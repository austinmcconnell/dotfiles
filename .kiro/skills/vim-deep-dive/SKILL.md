---
name: vim-deep-dive
description: Deep technical guide for Vim configuration with vim-plug and ALE. Use when adding plugins, configuring language support, troubleshooting linters, or customizing language-specific behavior.
---

# Vim Configuration Deep Dive

## Architecture Overview

**Modular plugin system:**

- Main config: `etc/vim/.vimrc` (symlinked to `~/.vim/vimrc`)
- Plugin configs: `etc/vim/plugin/*.vim` (one file per plugin)
- Language overrides: `etc/vim/after/ftplugin/{language}.vim`
- Custom syntax: `etc/vim/syntax/*.vim`

**Why this structure?**

- Isolated plugin configurations prevent conflicts
- Easy to enable/disable plugins
- Language-specific settings override defaults cleanly
- Maintainable and debuggable

## vim-plug Plugin Manager

**Installation:** Auto-installs on first Vim launch

**Plugin declaration in .vimrc:**

```vim
call plug#begin('~/.vim/plugged')
Plug 'dense-analysis/ale'
Plug 'tpope/vim-fugitive'
call plug#end()
```

**Commands:**

- `:PlugInstall` - Install new plugins
- `:PlugUpdate` - Update all plugins
- `:PlugClean` - Remove unused plugins
- `:PlugStatus` - Check plugin status

## Adding New Plugins

Step 1: Add to .vimrc

```vim
Plug 'author/plugin-name'
```

Step 2: Create plugin config

```vim
" Create etc/vim/plugin/plugin-name.vim
" Plugin-specific settings here
```

Step 3: Install and test

```vim
:PlugInstall
:source ~/.vim/vimrc
```

## ALE (Asynchronous Lint Engine)

See `references/ale-configuration.md` for detailed ALE setup.

**Quick reference:**

- Configuration file: `etc/vim/plugin/ale.vim`
- Runs linters asynchronously
- Supports fixers for auto-formatting
- Per-language configuration

**Commands:**

```vim
:ALEInfo      " Check linter status
:ALEFix       " Run fixers
:ALEDetail    " Show full error
```

## Language-Specific Configuration

See `references/language-setup.md` for detailed language configuration patterns.

**Location:** `etc/vim/after/ftplugin/{language}.vim`

**Quick example:**

```vim
" etc/vim/after/ftplugin/python.vim
setlocal tabstop=4
setlocal shiftwidth=4
let b:ale_linters = ['flake8', 'mypy']
let b:ale_fixers = ['black', 'isort']
```

## Prose Writing Mode

**Three ways to enable:**

1. Modeline: `<!-- vim: set ft=markdown.prose: -->`
2. Commands: `:ProseOn` / `:ProseOff`
3. Auto-enable in `writing/`, `blog/`, `essays/` directories

**Features:**

- Punctuation-based undo
- Quick spell correction: `<C-l>`
- Proselint and writegood linters

## Key Mappings

**Leader key:** `;` (semicolon)

**Finding mappings:**

```vim
:map          " Show all mappings
:map <leader> " Show leader mappings
:verbose map <leader>f  " Show where mapping was defined
```

## Troubleshooting

See `references/troubleshooting.md` for detailed troubleshooting guide.

**Quick checks:**

```vim
:PlugStatus   " Check plugin status
:ALEInfo      " Check linter status
:messages     " Check for errors
```

## Best Practices

1. **One plugin config per file** - Easy to debug
2. **Use after/ftplugin for language settings** - Clean overrides
3. **Buffer-local settings** - Prevent conflicts
4. **Test changes incrementally** - `:source ~/.vim/vimrc`
5. **Check :messages for errors** - Catch issues early
6. **Use :ALEInfo for linter debugging** - See what's running

## Quick Reference

**Plugin management:**

```vim
:PlugInstall  " Install new plugins
:PlugUpdate   " Update all
:PlugClean    " Remove unused
```

**ALE:**

```vim
:ALEInfo      " Check linter status
:ALEFix       " Run fixers
:ALEDetail    " Show full error
```

**Navigation:**

```vim
:e etc/vim/.vimrc                    " Main config
:e etc/vim/plugin/ale.vim            " ALE config
:e etc/vim/after/ftplugin/python.vim " Python settings
```

## Reference Documentation

- `references/ale-configuration.md` - ALE linter/fixer setup and language support
- `references/language-setup.md` - Language-specific configuration patterns
- `references/troubleshooting.md` - Common issues and solutions
