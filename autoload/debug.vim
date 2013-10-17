"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" debug#PrintHeader()                                                       {{{ 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! debug#PrintHeader(text)
    if s:debug
        echom repeat(' ', 80)
        echom repeat('=', 80)
        echom a:text." Debug"
        echom repeat('-', 80)
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" debug#PrintMsg()                                                          {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! debug#PrintMsg(text)
    if s:debug
        echom a:text
    endif
endfunction
