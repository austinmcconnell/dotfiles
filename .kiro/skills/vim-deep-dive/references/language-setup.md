# Language-Specific Configuration

## Overview

Language-specific settings override Vim defaults using the `after/ftplugin` directory.

**Location:** `etc/vim/after/ftplugin/{language}.vim`

**Why after/ftplugin?**

- Loads AFTER Vim's default ftplugin
- Overrides defaults without modifying them
- Clean separation of custom settings

## Configuration Pattern

### Basic Structure

```vim
" etc/vim/after/ftplugin/language.vim

" Indentation
setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab

" Line length
setlocal textwidth=100
setlocal colorcolumn=100

" ALE settings
let b:ale_linters = ['linter1', 'linter2']
let b:ale_fixers = ['fixer1', 'fixer2']
let b:ale_fix_on_save = 1

" Language-specific mappings
nnoremap <buffer> <leader>r :!language %<CR>
```

### Buffer-Local Settings

**Use `setlocal` instead of `set`:**

```vim
setlocal tabstop=4      " Only affects current buffer
set tabstop=4           " Affects all buffers (wrong)
```

**Use `<buffer>` for mappings:**

```vim
nnoremap <buffer> <leader>r :!python %<CR>  " Only in Python files
nnoremap <leader>r :!python %<CR>           " In all files (wrong)
```

**Use `b:variable` for buffer-local variables:**

```vim
let b:ale_fix_on_save = 1   " Only affects current buffer
let g:ale_fix_on_save = 1   " Affects all buffers
```

## Language Examples

### Python

`etc/vim/after/ftplugin/python.vim`:

```vim
" Indentation (PEP 8)
setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab

" Line length
setlocal textwidth=100
setlocal colorcolumn=100

" ALE settings
let b:ale_linters = ['flake8', 'mypy']
let b:ale_fixers = ['black', 'isort']
let b:ale_fix_on_save = 1

" Python-specific options
let b:ale_python_flake8_options = '--max-line-length=100'
let b:ale_python_black_options = '--line-length 100'

" Mappings
nnoremap <buffer> <leader>r :!python %<CR>
nnoremap <buffer> <leader>t :!pytest<CR>
```

### JavaScript/TypeScript

`etc/vim/after/ftplugin/javascript.vim`:

```vim
" Indentation
setlocal tabstop=2
setlocal shiftwidth=2
setlocal expandtab

" ALE settings
let b:ale_linters = ['eslint']
let b:ale_fixers = ['eslint', 'prettier']
let b:ale_fix_on_save = 1

" Mappings
nnoremap <buffer> <leader>r :!node %<CR>
nnoremap <buffer> <leader>t :!npm test<CR>
```

### Go

`etc/vim/after/ftplugin/go.vim`:

```vim
" Indentation (tabs, not spaces)
setlocal tabstop=4
setlocal shiftwidth=4
setlocal noexpandtab

" ALE settings
let b:ale_linters = ['gofmt', 'golint', 'go vet']
let b:ale_fixers = ['gofmt']
let b:ale_fix_on_save = 1

" Mappings
nnoremap <buffer> <leader>r :!go run %<CR>
nnoremap <buffer> <leader>t :!go test<CR>
nnoremap <buffer> <leader>b :!go build<CR>
```

### Ruby

`etc/vim/after/ftplugin/ruby.vim`:

```vim
" Indentation
setlocal tabstop=2
setlocal shiftwidth=2
setlocal expandtab

" ALE settings
let b:ale_linters = ['rubocop']
let b:ale_fixers = ['rubocop']
let b:ale_fix_on_save = 1

" Mappings
nnoremap <buffer> <leader>r :!ruby %<CR>
nnoremap <buffer> <leader>t :!rspec<CR>
```

### Shell (sh/bash/zsh)

`etc/vim/after/ftplugin/sh.vim`:

```vim
" Indentation
setlocal tabstop=2
setlocal shiftwidth=2
setlocal expandtab

" ALE settings
let b:ale_linters = ['shellcheck']
let b:ale_fixers = ['shfmt']
let b:ale_fix_on_save = 1
let b:ale_sh_shellcheck_options = '-x'

" Mappings
nnoremap <buffer> <leader>r :!bash %<CR>
```

### Markdown

`etc/vim/after/ftplugin/markdown.vim`:

```vim
" Text wrapping
setlocal textwidth=80
setlocal wrap
setlocal linebreak

" Spell checking
setlocal spell
setlocal spelllang=en_us

" ALE settings (disabled by default)
let b:ale_linters = []
let b:ale_fixers = ['prettier']

" Prose mode (optional)
" See markdown.prose.vim for prose-specific settings
```

### Markdown (Prose Mode)

`etc/vim/after/ftplugin/markdown.prose.vim`:

```vim
" Inherit from markdown
runtime! ftplugin/markdown.vim

" Enable prose linters
let b:ale_linters = ['proselint', 'writegood']
let b:ale_fixers = ['prettier']

" Punctuation-based undo
inoremap <buffer> . .<C-g>u
inoremap <buffer> ! !<C-g>u
inoremap <buffer> ? ?<C-g>u
inoremap <buffer> , ,<C-g>u
inoremap <buffer> ; ;<C-g>u

" Quick spell correction
inoremap <buffer> <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
```

### JSON

`etc/vim/after/ftplugin/json.vim`:

```vim
" Indentation
setlocal tabstop=2
setlocal shiftwidth=2
setlocal expandtab

" ALE settings
let b:ale_linters = ['jsonlint']
let b:ale_fixers = ['jq', 'prettier']
let b:ale_fix_on_save = 1

" Concealment (hide quotes)
setlocal conceallevel=0
```

### YAML

`etc/vim/after/ftplugin/yaml.vim`:

```vim
" Indentation
setlocal tabstop=2
setlocal shiftwidth=2
setlocal expandtab

" ALE settings
let b:ale_linters = ['yamllint']
let b:ale_fixers = ['prettier']
let b:ale_fix_on_save = 1
```

### Terraform

`etc/vim/after/ftplugin/terraform.vim`:

```vim
" Indentation
setlocal tabstop=2
setlocal shiftwidth=2
setlocal expandtab

" ALE settings
let b:ale_linters = ['tflint']
let b:ale_fixers = ['terraform']
let b:ale_fix_on_save = 1

" Mappings
nnoremap <buffer> <leader>f :!terraform fmt<CR>
nnoremap <buffer> <leader>v :!terraform validate<CR>
```

## Common Patterns

### Indentation Settings

**Spaces (most languages):**

```vim
setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab
```

**Tabs (Go, Makefiles):**

```vim
setlocal tabstop=4
setlocal shiftwidth=4
setlocal noexpandtab
```

### Line Length

```vim
setlocal textwidth=100
setlocal colorcolumn=100
```

### ALE Configuration

```vim
let b:ale_linters = ['linter1', 'linter2']
let b:ale_fixers = ['fixer1', 'fixer2']
let b:ale_fix_on_save = 1
```

### Language-Specific Mappings

```vim
" Run current file
nnoremap <buffer> <leader>r :!language %<CR>

" Run tests
nnoremap <buffer> <leader>t :!test-command<CR>

" Build
nnoremap <buffer> <leader>b :!build-command<CR>
```

### Spell Checking

```vim
setlocal spell
setlocal spelllang=en_us
```

### Text Wrapping

```vim
setlocal textwidth=80
setlocal wrap
setlocal linebreak
```

## Creating New Language Configuration

Step 1: Create file

```bash
vim etc/vim/after/ftplugin/newlang.vim
```

Step 2: Add settings

```vim
" Indentation
setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab

" ALE settings
let b:ale_linters = ['linter']
let b:ale_fixers = ['fixer']
let b:ale_fix_on_save = 1

" Mappings
nnoremap <buffer> <leader>r :!newlang %<CR>
```

Step 3: Test

```vim
:e test.newlang
:set filetype?  " Verify filetype detected
```

## Filetype Detection

If Vim doesn't detect your filetype, add to `etc/vim/filetype.vim`:

```vim
augroup filetypedetect
  au BufRead,BufNewFile *.newlang setfiletype newlang
augroup END
```

## Best Practices

1. **Use setlocal** - Only affects current buffer
2. **Use \<buffer> for mappings** - Prevents conflicts
3. **Use b:variable** - Buffer-local variables
4. **Test incrementally** - Reload file to test changes
5. **Document non-obvious settings** - Add comments
6. **Follow language conventions** - Match community standards
7. **Enable fix on save** - Automatic formatting
8. **Keep it minimal** - Only override what's needed
