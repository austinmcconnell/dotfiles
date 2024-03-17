# Registers

Vim has 26 "registers". A register is a distinct copy buffer. Each register is designated by a
single lower case letter

- `"{letter}dd`: cut the current line into the {letter} register
- `"{letter}p`: paste a copy of the {letter} register's contents
