# Moving Around

## Jumps

- A "jump" is a command that moves the cursor to another location (e.g. G, %, ), ],})
- There is a separate jump list for each window
- `<C-o>`: go to previous position in the jump list
- `<C-i>`: go to next position in the jump list
- `:jumps`: show the contents of the jump list

## Changes

- `g,`: go to the next position in the change list
- `g;`: go to the previous position in the change list
- `.`: repeat the last change

## Tags

- <C-]>: jump to tag
- g<C-]>: show all matching tags
- `<C-t>`: jump to previous position in the tag stack
- `:tag`: jump to the next position in the tag stack
- `:tags`: show the contents of the tag stack
- `:ts[elect]`: list all matching tags
- `:tn[ext]`: jump to the next matching tag
- `:tp[revious]`: jump to the previous matching tag
- `:tf[irst]`: jump to the first matching tag
- `:tl[ast]`: jump to the last matching tag

## Marks

Vim has 26 "marks". A mark is set to any cursor location using the `m` command. Each mark
is designated by a single lower case letter

- `m{letter}`: set the {letter} mark to the current location
- `'{letter}`: move to beginning of line containing the {letter} mark
- `` `a{letter}``: move to exact location of the {letter} mark
