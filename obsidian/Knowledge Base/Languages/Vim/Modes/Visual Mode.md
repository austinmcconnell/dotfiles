# Visual Mode

There are 3 types of visual mode

- `v`: character based visual mode
- `V`: line based visual mode
- `<c-v>`: block based visual mode
- `i` or `a` from within this mode will allow multi-line edits (e.g. commenting more than one
  line at a time)

Most normal mode operators still work in visual mode. New operators include:

- `U`: make uppercase (instead of gU)
- `u`: make lowercase (instead of gu)
- `o`: toggle the free end of a visual selection
- `gv`: reselect the last visual selection
