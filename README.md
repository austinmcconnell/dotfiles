# Dotfiles


## Install

On a sparkling fresh installation of macOS:

```
    sudo softwareupdate -i -a
    xcode-select --install
```

The Xcode Command Line Tools includes `git` and `make` (not available on stock macOS).
Then, install this repo with `curl` available:

```
    bash -c "`curl -fsSL https://raw.githubusercontent.com/austinmcconnell/dotfiles/master/remote-install.sh`"
```

This will clone (using `git`), or download (using `curl` or `wget`), this repo to `~/.dotfiles`. Alternatively, clone manually into the desired location:

```
    git clone https://github.com/austinmcconnell/dotfiles.git ~/.dotfiles
```

Use the [Makefile](./Makefile) to install everything [listed above](#package-overview), and symlink [runcom](./runcom) and [config](./config) (using [stow](https://www.gnu.org/software/stow/)):

```
    cd ~/projects/dotfiles
    install.sh
```

## Post-install

* `dotfiles dock` (set [Dock items](./macos/dock.sh))
* `dotfiles macos` (set [macOS defaults](./macos/defaults.sh))

## The `dotfiles` command

    $ dotfiles help
    Usage: dotfiles <command>

    Commands:
       clean            Clean up caches (brew, npm, gem, rvm)
       dock             Apply macOS Dock settings
       edit             Open dotfiles in IDE (code) and Git GUI (stree)
       help             This help message
       macos            Apply macOS system defaults
       test             Run tests
       update           Update packages and pkg managers (OS, brew, npm, gem)

## Vim

Host Key Mapping
- Map `Caps Lock` key to `Ctrl`
- To exit vim's insert mode, use either `Ctrl + c` or `Ctrl + [`

Practice by running `vimtutor`

Verbs
- d: delete
- c: change
- y: yank (copy)
- v: visually select characters (V for lines)

Modifiers
- i: inside
- a: around
- NUM: number (e.g. 1,2,5)
- t: search for something and stop before it
- f: search for something and stop on it

Nouns
- w: word
- s: sentence
- ): sentence (another way of doing it)
- p: paragraph
- }: paragraph (another way of doing it)
- t: tag (like HTML tags)
- b: block (like programming blocks)
-
Searching
- /{string}: search for string
- t: jump to a character
- f: jump onto a character
- *: search for other instances of the word under your cursor
- n: go to the next instance (when you've searched for a string)
- N: go to the previous instance (when you've searched for a string)
- ;: go to the next instance (when you've jumped to a character)
- ,: go to the previous instance (when you've jumped to a character)

Motions
- j: move down one line
- k: move up one line
- h: move left one character
- l: move right one character
- 0: move to the beginning of the line
- $: move to the end of the line
- ^: move to the first non-blank character in the line
- w: move forward one word
- b: move back one word
- e: move to the end of your word
- ): move forward one sentence
- (: move back one sentence
- }: move forward one paragraph
- {: move back one paragraph
- H: move to the top of the screen
- M: move to the middle of the screen
- L: move to the bottom of the screen
- gg: go to the top of the file
- G: go to the bottom of the file
- #G: go to a line number
- ^U: move up half a screen
- ^D: move down half a screen
- ^F: page down
- ^B: page up
- Ctrl-i: jump to your previous navigation location
- Ctrl-o: jump back to where you were
- Ctrl-j: jump to the split above current window
- Ctrl-k: jump to the split below current window
- Ctrl-h: jump to the split to the right of current window
- Ctrl-l: jump to the split to the left of current window

Switching to Insert Mode
- i: insert before the cursor
- a: append after the cursor
- I: insert at the beginning of the line
- A: append at the end of the line
- o: open a new line below the current one
- O: Open a new line above the current one
- r: replace the character under your cursor
- R: replace the character under your cursor and keep typing
- cm: change whatever you define as a movement (e.g. word, sentence, paragraph)
- C: change the current line starting from cursor
- ct?: change up to the question mark
- s: substitute from where you are to the next command (noun)
- S: substitute the entire current line

Deleting text
- x: exterminate (delete) the character under your cursor
- X: exterminate (delete) the character before the cursor
- dm: delete whatever you define as a movement (e.g. word, sentence, paragraph)
- dd: delete the current line
- dt?: delete from where you are to the question mark
- D: delete to the end of the line
- J: join the current line with the next one (delete what's between)

Undo and Redo
- u: undo your last action
- Ctrl-r: redo the last action

Repeating actions
- .: repeat your last action

Spelling
- ]s: go to next misspelled word
- [s: go to previous misspelled word
- z=: get suggestions for misspelled word
- zg: mark misspelled word as correct
- zw: mark a good word as misspelled

Substitution
- s/foo/bar/g: change each "foo" to "bar" on current line
- %s/foo/bar/g: change each "foo" to "bar" on every line
- %s/foo/bar/gc: change each "foo" to "bar" on every line and confirm each change
- `:s` or `&``: repeat the last substitution

Leader Mappings
- Leader key is mapped to `;`
- Leader + t    --> launch a terminal window
- Leader + T    --> toggle tagbar
- Leader + n    --> toggle nerdtree
- Leader + gy   --> enable goyo/limelight
- Leader + f    --> search via ack
- Leader + ww   --> launch wiki
- Leader + s    --> toggle spellcheck
- Leader + u    --> toggle undotree

Using tabs
- List all open tabs with `:tabs`
- Edit a file in a new tab with `:tabedit [filename]`
- move to the next tab with `gt`
- move to the previous tab with `gT`
- move to a specific tab number  with `#gt` (e.g. 2gt takes you to the second tab)
- close a single tab with `:tabclose`

Using buffers
- List all open buffers with `:ls`
- Edit a file with `:e [filename]`
- Switch to next buffer with `:bn`
- Switch to previous buffer with `:bp`
- Move to a specific buffer number with `:b#` (e.g. :b7 takes you to the third buffer)
- Close a buffer with `:bd`
- Open a new file and splits your screen horizontally to show more than one buffer with `:sp [filename]`
- Open a new file and splits your screen vertically to show more than one buffer with `:vsp [filename]`

Using tags
 with `Ctrl + ]`.
- Return to previous position/tag with `Ctrl + t`

Quickfix List
- Scope is the entire project
- Open the quickfix list window with `:copen`
- Close the quickfix list window with `:cclose`
- Go to the next item on the list with `:cnext`
- Go to the previous item on the list with `:cprev`
- Go to the first item on the list with `:cfirst`
- Go to the last item on the list with `:clast`
- Go to the nth item with `:cc #`

Location List
- Scope is the current window
- Open location list window with `:lopen`
- Close location list window with `:lclose`
- Go to the next item on the list with `:lnext`
- Go to the previous item on the list with `:lprev`
- Go to the first item on the list with `:lfirst`
- Go to the last item on the list `:llast`
- Go to the nth item with `:ll #`

Terminal mode
- Launch a split-screen terminal with `:term`
- Terminal starts in insert mode. Get to terminal-normal mode with `Ctrl + [` (i.e. `Esc`). Go back to insert mode by using `i`.
- Close the terminal by typing `exit` or using `Ctrl + D`

Documentation
- (re)generate help docs for all plugins (including newly installed ones) with `:helptags ALL`

NERDTree
- Move to NERDTree window (Ctrl + direction) and type `?`
Commands
t: open in new tab
T: open in new tab silently

Launch plain/vanilla vim with the following command `vanillavim`

### Plugins

General
  - [Ack](https://github.com/mileszs/ack.vim)
  - [auto-save](https://github.com/907th/vim-auto-save)
  - [Nerd Tree](https://github.com/preservim/nerdtree)
  - [Lightline](https://github.com/itchyny/lightline.vim)
  - [Supertab](https://github.com/ervandew/supertab)


Coding plugins
  - [Ale](https://github.com/dense-analysis/ale)
  - [Auto Pairs](https://github.com/jiangmiao/auto-pairs)
  - [Fugitive](https://github.com/tpope/vim-fugitive)
  - [Git Gutter](https://github.com/airblade/vim-gitgutter)
  - [Gutentags](https://github.com/ludovicchabant/vim-gutentags)
  - [Jedi Vim](https://github.com/davidhalter/jedi-vim)
  - [Tagbar](https://github.com/preservim/tagbar)

Writing
  - [Goyo](https://github.com/junegunn/goyo.vim)
  - [Limelight](https://github.com/junegunn/limelight.vim)
  - [Vim Wiki](https://github.com/vimwiki/vimwiki)

### [References](References)
  - https://danielmiessler.com/study/vim/
