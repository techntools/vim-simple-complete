﻿if exists("g:loaded_vim_simple_complete")
  finish
endif
let g:loaded_vim_simple_complete = 1

let g:vsc_completion_command = get(g:, 'vsc_completion_command', "\<C-P>")
let g:vsc_reverse_completion_command = get(g:, 'vsc_reverse_completion_command', "\<C-N>")
let g:vsc_tab_complete = get(g:, 'vsc_tab_complete', 1)
let g:vsc_type_complete = get(g:, 'vsc_type_complete', 1)
let g:vsc_type_complete_length = get(g:, 'vsc_type_complete_length', 3)
let g:vsc_pattern = get(g:, 'vsc_pattern', '\I')

fun! s:Init()
    if g:vsc_type_complete
        call s:TypeCompletePlugin()
    endif

    if g:vsc_tab_complete
        call s:TabCompletePlugin()
    endif
endfun

fun! s:LineCharAt(col)
    "return getline('.')[a:col]
    let match_col = a:col + 1

    if match_col < 0
        return ''
    endif

    return matchstr(getline('.'), '\%' . match_col . 'c.')
endfun

fun! s:TabCompletePlugin()
    inoremap <expr> <Tab> <SID>TabComplete(0)
    inoremap <expr> <S-Tab> <SID>TabComplete(1)

    fun! s:TabComplete(reverse)
        if pumvisible()
            return a:reverse ? "\<Down>" : "\<Up>"
        elseif s:LineCharAt(col('.') - 2) =~ g:vsc_pattern
            return a:reverse ? g:vsc_reverse_completion_command : g:vsc_completion_command
        else
            return "\<Tab>"
        endif
    endfun
endfun

fun! s:TypeCompletePlugin()
    set completeopt=menu,menuone,noinsert,preview
    autocmd InsertCharPre * call s:TypeComplete()
    autocmd InsertEnter * let g:vsc_typed_length = 0
    let g:vsc_typed_length = 0

    fun! s:TypeComplete()
        if !g:vsc_type_complete || pumvisible()
            return ''
        endif

        if v:char !~ g:vsc_pattern
            let g:vsc_typed_length = 0
            return ''
        endif

        let g:vsc_typed_length += 1

        if g:vsc_typed_length == g:vsc_type_complete_length
            call feedkeys(g:vsc_completion_command, 'n')
        endif
    endfun
endfun

call s:Init()
