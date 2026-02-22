# Vim Plugins

## File Management

- [Fern](https://github.com/lambdalisue/fern.vim)
  - `;d`: Toggle directory tree (current dir)
  - `;.`: Toggle directory tree (file's dir)
  - `<CR>`: Open/expand/collapse files and directories
  - `n`: Create new file/directory
  - `d`: Delete file/directory
  - `m`: Move file/directory
  - `M`: Rename file/directory
  - `h`: Toggle hidden files
  - `r`: Reload directory
  - `-`: Mark file/directory
  - `_`: Mark all children (leaves)
  - `s`: Open in horizontal split
  - `v`: Open in vertical split
  - `<`: Leave directory (go up)
  - `>`: Enter directory (go down)

## Search and Navigation

- [FZF](https://github.com/junegunn/fzf.vim)

  - `<C-p>`: Launch Files finder
  - `;b`: Open buffer selector
  - Open selected file:
    - `<C-t>`: in a new tab
    - `<C-x>`: in a new horizontal split
    - `<C-v>`: in a new vertical split
  - `:Files [PATH]`: Files (runs $FZF_DEFAULT_COMMAND if defined)
  - `:GFiles [OPTS]`: Git files (git ls-files)
  - `:GFiles?`: Git files (git status)
  - `:Buffers`: Open buffers
  - `:Colors`: Color schemes
  - `:Ag [PATTERN]`: ag search result
  - `:Maps`: Normal mode mappings
  - `:Helptags`: Help tags

- [Grepper](https://github.com/mhinz/vim-grepper)
  - `;f`: Search in git files
  - `;F`: Search with ag
  - `;*`: Search word under cursor

## General Utilities

- [Lightline](https://github.com/itchyny/lightline.vim)
  - Displays git branch, file status, linting errors, and session status
- [ListToggle](https://github.com/Valloric/ListToggle)
  - `<leader>l`: Toggle the location list
  - `<leader>q`: Toggle the quickfix list
- [Undotree](https://github.com/mbbill/undotree)
  - `;u`: Toggle undotree
- [Tagbar](https://github.com/preservim/tagbar)
  - `;t`: Toggle tagbar

## Session Management

- [Obsession](https://github.com/tpope/vim-obsession)
  - `:Obsess`: start recording to a session file
  - `:Obsess!`: stop recording to a session file
  - `:Source Session.vim` or `vim -S Session.vim`: to load session file
- [Prosession](https://github.com/dhruvasagar/vim-prosession)
  - `;S`: Session selector (FZF interface)
  - Automatically saves/restores sessions for git repositories

## Coding Support

- [ALE](https://github.com/dense-analysis/ale)
  - `gd`: go to definition
  - `gr`: find references
  - `gR`: rename
  - `K`: show documentation
  - `]w`: go to next warning/error
  - `[w`: go to previous warning/error
  - `[W`: go to first warning/error
  - `]W`: go to last warning/error
  - Supports: Python (pylint, pyright), Ruby (rubocop), Shell (shellcheck, bashate), Terraform,
    YAML, JSON, Markdown, and more
- [Auto Pairs](https://github.com/jiangmiao/auto-pairs)
  - Automatically closes brackets, quotes, and parentheses
- [Nerd Commenter](https://github.com/preservim/nerdcommenter)
  - `<C-/>`: Toggle commenting/un-commenting of line or selection
- [Surround](https://github.com/tpope/vim-surround)
  - `ds`: delete surroundings
    - `ds(`: delete surrounding parentheses
  - `cs`: change surroundings
    - `cs")`: change surrounding double quotes to parentheses
  - `ys`: add surroundings (mnemonic is "you surround")
    - `ysiw"`: add double quotes around entire word
    - `ysiw(`: add parentheses around word
    - `yss"`: add double quotes to entire line ignoring leading whitespace
  - when you use `)`, `}`, `]`, or `>`, wrap the text with the appropriate pair of characters
  - when you use `(`, `{`, or `[`, wrap the text with the appropriate pair of characters and append
    a space on the inside

## Git Integration

- [Git Gutter](https://github.com/airblade/vim-gitgutter)
  - `;gd`: Git diff for current file
  - `;gqf`: Git quickfix (show all changes)
  - `ic`: text object that operates on all lines in the current hunk
  - `ac`: text object that operates on all lines in the current hunk and any trailing empty lines
  - `]c`: jump to next git change
  - `[c`: jump to previous git change
  - `<leader>hp`: preview hunk
  - `<leader>hs`: stage hunk
  - `<leader>hu`: undo hunk
  - To stage part of any hunk:
    - preview the hunk
    - move to the preview window
    - delete the lines you do not want to stage
    - stage the remaining lines: either write (`:w`) the window or stage hunk

## Code Navigation

- [Gutentags](https://github.com/ludovicchabant/vim-gutentags)
  - Automatically generates and maintains tags files
  - Does not generate tags for project dependencies (e.g. flask, sqlalchemy) unless the virtual
    environment is located in the project directory (e.g `.venv`)
    - Possible workarounds [here](https://github.com/ludovicchabant/vim-gutentags/issues/179)

## Language-Specific (Ruby)

- [Bundler](https://github.com/tpope/vim-bundler)
  - `:Bundle`: wraps the `bundle` command
- [Endwise](https://github.com/tpope/vim-endwise)
  - Automatically adds `end` statements for Ruby, shell scripts, and vim scripts
- [Dispatch](https://github.com/tpope/vim-dispatch)
  - `:Dispatch rspec %`: run the current spec file
  - `!`: add exclamation mark to run as background task
    - `:Dispatch! rspec`: run entire test suite in background
  - `Copen`: view the results of background job in quickfix window
- [Rails](https://github.com/tpope/vim-rails)
  - `gf`: considers context and knows about partials, fixtures, and more
  - Navigate Rails directory structure
    - `:A`: jump to alternate file
    - `:AS`, `:AV`: jump to alternate file in a horizontal or vertical split
    - `:R`: jump to related file
    - `:RS`, `:RV`: jump to related file in a horizontal or vertical split
    - `:Emodel`: edit the specified model file
    - `:Eview`: edit the specified view file
    - `:Econtroller`: edit the specified controller file
  - Interface to the `rails` command
    - `:Rails console`
    - `:Generate controller Blog`
  - Default task runner
    - `:Rails`: run the current test, spec, or feature
    - `:.Rails`: run the current method, example, or scenario on the current line

## Writing and Focus

- [Goyo](https://github.com/junegunn/goyo.vim)
  - `;gy`: Enable distraction-free writing mode
- [Limelight](https://github.com/junegunn/limelight.vim)
  - `;L`: Toggle paragraph highlighting (dims surrounding text)
  - Automatically activates with Goyo

## Removed/Replaced Plugins

- ~~[NERDTree](https://github.com/preservim/nerdtree)~~ → Replaced with Fern
- ~~[Supertab](https://github.com/ervandew/supertab)~~ → Using built-in completion with ALE
- ~~[Jedi Vim](https://github.com/davidhalter/jedi-vim)~~ → Using ALE for Python support
- ~~[Ack](https://github.com/mileszs/ack.vim)~~ → Using Grepper and FZF for searching
