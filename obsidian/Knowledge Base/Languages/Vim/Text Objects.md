# Text Objects

Use Text objects in commands by specifying a modifier and then the text-object itself (like
`{a|i}{text-object}`)

## Modifiers

- `a`: a text-object plus white space
- `i`: inner object without whitespace

## Text Object Identifiers

- `w`: word
- `W`: WORD
- `s`: sentence
- `p`: paragraph
- `t`: tag (like HTML tags)
- `b`: block (like programming blocks)
- `[`: square bracket
- `{`: curly bracket
- `(`: parenthesis
- `'`: single quote
- `"`: double quote

### word vs WORD

- A `word` is delimited by _non-keyword_ characters, which are configurable. Whitespace characters
  and other characters (like `()[],-`) are not keywords. Therefore, a word usually is smaller than a
  WORD; the word-navigation is more fine-grained.
- A WORD is always delimited by _whitespace_.

Example:

```text
This "stuff" is not-so difficult!
wwww  wwwww  ww www ww wwwwwwwww    " (key)words, delimiters are non-keywords: "-! and whitespace
WWWW WWWWWWW WW WWWWWW WWWWWWWWWW   " WORDS, delimiters are whitespace only
```
