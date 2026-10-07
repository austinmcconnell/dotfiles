" Git commit message settings
setlocal spell
setlocal colorcolumn=73              " highlight 72-char limit for subject and body
setlocal textwidth=72               " auto-wrap at 72 characters (for body text)
setlocal formatoptions+=t           " auto-wrap text using textwidth
setlocal formatoptions+=n           " reflow bullets, indenting continuations under the text
setlocal formatlistpat=^\\s*-\\s    " a list item is optional indent plus '- '
setlocal autoindent                 " sustain the 2-space bullet hang across wrapped lines
