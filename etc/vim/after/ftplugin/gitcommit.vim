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
" The indentation and body-structure rules below MIRROR the indent,
" bullet-continuation, and body checks in etc/git/hooks/commit-msg. A
" stateless single-line regex cannot express them (it would false-positive
" ordinary prose, which cannot be told from bullet continuations, footer
" values, or a second paragraph without tracking "inside a bullet block",
" "inside the footer block", and paragraph position). Keep the two in sync:
" change the hook's logic, change this too. Like the hook, nothing is flagged
" for Merge/Squash/fixup!/squash!/amend! subjects: git writes those messages
" itself (the merge text has indented lines and long subjects).

highlight default link GitcommitLintError Error

" Subject and body (the lines after the separator) chars past column 72.
" Column-regex matches auto-track as the buffer changes, but they are rebuilt
" with the rest of the lint (s:RefreshLintMatches) so they can follow the
" subject's line (blank lines may precede it) and drop for a skipped subject.
" The body rule excludes comment lines (^#...\@! ... \zs anchors the highlight
" to the overflow): the hook strips comment lines before its length check, so
" git's own trailing "# Your branch is up to date..." comments must not be
" flagged.

let s:skip_pattern = '^\%(Merge \|Squash \|fixup!\|squash!\|amend!\)'
let s:footer_token = '^\%([A-Za-z0-9_-]\+\|BREAKING CHANGE\)\%(: \| #\)'

function! s:SubjectLnum() abort
  " Line number of the subject, as the hook sees it: the first line that is
  " neither a comment nor blank. 0 when there is none.
  for lnum in range(1, line('$'))
    let line = getline(lnum)
    if line =~# '^diff --git '
      return 0
    endif
    if line !~# '^#' && line !~# '^[ \t\r]*$'
      return lnum
    endif
  endfor
  return 0
endfunction

function! s:IsSkipped() abort
  " True when the hook would skip this message: its subject is a
  " Merge/Squash/fixup!/squash!/amend! one.
  let subject = s:SubjectLnum()
  return subject > 0 && getline(subject) =~# s:skip_pattern
endfunction

function! s:BadMessageLines() abort
  " Line numbers the commit-msg hook rejects for indentation or body structure.
  " The hook strips comment lines and the verbose-diff region, trims trailing
  " whitespace (CR included), drops leading and trailing blank lines, and counts lines
  " after that, so build the same view (kept as [lnum, text] pairs) and index
  " it 1-based like the hook.
  if s:IsSkipped()
    return []
  endif
  let rows = []
  for lnum in range(1, line('$'))
    let line = getline(lnum)
    if line =~# '^diff --git '
      break
    endif
    if line !~# '^#'
      call add(rows, [lnum, substitute(line, '[ \t\r]\+$', '', '')])
    endif
  endfor
  while !empty(rows) && rows[-1][1] ==# ''
    call remove(rows, -1)
  endwhile
  while !empty(rows) && rows[0][1] ==# ''
    call remove(rows, 0)
  endwhile

  " Paragraphs are runs of non-blank lines past the subject separator; runs of
  " blank lines collapse. Each is [row index, lnum, first line].
  let paras = []
  let in_para = 0
  let idx = 3
  while idx <= len(rows)
    let [lnum, line] = rows[idx - 1]
    if line ==# ''
      let in_para = 0
    elseif !in_para
      call add(paras, [idx, lnum, line])
      let in_para = 1
    endif
    let idx += 1
  endwhile

  " The footer block is the final paragraph, when its first line is a footer
  " token (a '- ' bullet never is). A body that is only a footer counts.
  let footer_start = 0
  if !empty(paras) && paras[-1][2] !~# '^- ' && paras[-1][2] =~# s:footer_token
    let footer_start = paras[-1][0]
  endif

  " A blank line ends a bullet block and a '- ' line opens one. Inside a bullet
  " past the separator, a line must be exactly two spaces followed by a
  " non-space (flags unindented, under- and over-indented alike). Outside one,
  " an indented line is allowed only in the footer block.
  let bad = []
  let in_bullet = 0
  let idx = 1
  while idx <= len(rows)
    let [lnum, line] = rows[idx - 1]
    if line ==# ''
      let in_bullet = 0
    elseif line =~# '^- '
      let in_bullet = 1
    elseif in_bullet
      if idx > 2 && line !~# '^  [^[:space:]]'
        call add(bad, lnum)
      endif
    elseif line =~# '^\s' && (footer_start == 0 || idx < footer_start)
      call add(bad, lnum)
    endif
    let idx += 1
  endwhile

  " Body structure: one prose paragraph, then bullet paragraphs, then an
  " optional footer. Flag the first line of a body that opens with bullets and
  " of any later paragraph that is neither bullets nor the single final footer.
  if !empty(paras) && paras[0][2] =~# '^- '
    call add(bad, paras[0][1])
  endif
  let i = 1
  while i < len(paras)
    let first = paras[i][2]
    if first !~# '^- ' && (first !~# s:footer_token || i != len(paras) - 1)
      call add(bad, paras[i][1])
    endif
    let i += 1
  endwhile
  return uniq(sort(bad, 'n'))
endfunction

function! s:RefreshLintMatches() abort
  " matchaddpos is one-shot (positions do not auto-track), so clear and rebuild
  " this window's lint matches on every change. The ids are window-local so
  " multiple gitcommit windows do not clobber each other.
  for id in get(w:, 'gitcommit_length_matches', [])
    silent! call matchdelete(id)
  endfor
  let w:gitcommit_length_matches = []
  if exists('w:gitcommit_lint_match') && w:gitcommit_lint_match != -1
    silent! call matchdelete(w:gitcommit_lint_match)
  endif
  let w:gitcommit_lint_match = -1
  if s:IsSkipped()
    return
  endif
  let subject = s:SubjectLnum()
  if subject > 0
    call add(w:gitcommit_length_matches,
          \ matchadd('GitcommitLintError', '\%' . subject . 'l\%>72v.\+', 20))
    call add(w:gitcommit_length_matches,
          \ matchadd('GitcommitLintError',
          \ '\%>' . (subject + 1) . 'l^#\@!.\{-}\zs\%>72v.\+', 20))
  endif
  let bad = s:BadMessageLines()
  if !empty(bad)
    let w:gitcommit_lint_match = matchaddpos('GitcommitLintError', bad, 20)
  endif
endfunction

augroup gitcommit_lint_highlight
  autocmd! * <buffer>
  autocmd TextChanged,TextChangedI,InsertLeave <buffer> call s:RefreshLintMatches()
augroup END

call s:RefreshLintMatches()

" --- Paragraph text object that also stops at comment lines ------------------
" The template puts '#' lines directly under the body with no blank line, and
" pasted bodies are often unwrapped. Vim's default `ip` would pull those comments
" into the paragraph, so `gqip`, `dip`, and `vip` would all act on the template.
" Here blank, comment, and text lines are separate runs, and `ip` selects the run
" under the cursor, as the default does for blank lines.

function! s:LineClass(lnum) abort
  if getline(a:lnum) =~# '^\s*$'
    return 'blank'
  elseif getline(a:lnum) =~# '^#'
    return 'comment'
  endif
  return 'text'
endfunction

function! s:InnerParagraph() abort
  let class = s:LineClass(line('.'))
  let first = line('.')
  let last = line('.')
  while first > 1 && s:LineClass(first - 1) ==# class
    let first -= 1
  endwhile
  while last < line('$') && s:LineClass(last + 1) ==# class
    let last += 1
  endwhile
  execute 'normal! ' . first . 'GV' . last . 'G'
endfunction

xnoremap <buffer> <silent> ip :<C-u>call <SID>InnerParagraph()<CR>
onoremap <buffer> <silent> ip :<C-u>call <SID>InnerParagraph()<CR>
