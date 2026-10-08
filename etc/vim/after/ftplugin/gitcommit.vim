" Git commit message settings
setlocal spell
setlocal colorcolumn=73              " highlight 72-char limit for subject and body
setlocal textwidth=72               " auto-wrap at 72 characters (for body text)
setlocal formatoptions+=t           " auto-wrap text using textwidth
setlocal formatoptions+=n           " reflow bullets, indenting continuations under the text
setlocal formatlistpat=^\\s*-\\s    " a list item is optional indent plus '- '
setlocal autoindent                 " sustain the 2-space bullet hang across wrapped lines

" --- Live commit-msg lint highlighting -------------------------------------
" Flag the same violations the commit-msg hook rejects, as you type, so they
" are caught before `git commit` instead of after. All three rules use
" matchadd/matchaddpos (window-local overlays) at priority 20, not syntax:
" priority >10 lets them overrule the colorcolumn=73 guard line on the shared
" column-73 cell (syntax can never beat colorcolumn), so an over-limit char
" shows red even where the guard line is. The guard line stays visible
" everywhere else as the ruler.
"
" The bullet-continuation rule below MIRRORS the in_bullet state machine in
" etc/git/hooks/commit-msg. A stateless single-line regex cannot express it
" (it would false-positive ordinary prose paragraphs, which cannot be told
" from bullet continuations without tracking "inside a bullet block" state).
" Keep the two in sync: change the hook's bullet logic, change this too.

highlight default link GitcommitLintError Error

" Subject (line 1) and body (line 3+) chars past column 72. Column-regex
" matches auto-track as the buffer changes, so they need no refresh. The body
" rule excludes comment lines (^#...\@! ... \zs anchors the highlight to the
" overflow): the hook strips comment lines before its length check, so git's
" own trailing "# Your branch is up to date..." comments must not be flagged.
call matchadd('GitcommitLintError', '\%1l\%>72v.\+', 20)
call matchadd('GitcommitLintError', '\%>2l^#\@!.\{-}\zs\%>72v.\+', 20)

function! s:BadBulletLines() abort
  " Line numbers whose bullet continuation is not indented exactly 2 spaces,
  " matching the commit-msg hook: body starts at line 3; a blank line ends a
  " bullet block; a '- ' line opens one; while inside, a non-blank line that is
  " not exactly two spaces followed by a non-space is a violation (flags both
  " under- and over-indented continuations). Comment lines are stripped by the
  " hook before it checks, and the verbose-diff region is stripped too, so skip
  " both here to stay in sync.
  let bad = []
  let in_bullet = 0
  for lnum in range(3, line('$'))
    let line = getline(lnum)
    if line =~# '^diff --git '
      break
    endif
    if line =~# '^#'
      continue
    endif
    if line ==# ''
      let in_bullet = 0
    elseif line =~# '^- '
      let in_bullet = 1
    elseif in_bullet && line !~# '^  [^ ]'
      call add(bad, lnum)
    endif
  endfor
  return bad
endfunction

function! s:RefreshBulletMatches() abort
  " matchaddpos is one-shot (positions do not auto-track), so clear and rebuild
  " this window's bullet match on every change. The id is window-local so
  " multiple gitcommit windows do not clobber each other.
  if exists('w:gitcommit_bullet_match') && w:gitcommit_bullet_match != -1
    silent! call matchdelete(w:gitcommit_bullet_match)
  endif
  let w:gitcommit_bullet_match = -1
  let bad = s:BadBulletLines()
  if !empty(bad)
    let w:gitcommit_bullet_match = matchaddpos('GitcommitLintError', bad, 20)
  endif
endfunction

augroup gitcommit_lint_highlight
  autocmd! * <buffer>
  autocmd TextChanged,TextChangedI,InsertLeave <buffer> call s:RefreshBulletMatches()
augroup END

call s:RefreshBulletMatches()
