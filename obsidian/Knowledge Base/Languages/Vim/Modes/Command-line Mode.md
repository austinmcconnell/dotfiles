# Command-line Mode

Command-line mode is entered by typing `:` in normal mode.

## Basic Commands

### File Operations

- `:e {file}`: edit/open a file
- `:w`: write (save) current file
- `:w {file}`: write current buffer to {file}
- `:wa`: write all modified buffers
- `:q`: quit current window
- `:qa`: quit all windows
- `:wq`: write and quit
- `:x`: write (if modified) and quit
- `:q!`: quit without saving

### Buffer Operations

- `:ls` or `:buffers`: list all buffers
- `:b {number}`: switch to buffer {number}
- `:b {name}`: switch to buffer matching {name}
- `:bd`: delete current buffer
- `:bd {number}`: delete buffer {number}

### Window and Tab Operations

- `:sp {file}`: horizontal split with {file}
- `:vsp {file}`: vertical split with {file}
- `:tabnew {file}`: open {file} in new tab
- `:tabclose`: close current tab
- `:only`: close all windows except current

## Search and Replace

### Basic Search

- `/{pattern}`: search forward for {pattern}
- `?{pattern}`: search backward for {pattern}
- `:noh`: clear search highlighting

### Substitution

- `:s/old/new/`: replace first occurrence on current line
- `:s/old/new/g`: replace all occurrences on current line
- `:%s/old/new/g`: replace all occurrences in entire file
- `:%s/old/new/gc`: replace with confirmation
- `:5,10s/old/new/g`: replace in lines 5-10

## Line Operations

### Navigation

- `:{number}`: go to line {number}
- `:$`: go to last line
- `:0`: go to first line

### Deletion

- `:{number}d`: delete line {number}
- `:5,10d`: delete lines 5 through 10
- `:.,$d`: delete from current line to end of file

### Copying and Moving

- `:{number}co{destination}`: copy line to destination
- `:{number}m{destination}`: move line to destination
- `:5,10co20`: copy lines 5-10 after line 20

## External Commands

- `:!{command}`: execute external shell command
- `:r !{command}`: read output of command into buffer
- `:w !{command}`: write buffer as input to command

## Command History and Editing

### History Navigation

- `<Up>` or `<C-p>`: previous command in history
- `<Down>` or `<C-n>`: next command in history
- `:history`: show command history

### Command Editing

- `<C-a>`: move to beginning of command line
- `<C-e>`: move to end of command line
- `<C-w>`: delete word before cursor
- `<C-u>`: delete from cursor to beginning of line

## Ranges

Commands can operate on ranges of lines:

- `.`: current line
- `$`: last line
- `%`: entire file (equivalent to `1,$`)
- `'a`: line containing mark a
- `/pattern/`: next line matching pattern
- `?pattern?`: previous line matching pattern

### Range Examples

- `:1,5d`: delete lines 1-5
- `:.,$s/old/new/g`: substitute from current line to end
- `:'a,'bs/old/new/g`: substitute between marks a and b

## Completion

- `<Tab>`: complete command, filename, or option
- `<C-d>`: list all possible completions
- `<C-a>`: insert all possible completions
