" Script settings                                                            {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let save_cpo = &cpo   " allow line continuation
set cpo&vim
" Allows the user to disable the plugin

if exists("g:loaded_frisk")
    finish
endif
let g:loaded_frisk = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"Commands                                                                    {{{
"if a command :FriskList or :Frisk already mapped then the command won't be
"remapped
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -nargs=* -range=% -complete=custom,frisk#SwitchCompletion Frisk 
            \ <line1>,<line2> call frisk#Main(<q-args>)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"Restore settings                                                            {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let &cpo = save_cpo

" vim:foldmethod=marker
