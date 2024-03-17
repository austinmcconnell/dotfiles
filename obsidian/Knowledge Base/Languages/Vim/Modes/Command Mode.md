# Command Mode

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
- ``:%bd``: delete all buffers
- `%bd|e#`: delete all buffers except current one
- `:sp`: horizontally split window in two. The result is two viewports on the same file
- `:sp [filename]`: horizontally screen window in two and load or create [filname] buffer
- `:vsp`: vertically split window in two. The result is two viewports on the same file
- `:vsp [filename]`: vertically split window in two and load or create [filename] buffer

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

## Using tabs

Think of these as 'layouts' or 'workspaces' instead of a browser or file editor 'tab'

- `:tabs`: list all open tabs
- `:tabedit [filename]`: edit a file in a new tab
- gt: move to the next tab
- gT: move to the previous tab
- {num}gt: move to a specific tab number
- `:tabclose`: close a single tab
