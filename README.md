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
- To exit vim's insert mode, use either `<C-c>` or `<C-[>`

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
- \*: search for other instances of the word under your cursor
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
- <C-j>: jump to the split above current window
- <C-k>: jump to the split below current window
- <C-h>: jump to the split to the right of current window
- <C-l>: jump to the split to the left of current window

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
- <C-r>: redo the last action

Repeating actions
- .: repeat your last action

Useful text objects
- iw and aw: inside word and around word
- is and as: inside sentence and around sentence
- ip and ap: inside paragraph and around paragraph
- i' and a': inside singe quotes and around single quotes
- i" and a": inside double quotes and around double quotes

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

Completion in Insert Mode
- <C-n>: find next match from 'complete' option
- <C-p>: find prev match from 'complete' option
- <C-x><C-o>: find matches from 'omnicomplete' (smart autocomplete for programs)

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

Using tabs (think of these as 'layouts' or 'workspaces' instead of a browser or file editor 'tab')
- `:tabs`: list all open tabs
- `:tabedit [filename]`: edit a file in a new tab
- gt: move to the next tab
- gT: move to the previous tab
- {num}gt: move to a specific tab number
- `:tabclose`: close a single tab

Using buffers
- `:ls`: list all open buffers
- `:e` {char}`: edit a file
- `:e`: reload external changes to a file
- `:e!`: reload external changes and discard unsaved work in buffer
- `:bn`: switch to next buffer
- `:bp`: switch to previous buffer
- `:b{num}`: move to the specified buffer
- `:bd`: close/delete a buffer
- `:sp`: horizontally split window in two. The result is two viewports on the same file
- `:sp [filename]`: horizontally screen window in two and load or create [filname] buffer
- `:vsp`: vertically split window in two. The result is two viewports on the same file
- `:vsp [filename]`: vertically split window in two and load or create [filename] buffer

Using jumps
- A "jump" is a command that moves the cursor to another location (e.g. G, %, ), ],})
- There is a separate jump list for each window
- <C-o>: go to previous position in the jump list
- <C-i>: go to next position in the jump list
- `:jumps`: show the contents of the jump list`

Using tags
- <C-]>: jump to tag
- g<C-]>: show all matching tags
- <C-t>: jump to previous position in the tag stack
- `:tags`: show the contents of the tag stack

Quickfix List
- Scope is the entire project
- `:copen`: open the quickfix list window
- `:cclose`: close the quickfix list window
- `:cnext`: go to the next item on the list
- `:cprev`: go to the previous item on the list
- `:cfirst`: go to the first item on the list
- `:clast`: go to the last item on the list
- `:cc{num}`: go to the nth item on the list

Location List
- Scope is the current window
- `:lopen`: open location list window
- `:lclose`: close location list window
- `:lnext`: go to the next item on the list
- `:lprev`: go to the previous item on the list
- `:lfirst`: go to the first item on the list
- `:llast`: go to the last item on the list
- `:ll{num}`: go to the nth item on the list

Terminal mode
- Terminal starts in insert mode
- `:term`: launch a split-screen terminal
- <C-[>: enter terminal-normal mode
- i: enter insert mode
- <C-D> or exit: close the terminal window

Documentation
- `:helptags ALL`: regenerate help docs for all plugins

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
