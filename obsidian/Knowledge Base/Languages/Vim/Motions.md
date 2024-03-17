# Motions

## Left-Right Motions

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
- `,`: repeat latest f, t, F, or T in opposite direction

## Up-Down Motions

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
- ]m: go to beginning of next method
