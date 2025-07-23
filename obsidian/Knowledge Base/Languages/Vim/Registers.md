# Registers

Vim has multiple types of registers for storing text. Each register is designated by a character.

## Named Registers

Vim has 26 "named registers" designated by lowercase letters:

- `"{letter}dd`: cut the current line into the {letter} register
- `"{letter}p`: paste a copy of the {letter} register's contents
- `"{letter}yy`: yank the current line into the {letter} register

## Special Registers

- `"0`: Last yank (only updated by yank operations, not delete)
- `".`: Last inserted text
- `":`: Last command-line command
- `"%`: Current filename
- `"#`: Alternate filename (previous buffer)
- `"/`: Last search pattern
- `"*`: System clipboard (primary selection on Linux)
- `"+`: System clipboard (clipboard selection on Linux/Windows)
- `"_`: Black hole register (discards anything written to it)
- `"-`: Small delete register (deletes less than one line)

## Numbered Registers

- `"0` through `"9`: Automatic registers
  - `"0`: Contains last yank
  - `"1`: Contains last delete/change of one line or more
  - `"2` through `"9`: Previous contents of `"1` (history of deletes)

## Register Types

Registers can store text in different modes:

- **Character-wise**: Normal text selection
- **Line-wise**: Whole lines (when using `dd`, `yy`, etc.)
- **Block-wise**: Rectangular selections (from visual block mode)

## Useful Commands

- `:reg` or `:registers`: Display contents of all registers
- `:reg a b c`: Display contents of registers a, b, and c
- `""p`: Paste from the unnamed register (default register)
- `"0p`: Paste last yank (useful after accidentally deleting something)
