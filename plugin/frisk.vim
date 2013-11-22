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
" Commands                                                                    {{{
" if a command :FriskList or :Frisk already mapped then the command won't be
" remapped
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -nargs=* -range=0 -complete=custom,frisk#SwitchCompletion Frisk 
            \ call frisk#Main(<count>, <line1>, <line2>, <q-args>)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" AutoCmd
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Restore settings                                                            {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let &cpo = save_cpo

" vim:foldmethod=marker
