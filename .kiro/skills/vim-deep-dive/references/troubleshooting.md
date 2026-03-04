# Vim Troubleshooting

## Plugin Issues

### Plugin Not Loading

**Check plugin status:**

```vim
:PlugStatus
```

**Reinstall plugin:**

```vim
:PlugClean
:PlugInstall
```

**Check for errors:**

```vim
:messages
```

**Verify plugin in .vimrc:**

```vim
:e ~/.vim/vimrc
" Look for: Plug 'author/plugin-name'
```

**Check plugin directory:**

```bash
ls ~/.vim/plugged/
```

### Plugin Conflicts

**Disable plugins one by one:**

```vim
" Comment out in .vimrc
" Plug 'problematic-plugin'
:source ~/.vim/vimrc
:PlugClean
```

**Check load order:**

```vim
:scriptnames
```

Shows all loaded scripts in order.

## ALE Issues

### Linter Not Working

**Check ALE status:**

```vim
:ALEInfo
```

Shows:

- Available linters
- Enabled linters
- Linter executables
- Recent errors

**Common issues:**

1. **Linter not installed:**

```bash
which flake8
pip install flake8
```

2. **Wrong linter name:**

```vim
" Check available linters
:ALEInfo
" Look for "Available Linters" section
```

3. **Linter disabled:**

```vim
" Check if linter is in disabled list
:ALEInfo
" Look for "Linters Disabled" section
```

4. **Project config overriding:**

```bash
# Check for project config files
ls .flake8 .eslintrc .rubocop.yml
```

### Fixer Not Working

**Check fixer configuration:**

```vim
:ALEInfo
" Look for "Fixers" section
```

**Run fixer manually:**

```vim
:ALEFix
```

**Check fixer executable:**

```bash
which black
pip install black
```

**Verify fixer in config:**

```vim
:e etc/vim/plugin/ale.vim
" Look for: let g:ale_fixers = {...}
```

### ALE Performance Issues

**Disable linters temporarily:**

```vim
:ALEDisable
```

**Reduce linter frequency:**

```vim
let g:ale_lint_delay = 1000  " 1 second delay
```

**Disable lint on text change:**

```vim
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 1
```

## Completion Issues

### Completion Not Working

**Check if plugin loaded:**

```vim
:scriptnames | grep completion
```

**Trigger manually:**

```vim
<C-x><C-o>  " Omni completion
<C-x><C-f>  " File completion
<C-x><C-l>  " Line completion
```

**Check ALE completion:**

```vim
let g:ale_completion_enabled = 1
```

### Completion Too Slow

**Disable ALE completion:**

```vim
let g:ale_completion_enabled = 0
```

**Use simpler completion:**

```vim
set completeopt=menu,menuone,noselect
```

## Syntax Highlighting Issues

### Syntax Not Working

**Check filetype:**

```vim
:set filetype?
```

**Force filetype:**

```vim
:set filetype=python
```

**Reload syntax:**

```vim
:syntax sync fromstart
```

**Check syntax file:**

```bash
ls etc/vim/syntax/
```

### Slow Syntax Highlighting

**Limit syntax sync:**

```vim
syntax sync minlines=256
```

**Disable complex patterns:**

```vim
:syntax off
:syntax on
```

## Performance Issues

### Slow Vim Startup

**Profile startup:**

```bash
vim --startuptime vim.log
cat vim.log | sort -k2 -n
```

**Common culprits:**

1. Too many plugins
2. Expensive autocommands
3. Large syntax files
4. Unoptimized plugin configs

**Lazy-load plugins:**

```vim
" Load only for specific filetypes
Plug 'fatih/vim-go', { 'for': 'go' }

" Load only on command
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
```

### Slow Editing

**Check ALE:**

```vim
:ALEDisable
" If faster, ALE is the issue
```

**Disable syntax:**

```vim
:syntax off
" If faster, syntax is the issue
```

**Check for expensive autocommands:**

```vim
:autocmd
```

## Mapping Issues

### Mapping Not Working

**Check if mapping exists:**

```vim
:map <leader>f
```

**Check for conflicts:**

```vim
:verbose map <leader>f
```

Shows where mapping was defined.

**Test mapping:**

```vim
:nnoremap <leader>test :echo "test"<CR>
<leader>test
```

### Leader Key Not Working

**Check leader key:**

```vim
:echo mapleader
```

Should show `;` (semicolon).

**Set leader key:**

```vim
let mapleader = ";"
```

Must be set BEFORE mappings.

## File Type Issues

### Filetype Not Detected

**Check filetype:**

```vim
:set filetype?
```

**Add to filetype.vim:**

```vim
" etc/vim/filetype.vim
augroup filetypedetect
  au BufRead,BufNewFile *.ext setfiletype mytype
augroup END
```

**Force filetype:**

```vim
:set filetype=python
```

### Wrong Filetype Detected

**Override detection:**

```vim
" In file
" vim: set filetype=python:
```

**Or in filetype.vim:**

```vim
au BufRead,BufNewFile *.ext setfiletype correcttype
```

## Configuration Issues

### Settings Not Applied

**Check if file loaded:**

```vim
:scriptnames | grep vimrc
```

**Reload configuration:**

```vim
:source ~/.vim/vimrc
```

**Check for errors:**

```vim
:messages
```

### Buffer-Local Settings Not Working

**Use setlocal:**

```vim
setlocal tabstop=4  " Correct
set tabstop=4       " Wrong (global)
```

**Check buffer-local value:**

```vim
:setlocal tabstop?
```

## Error Messages

### E117: Unknown function

**Function not defined:**

```vim
:function  " List all functions
```

**Plugin not loaded:**

```vim
:PlugStatus
:PlugInstall
```

### E492: Not an editor command

**Command not defined:**

```vim
:command  " List all commands
```

**Plugin not loaded or typo in command name.**

### E121: Undefined variable

**Variable not set:**

```vim
:echo g:variable_name
```

**Set variable:**

```vim
let g:variable_name = "value"
```

## Debugging Workflow

Step 1: Check messages

```vim
:messages
```

Step 2: Check plugin status

```vim
:PlugStatus
```

Step 3: Check ALE (if linter issue)

```vim
:ALEInfo
```

Step 4: Check loaded scripts

```vim
:scriptnames
```

Step 5: Test in clean Vim

```bash
vim -u NONE test.txt
```

Step 6: Binary search plugins

```vim
" Comment out half of plugins
" Test if issue persists
" Repeat until found
```

## Common Solutions

**Reload configuration:**

```vim
:source ~/.vim/vimrc
```

**Reinstall plugins:**

```vim
:PlugClean
:PlugInstall
```

**Clear plugin cache:**

```bash
rm -rf ~/.vim/plugged/
```

**Reset to defaults:**

```bash
mv ~/.vim ~/.vim.backup
mv ~/.vimrc ~/.vimrc.backup
```

**Check Vim version:**

```vim
:version
```

Some plugins require Vim 8.0+.

## Getting Help

**Vim help:**

```vim
:help keyword
:help :command
:help 'option'
```

**Plugin help:**

```vim
:help plugin-name
```

**ALE help:**

```vim
:help ale
:help ale-options
```

**Check documentation:**

```bash
cat ~/.vim/plugged/plugin-name/README.md
```
