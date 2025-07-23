# Miscellaneous

## Host Key Mapping

- Map `Caps Lock` key to `Escape`
- Then you can exit vim's insert mode by using the `Caps Lock` key

Practice by running `vimtutor`

Launch plain/vanilla vim with the following command `vanillavim`

- `<C-g>`: show total number of lines in file and current progress through the file

## Undo and Redo

- `u`: undo your last action
- `<C-r>`: redo the last action

## Folds

### Opening and Closing Folds

- `zo`: open one fold under the cursor
- `zO`: open all folds under the cursor recursively
- `zc`: close one fold under the cursor
- `zC`: close all folds under the cursor recursively
- `za`: toggle fold under the cursor
- `zA`: toggle all folds under the cursor recursively

### Working with All Folds

- `zR`: open all folds in the buffer
- `zM`: close all folds in the buffer
- `zi`: toggle folding on/off globally

### Fold Navigation

- `zj`: move to the start of the next fold
- `zk`: move to the end of the previous fold
- `[z`: move to start of current open fold
- `]z`: move to end of current open fold

### Fold Creation

- `zf{motion}`: create a fold over {motion}
- `zf56G`: create fold from current line to line 56
- `zd`: delete fold under cursor
- `zD`: delete all folds under cursor recursively

## Macro Recording

### Recording Macros

- `q{letter}`: start recording macro into register {letter}
- `q`: stop recording macro
- `@{letter}`: execute macro from register {letter}
- `@@`: repeat last executed macro
- `{number}@{letter}`: execute macro {number} times

### Example Workflow

```vim
qa          " Start recording macro 'a'
I# <Esc>j   " Insert '# ' at beginning of line, move down
q           " Stop recording
5@a         " Execute macro 'a' five times
```

### Editing Macros

- `"{letter}p`: paste macro contents to edit
- `"{letter}yy`: yank edited line back to register

## Documentation

- `:helptags ALL`: regenerate help docs for all plugins
- `:help map-modes`: Overview of which map commands work in which modes
