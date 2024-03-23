# Operators

- `d`: delete
- `c`: change
- `y`: yank (copy)
- `p`: paste
- `>`: add indentation
- `<`: remove indentation
- `=`: format code
- `v`: visually select characters (V for lines)
- `~`: swap case
- `gu`: make text lowercase
- `gU`: make text uppercase
- `!`: filter to external program
- `=`: indent

## Deleting text

- `x`: exterminate (delete) the character under your cursor
- `X`: exterminate (delete) the character before the cursor
- `d{motion}`: delete whatever you define as a movement (e.g. word, sentence, paragraph)
  - `dt?`: delete from where you are to the question mark
- `dd`: delete the current line
- `:18,23d`: delete lines 18-23
- `D`: delete to the end of the line
- `J`: join the current line with the next one (delete what's between)
- `r`: replace the character under your cursor
- `R`: replace the character under your cursor and keep typing
