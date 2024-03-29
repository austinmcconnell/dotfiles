# Buffers, Windows, and Tabs

## Using buffers

- `:ls`: show all buffers
- `:ls!`: show all buffers including unlisted buffers
- `:e {char}`: edit a file
- `:e`: reload external changes to a file
- `:e!`: reload external changes and discard unsaved work in buffer
- `:e#`: open the last buffer for editing
- `:bn`: switch to next buffer
- `:bp`: switch to previous buffer
- `:b{num}`: move to the specified buffer
- `:bd`: close/delete a buffer
- `:%bd`: delete all buffers
- `%bd|e#`: delete all buffers except current one

### Do a command in all {}

Windows, buffers, and tabs

- `windo {cmd}`: execute {cmd} in each window
- `bufdo {cmd}`: execute {cmd} in each buffer in the buffer list
- `argdo {cmd}`: execute {cmd} for each file in the argument list
- `tabdo {cmd}`: execute {cmd} in each tab page

quickfix and location lists

- `cdo {cmd}`: execute {cmd} in each valid entry in the quickfix list
- `cfdo {cmd}`: execute {cmd} in each file in the quickfix list
- `ldo {cmd}`: execute {cmd} in each valid entry in the location list for the current window
- `lfdo {cmd}`: execute {cmd} in each file in the location list for the current window

For example, to turn on diff highlighting in all windows, run

```vim
windo diffthis
```

## Using splits

- `:sp`: horizontally split window in two. The result is two viewports on the same file
- `:sp [filename]`: horizontally screen window in two and load or create [filname] buffer
- `:sf {filename}`: horizontally split window and use `:find` to search for {filename}. **Does
  not split if file not found**
- `:vert` or `:vsp`: vertically split window in two. The result is two viewports on the same file
- `:vert sp` or `:vsp [filename]`: vertically split window in two and load or create [filename]
  buffer
- `:sall`: rearrange the screen to open one horizontal split window for each argument. All other
  windows are closed
- `:vert sall`: rearrange the screen to open one vertical split window for each argument. All
  other windows are closed

## Using windows

- `<C-w>c` or `:close`: Close the current window
- `<C-w>o` or `<C-w><C-o>` or `:on(ly)`: Make the current window the only one on the screen. All
  other windows are closed
- `<c-w>\=`: Make all windows equally high and wide
- `<c-w>N-` or `:resize -N`: Decrease window height by N (default 1)
- `<c-w>N+` or `:resize +N`: Increase window height by N (default 1)
- `<c-w>_`: Increase window height to max
- `<c-w>N<`: Decrease window width by N (default 1)
- `<c-w>N>`: Increase window width by N (default 1)
- `<c-w>|`: Increase window width to max

## Using tabs

Think of these as 'layouts' or 'workspaces' instead of a browser or file editor 'tab'

- `:tabs`: list all open tabs
- `:tabedit`: Open a new tab page with an empty window
- `:tabedit {file}`: Open a new tab page and edit {file}
- `:tabfind {file}`: Open a new tab page and edit {file} in path, like with `:find`
- `:tabclose`: Close the current tab page
- `gt`: go to the next tab page (wraps around)
- `gT`: go to previous tab (wraps around)

## Using arg list

The arg list is a **stable subset of the buffer list**. The arg list starts as the files passed
in when you started if (if any). For example `vim a.py b.py`. The buffer list is more like a
history of all the files you looked at in a vim session. The arglist is a stable subset that
does not get added to when viewing files. You can explicitly add a file to the arg list, if
desired though.

- `:args`: show all arguments
- `:arga {filename}`: add {filename} to arg list
- `:args **/*.py`: set arg list to all python files in our working directory
- `:n`: go to next file (based on arg list)

## Quickfix List

- Scope is the entire project
- `:copen`: open the quickfix list window
- `:cclose`: close the quickfix list window
- `:cnext`: go to the next item on the list
- `:cprev`: go to the previous item on the list
- `:cfirst`: go to the first item on the list
- `:clast`: go to the last item on the list
- `:cc{num}`: go to the nth item on the list

## Location List

- Scope is the current window
- `:lopen`: open location list window
- `:lclose`: close location list window
- `:lnext`: go to the next item on the list
- `:lprev`: go to the previous item on the list
- `:lfirst`: go to the first item on the list
- `:llast`: go to the last item on the list
- `:ll{num}`: go to the nth item on the list

## Using vimgrep

`:vim[grep] /{pattern}/ {file}`: Search for {pattern} in the files {file} and set the quick-fix
list to the matches
`%`: the current file name
`#`: the alternate file name
`##`: all names in the argument list

To find all occurances of `TODO` in the current file, run

```vim
:vim /TODO/ %
```

To find all occurances of `TODO` in all files in the arg list, run

```vim
:vim /TODO/ ##

```

To replace all occurances of TODO with DONE for each entry in the quickfix list

```vim
:cdo s/TODO/DONE/g
```
