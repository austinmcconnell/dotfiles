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
" The indentation rule below MIRRORS the indent and bullet-continuation checks
" in etc/git/hooks/commit-msg. A stateless single-line regex cannot express it
" (it would false-positive ordinary prose paragraphs, which cannot be told
" from bullet continuations or footer values without tracking "inside a bullet
" block" and "inside the footer block" state). Keep the two in sync: change
" the hook's indentation logic, change this too.

highlight default link GitcommitLintError Error

" Subject (line 1) and body (line 3+) chars past column 72. Column-regex
" matches auto-track as the buffer changes, so they need no refresh. The body
" rule excludes comment lines (^#...\@! ... \zs anchors the highlight to the
" overflow): the hook strips comment lines before its length check, so git's
" own trailing "# Your branch is up to date..." comments must not be flagged.
call matchadd('GitcommitLintError', '\%1l\%>72v.\+', 20)
call matchadd('GitcommitLintError', '\%>2l^#\@!.\{-}\zs\%>72v.\+', 20)

function! s:BadIndentLines() abort
  " Line numbers the commit-msg hook rejects for indentation. The hook strips
  " comment lines and the verbose-diff region first and counts lines after
  " that, so build the same view (kept as [lnum, text] pairs) and index it
  " 1-based like the hook. Whitespace-only lines are blank (the hook trims them).
  let rows = []
  for lnum in range(1, line('$'))
    let line = getline(lnum)
    if line =~# '^diff --git '
      break
    endif
    if line !~# '^#'
      call add(rows, [lnum, substitute(line, '\s\+$', '', '')])
    endif
  endfor

  " The footer block is the final paragraph, past the subject separator, and
  " only when its first line is a footer token (a '- ' bullet never is).
  let last_blank = 0
  for idx in range(3, len(rows))
    if rows[idx - 1][1] ==# ''
      let last_blank = idx
    endif
  endfor
  let footer_start = 0
  if last_blank > 2 && last_blank < len(rows)
    let first = rows[last_blank][1]
    if first !~# '^- ' && first =~# '^\%([A-Za-z-]\+\|BREAKING CHANGE\)\%(: \| #\)'
      let footer_start = last_blank + 1
    endif
  endif

  " A blank line ends a bullet block and a '- ' line opens one. Inside a bullet
  " past the separator, a line must be exactly two spaces followed by a
  " non-space (flags unindented, under- and over-indented alike). Outside one,
  " an indented line is allowed only in the footer block.
  let bad = []
  let in_bullet = 0
  for idx in range(1, len(rows))
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
  endfor
  return bad
endfunction

function! s:RefreshIndentMatches() abort
  " matchaddpos is one-shot (positions do not auto-track), so clear and rebuild
  " this window's indentation match on every change. The id is window-local so
  " multiple gitcommit windows do not clobber each other.
  if exists('w:gitcommit_indent_match') && w:gitcommit_indent_match != -1
    silent! call matchdelete(w:gitcommit_indent_match)
  endif
  let w:gitcommit_indent_match = -1
  let bad = s:BadIndentLines()
  if !empty(bad)
    let w:gitcommit_indent_match = matchaddpos('GitcommitLintError', bad, 20)
  endif
endfunction

augroup gitcommit_lint_highlight
  autocmd! * <buffer>
  autocmd TextChanged,TextChangedI,InsertLeave <buffer> call s:RefreshIndentMatches()
augroup END

call s:RefreshIndentMatches()

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
