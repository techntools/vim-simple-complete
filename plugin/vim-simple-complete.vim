if exists("g:loaded_vim_simple_complete")
  finish
endif

let g:loaded_vim_simple_complete = 1

let g:vsc_completion_command = get(g:, 'vsc_completion_command', "\<C-N>")
let g:vsc_reverse_completion_command = get(g:, 'vsc_reverse_completion_command', "\<C-P>")
let g:vsc_tab_complete = get(g:, 'vsc_tab_complete', 1)
let g:vsc_type_complete = get(g:, 'vsc_type_complete', 1)
let g:vsc_pattern = get(g:, 'vsc_pattern', '\k')

fun! s:CurrentChar()
    return matchstr(getline('.'), '.\%' . col('.') . 'c')
endfun

fun! s:TabCompletePlugin()
    inoremap <expr> <Tab> <SID>TabComplete(0)
    inoremap <expr> <S-Tab> <SID>TabComplete(1)

    fun! s:TabComplete(reverse)
        if s:CurrentChar() =~? g:vsc_pattern || pumvisible()
            return a:reverse ? g:vsc_reverse_completion_command : g:vsc_completion_command
        else
            return "\<Tab>"
        endif
    endfun
endfun

fun! s:TypeCompletePlugin()
    augroup TypeCompletePlugin
        autocmd!
        autocmd InsertCharPre * noautocmd call s:TypeComplete()
    augroup END

    fun! s:TypeComplete()
        if !g:vsc_type_complete || pumvisible()
            return
        endif

        if v:char =~? g:vsc_pattern
            call feedkeys(g:vsc_completion_command, 'i')
        endif
    endfun
endfun

if g:vsc_type_complete | call s:TypeCompletePlugin() | endif
if g:vsc_tab_complete  | call s:TabCompletePlugin()  | endif
