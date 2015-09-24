let  s:debug = 0

function! frisk#debug#PrintHeader(text)
    if s:debug
        echom repeat(' ', 80)
        echom repeat('=', 80)
        echom a:text." Debug"
        echom repeat('-', 80)
    endif
endfunction

function! frisk#debug#PrintMsg(text)
    if s:debug
        echom a:text
    endif
endfunction

function! frisk#debug#Enable(enable)
    if a:enable
        let  s:debug = 1
    else
        let  s:debug = 0
    endif
endfunction
