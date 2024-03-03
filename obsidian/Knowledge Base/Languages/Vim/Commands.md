# Vim Commands

Host Key Mapping

- Map `Caps Lock` key to `Escape`
- Then you can exit vim's insert mode by using the `Caps Lock` key

Practice by running `vimtutor`

Launch plain/vanilla vim with the following command `vanillavim`

## Normal Mode

Operators

- d: delete
- c: change
- y: yank (copy)
- p: paste
- \>: add indentation
- <: remove indentation
- =: format code
- v: visually select characters (V for lines)
- gU: make text uppercase
- gu: make text lowercase

## Visual Mode

There are 3 types of visual mode

- v: character based visual mode
- V: line based visual mode
- `<c-v>`: block based visual mode
- i or a from within this mode will allow multi-line edits (e.g. commenting more than one line at a time)

Most normal mode operators still work in visual mode. New operators include:

- U: make uppercase (instead of gU)
- u: make lowercase (instead of gu)
- o: toggle the free end of a visual selection
- gv: reselect the last visual selection

## Insert Mode

- i: insert before the cursor
- a: append after the cursor
- I: insert at the beginning of the line
- A: append at the end of the line
- o: open a new line below the current one
- O: Open a new line above the current one
- C: change the current line starting from cursor
- s: substitute from where you are to the next command (noun)
- S: substitute the entire current line
- `<C-h>`: Delete back one character (works in insert mode)
- `<C-w>`: Delete back one word (works in insert mode)
- `<C-u>`: Delete back to beginning of line (works in insert mode)
- `<C-o>`: Activate "Insert Normal" Mode to run a single command without leaving Insert mode
- `<C-r>`{register}: Paste from the {register}
- `<C-r><C-p>`{register}: Literal paste from the {register}
- `<C-r>\=`: Access the expression register (can perform calculations, run script code, etc)
- `<C-n>`: find next match from 'complete' option
- `<C-p>`: find prev match from 'complete' option
- `<C-x><C-o>`: find matches from 'omnicomplete' (smart autocomplete for programs)

## Command Mode

### Using buffers

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

## Terminal mode

- Terminal starts in insert mode
- `:term`: launch a split\*screen terminal
- <C-[> or `:sus`: enter terminal-normal mode
- i: enter insert mode
- `<C-D>` or exit: close the terminal window

## Text Objects

Use Text objects in commands by specifying a modifier and then the text-object itself (like `{a|i}{text-object}`)

### Modifiers

- a: a text-object plus white space
- i: inner object without whitespace

### Text Object Identifiers

- w: word
- s: sentence
- p: paragraph
- t: tag (like HTML tags)
- b: block (like programming blocks)
- [: square bracket
- {: curly bracket
- (: parenthesis
- ': single quote
- ": double quote

## Searching

- /{string}: search for string
- n: go to the next instance (when you've searched for a string)
- N: go to the previous instance (when you've searched for a string)
- \*: search for other instances of the word under your cursor
- t: jump forward to a character
- T: jump backward to a character
- f: jump forward onto a character
- F: jump backward onto a character
- ;: repeat the last f, t, F, or T action
- ,: repeat the last f, t, F, or T action in the opposite direction

## Misc

- `<C-g>`: show total number of lines in file and current progress through the file

## Motions

### Left-Right Motions

- h: move left
- l: move right
- 0: move to the beginning of the line
- $: move to the end of the line
- ^: move to the first non-blank character in the line
- f{char}: jump to the right and stop on {char}
- F{char}: jump to the left and stop on {char}
- t{char}: jump to the right and stop before {char}
- T{char}: jump to the left and stop before {char}
- ;: repeat latest f, t, F, or T
- ,: repeat latest f, t, F, or T in opposite direction

### Up-Down Motions

- j: move down one line
- k: move up one line
- H: move to the top of the screen
- M: move to the middle of the screen
- L: move to the bottom of the screen
- gg: go to the top of the file
- G: go to the bottom of the file
- gf: edit the file whose name is under the cursor
- #G: go to a line number
- ^U: move up half a screen
- ^D: move down half a screen
- ^F: page down
- ^B: page up
- zz: redraw the screen with the current line in the middle of the window
- `<C-j>`: jump to the split above current window
- `<C-k>`: jump to the split below current window
- `<C-h>`: jump to the split to the right of current window
- `<C-l>`: jump to the split to the left of current window

## Word Motions

- w: move forward one word
- b: move back one word
- e: move to the end of your word

## Object Motions

- ): move forward one sentence
- (: move back one sentence
- }: move forward one paragraph
- {: move back one paragraph

## Deleting text

- x: exterminate (delete) the character under your cursor
- X: exterminate (delete) the character before the cursor
- dm: delete whatever you define as a movement (e.g. word, sentence, paragraph)
- dd: delete the current line
- `:18,23d`: delete lines 18-23
- dt?: delete from where you are to the question mark
- D: delete to the end of the line
- J: join the current line with the next one (delete what's between)
- r: replace the character under your cursor
- R: replace the character under your cursor and keep typing

## Undo and Redo

- u: undo your last action
- `<C-r>`: redo the last action

## Repeating actions

- .: repeat the last change
- & or `:s`: repeat the last substitution
- ;: repeat the last f, t, F, or T action
- ,: repeat the last f, t, F, or T action in the opposite direction

## Spelling

- ]s: go to next misspelled word
- [s: go to previous misspelled word
- z=: get suggestions for misspelled word
- zg: mark misspelled word as correct
- zw: mark a good word as misspelled

## Substitution

- s/foo/bar/g: change each "foo" to "bar" on current line
- %s/foo/bar/g: change each "foo" to "bar" on every line
- %s/foo/bar/gc: change each "foo" to "bar" on every line and confirm each change
- `:s` or `&`: repeat the last substitution

## Leader Mappings

- Leader key mapped to `;`
- Leader + t --> launch a terminal window
- Leader + f --> search via ack
- Leader + ww --> launch wiki
- Leader + s --> toggle spellcheck

## Using tabs (think of these as 'layouts' or 'workspaces' instead of a browser or file editor 'tab')

- `:tabs`: list all open tabs
- `:tabedit [filename]`: edit a file in a new tab
- gt: move to the next tab
- gT: move to the previous tab
- {num}gt: move to a specific tab number
- `:tabclose`: close a single tab

## Using jumps

- A "jump" is a command that moves the cursor to another location (e.g. G, %, ), ],})
- There is a separate jump list for each window
- `<C-o>`: go to previous position in the jump list
- `<C-i>`: go to next position in the jump list
- `:jumps`: show the contents of the jump list

## Using tags

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

## Folds

- zo: open one fold under the cursor
- zO: open all folds under the cursor recursively
- zc: close one fold under the cursor
- zC: close all fold under the cursor recursively

## Suspending vim

- `C-z>`: get back to terminal without quitting vim (sends vim to background)
- fg: type in terminal to return to session (if there is a single backgrounded session)
- fg [job_id]: return to a speific vim session
- jobs: type in terminal to list all suspended vim sessions

## Documentation

- `:helptags ALL`: regenerate help docs for all plugins
- `:help map-modes`: Overview of which map commands work in which modes

## vimdiff

- `]c`: jump to next change
- `[c`: jump to previous change
- `[buffer number]dp`: push change to indicated buffer
- `[buffer number]do`: obtain change from indicated buffer
- `:cq`: quit without saving changes
- `:diffupdate`: update the diff highlighting

## Marks

Vim has 26 "marks". A mark is set to any cursor location using the `m` command. Each mark
is designated by a single lower case letter

- `m{letter}`: set the {letter} mark to the current location
- `'{letter}`: move to beginning of line containing the {letter} mark
- `` `a{letter}``: move to exact location of the {letter} mark

## Registers

Vim has 26 "registers". A register is a distinct copy buffer. Each register is designated by a
single lower case letter

- `"{letter}dd`: cut the current line into the {letter} register
- `"{letter}p`: paste a copy of the {letter} register's contents
