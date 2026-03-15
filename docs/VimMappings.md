# Vim Mappings Reference

Auto-generated documentation of custom Vim mappings.

**Legend**:

- ⚠️ OVERRIDE: Mapping overrides standard Vim behavior

## Mappings by Plugin

### Core (.vimrc)

| Mode | Key         | Command                                          | Notes |
| ---- | ----------- | ------------------------------------------------ | ----- |
| i    | `,`         | `,\<C-g\>u`                                      |       |
| i    | `;`         | `;\<C-g\>u`                                      |       |
| i    | `:`         | `:\<C-g\>u`                                      |       |
| i    | `!`         | `!\<C-g\>u`                                      |       |
| i    | `?`         | `?\<C-g\>u`                                      |       |
| v    | `.`         | `:norm.\<CR\>`                                   |       |
| i    | `.`         | `.\<C-g\>u`                                      |       |
| i    | `(`         | `\<C-g\>u(`                                      |       |
| i    | `)`         | `)\<C-g\>u`                                      |       |
| n    | `<C-H>`     | `\<C-W\>\<C-H\>`                                 |       |
| n    | `<C-J>`     | `\<C-W\>\<C-J\>`                                 |       |
| n    | `<C-K>`     | `\<C-W\>\<C-K\>`                                 |       |
| i    | `<C-l>`     | `\<c-g\>u\<Esc\>[s1z=`\]a\<c-g>u\`               |       |
| n    | `<C-L>`     | `\<C-W\>\<C-L\>`                                 |       |
| t    | `<Esc>`     | `\<C-\>\<C-n\>`                                  |       |
| i    | `<expr>`    | `\<cr\> pumvisible() ? \\<C-y\> : \\<cr\>`       |       |
| i    | `<expr>`    | `\<S-Tab\> pumvisible() ? \\<C-p\> : \\<S-Tab\>` |       |
| i    | `<expr>`    | `\<Tab\> pumvisible() ? \\<C-n\> : \\<Tab\>`     |       |
| n    | `<leader>s` | `:set spell!\<CR\>`                              |       |
| all  | `<leader>T` | `:term \<cr\>`                                   |       |

### ale

| Mode | Key          | Command                                               | Notes |
| ---- | ------------ | ----------------------------------------------------- | ----- |
| n    | `[W`         | `\<Plug\>(ale_first)`                                 |       |
| n    | `[w`         | `\<Plug\>(ale_previous)`                              |       |
| n    | `]W`         | `\<Plug\>(ale_last)`                                  |       |
| n    | `]w`         | `\<Plug\>(ale_next)`                                  |       |
| n    | `<leader>gd` | `:ALEGoToDefinition\<CR\>`                            |       |
| n    | `<silent>`   | `\<leader\>K :call \<SID\>show_documentation()\<CR\>` |       |
| n    | `gr`         | `:ALEFindReferences\<CR\>`                            |       |
| n    | `gR`         | `:ALERename\<CR\>`                                    |       |

### auto-pairs

| Mode | Key          | Command                         | Notes |
| ---- | ------------ | ------------------------------- | ----- |
| n    | `<leader>ap` | `:call AutoPairsToggle()\<CR\>` |       |

### fern

| Mode | Key                | Command                                                                       | Notes |
| ---- | ------------------ | ----------------------------------------------------------------------------- | ----- |
| n    | `<buffer><nowait>` | `\< \<Plug\>(fern-action-leave)`                                              |       |
| n    | `<buffer><nowait>` | `\> \<Plug\>(fern-action-enter)`                                              |       |
| n    | `<buffer>`         | `_ \<Plug\>(fern-action-mark-children:leaf)`                                  |       |
| n    | `<buffer>`         | `- \<Plug\>(fern-action-mark)`                                                |       |
| n    | `<buffer>`         | `\<2-LeftMouse\> \<Plug\>(fern-my-open-expand-collapse)`                      |       |
| n    | `<buffer>`         | `\<CR\> \<Plug\>(fern-my-open-expand-collapse)`                               |       |
| n    | `<buffer>`         | `d \<Plug\>(fern-action-remove)`                                              |       |
| n    | `<buffer>`         | `h \<Plug\>(fern-action-hidden-toggle)`                                       |       |
| n    | `<buffer>`         | `m \<Plug\>(fern-action-move)`                                                |       |
| n    | `<buffer>`         | `M \<Plug\>(fern-action-rename)`                                              |       |
| n    | `<buffer>`         | `n \<Plug\>(fern-action-new-path)`                                            |       |
| n    | `<buffer>`         | `r \<Plug\>(fern-action-reload)`                                              |       |
| n    | `<buffer>`         | `s \<Plug\>(fern-action-open:split)`                                          |       |
| n    | `<buffer>`         | `v \<Plug\>(fern-action-open:vsplit)`                                         |       |
| all  | `<silent>`         | `\<leader\>. :Fern %:h -drawer -width=35 -toggle -stay\<CR\>\<C-w\>=`         |       |
| all  | `<silent>`         | `\<leader\>D :Fern . -drawer -width=35 -toggle -stay -reveal=%\<CR\>\<C-w\>=` |       |
| all  | `<silent>`         | `\<leader\>d :Fern . -drawer -width=35 -toggle -stay\<CR\>\<C-w\>=`           |       |

### fzf

| Mode | Key         | Command                | Notes |
| ---- | ----------- | ---------------------- | ----- |
| n    | `<leader>b` | `:Buffers\<CR\>`       |       |
| n    | `<silent>`  | `\<C-p\> :Files\<CR\>` |       |

### gitgutter

| Mode | Key           | Command                                                                | Notes |
| ---- | ------------- | ---------------------------------------------------------------------- | ----- |
| n    | `<leader>gqf` | `:w\<CR\>:GitGutterQuickFix`                                           |       |
| n    | `<silent>`    | `\<expr\> \<leader\>gd &diff ? :+clo\<CR\> : :GitGutterDiffOrig\<CR\>` |       |

### grepper

| Mode | Key         | Command                                    | Notes |
| ---- | ----------- | ------------------------------------------ | ----- |
| n    | `<leader>*` | `:Grepper -tool ag -cword -noprompt\<cr\>` |       |
| n    | `<leader>F` | `:Grepper -tool ag\<cr\>`                  |       |
| n    | `<leader>f` | `:Grepper -tool git\<cr\>`                 |       |

### limelight_goyo

| Mode | Key          | Command              | Notes |
| ---- | ------------ | -------------------- | ----- |
| n    | `<leader>gy` | `:Goyo\<CR\>`        |       |
| n    | `<leader>L`  | `:Limelight!!\<CR\>` |       |

### nerdcommenter

| Mode | Key     | Command                       | Notes |
| ---- | ------- | ----------------------------- | ----- |
| all  | `<C-_>` | `\<plug\>NERDCommenterToggle` |       |

### obsession

| Mode | Key          | Command            | Notes |
| ---- | ------------ | ------------------ | ----- |
| n    | `<leader>op` | `:Obsess\<Space\>` |       |
| n    | `<leader>oS` | `:Obsess!\<CR\>`   |       |
| n    | `<leader>os` | `:Obsess\<CR\>`    |       |

### prosession

| Mode | Key         | Command                                                                                 | Notes |
| ---- | ----------- | --------------------------------------------------------------------------------------- | ----- |
| n    | `<leader>S` | `:call fzf#run({source: prosession#ListSessions(), sink: Prosession, down: 40%})\<CR\>` |       |

### tagbar

| Mode | Key         | Command               | Notes |
| ---- | ----------- | --------------------- | ----- |
| n    | `<leader>t` | `:TagbarToggle\<CR\>` |       |

### undotree

| Mode | Key         | Command                 | Notes |
| ---- | ----------- | ----------------------- | ----- |
| n    | `<leader>u` | `:UndotreeToggle\<CR\>` |       |

## Standard Vim Overrides

These mappings override standard Vim behavior. Consider remapping to preserve standard
functionality:
