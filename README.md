# Dotfiles


## Install

On a sparkling fresh installation of macOS:

    sudo softwareupdate -i -a
    xcode-select --install

The Xcode Command Line Tools includes `git` and `make` (not available on stock macOS).
Then, install this repo with `curl` available:

    bash -c "`curl -fsSL https://raw.githubusercontent.com/austinmcconnell/dotfiles/master/remote-install.sh`"

This will clone (using `git`), or download (using `curl` or `wget`), this repo to `~/.dotfiles`. Alternatively, clone manually into the desired location:

    git clone https://github.com/austinmcconnell/dotfiles.git ~/.dotfiles

Use the [Makefile](./Makefile) to install everything [listed above](#package-overview), and symlink [runcom](./runcom) and [config](./config) (using [stow](https://www.gnu.org/software/stow/)):

    cd ~/projects/dotfiles
    install.sh

## Post-install

* `dotfiles dock` (set [Dock items](./macos/dock.sh))
* `dotfiles macos` (set [macOS defaults](./macos/defaults.sh))
* Mackup
	* Log in to Dropbox
	* `ln -s ~/projects/dotfiles/etc/mackup/.mackup.cfg ~` (until [#632](https://github.com/lra/mackup/pull/632) is fixed)
	* `mackup restore`

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

Practice by running `vimtutor`

Host Key Mapping
- Map `Caps Lock` key to `Ctrl`
- To exit vim's insert mode, use either `Ctrl + c` or `Ctrl + [`

Remember these things

- Jump between splits by using `Ctrl` plus direction (j,k.l,h)

Leader Mappings
- Leader key is mapped to `;`
- Leader + t    --> toggle tagbar
- Leader + n    --> toggle nerdtree
- Leader + gy   --> enable goyo/limelight
- Leader + f    --> search via ack
- Leader + ww   --> launch wiki

Using tabs
- Open multiple files in tabs by using -p. E.g. `vim -p file1.txt file2.txt`
- In NerdTREE
  - open highlighted file in a tab by `t:`
  - silently open highlighted file in a tab by `T:`
- open a new tab and edit a file with `:tabedit file` (need to pass relative path to file)
- move to the next tab with `gt`
- move to the previous tab with `gT`
- move to a specific tab number  with `#gt` (e.g. 2gt takes you to the second tab)
- list all open tabs with `:tabs`
- close a single tab with `:tabclose`



Using tags
- When on a function you want to know more about, jump to it's tag with `Ctrl + ]`.
- Return to previous position/tag with `Ctrl + t`

Using buffers
- List all open buffers with `:ls`
- Move to a specific buffer number with `:b#` (e.g. :b3 takes you to the third buffer)
- Switch to next buffer with `:bn`
- Switch to previous buffer with `:bp`
- Close a buffer with `:bd`
- Open a new file and splits your screen horizontally to show more than one buffer with `:sp [filename]`
- Open a new file and splits your screen vertically to show more than one buffer with `:vsp [filename]`

NERDTree
- Move to NERDTree window (Ctrl + direction) and type `?`
Commands
t: open in new tab
T: open in new tab silently

Launch plain/vanilla vim with the following command `vanillavim`

### Plugins

General
  - [Nerd Tree](https://github.com/preservim/nerdtree)
  - [Lightline](https://github.com/itchyny/lightline.vim)
  - [Supertab](https://github.com/ervandew/supertab)
  - [Ack](https://github.com/mileszs/ack.vim)

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
