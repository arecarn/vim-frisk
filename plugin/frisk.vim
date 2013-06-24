"Header{{{
"A cross platform compatible (Windows/Linux/OSX) plugin that facilitates
"entering a search terms and opening web browsers 
"Last Change: 14 Jun 2013
"Maintainer: Ryan Carney arecarn@gmail.com
"License:        DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
"                           Version 2, December 2004
"
"               Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
"
"      Everyone is permitted to copy and distribute verbatim or modified
"     copies of this license document, and changing it is allowed as long
"                           as the name is changed.
"
"                 DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
"       TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
"
"                   0. You just DO WHAT THE FUCK YOU WANT TO

"============================================================================}}}
"Search Engines                                                              {{{
"===============================================================================
"Search is list to store
let g:Search=[]

let g:Bing = {
            \'name' : 'Bing', 
            \'types':{
            \'video' : 'http://www.bing.com/video/search?q=',
            \'images' : 'http://www.bing.com/images/search?q=',
            \'web': 'http://www.bing.com/search?q='}}
call add(g:Search, Bing)

let g:IMDb={
            \'name' : 'IMDb',
            \'types':{
            \'information' : 'http://www.imdb.com/find?q='}}
call add(g:Search, IMDb)

let g:StackOverflow={
            \'name' : 'Stack Overflow',
            \'types':{
            \'information' : 'http://stackoverflow.com/search?q='}}
call add(g:Search, StackOverflow)

let g:Google = {
            \'name':'Google', 
            \'types':{
            \'images' : 'http://images.google.com/images?q=',
            \'translate' : 'http://translate.google.com/\#auto/en/',
            \'web' : 'https://www.google.com/search?q=' }}
call add(g:Search, Google)

let g:Wikipedia = {
            \'name' : 'Wikipedia',
            \'types': {
            \'information' : 'http://en.wikipedia.org/w/index.php?search='}} 
call add(g:Search, Wikipedia)

let g:WolframAlpha = {
            \'name' : 'Wolfram Alpha',
            \'types':{
            \'information' : 'http://www.wolframalpha.com/input/?i='}}
call add(g:Search, WolframAlpha)
"echom string(search)


"============================================================================}}}
"BuildEngineList() {{{
"TODO add globals to enable/disable search engines
"===============================================================================
function! s:BuildEngineList()
    let i = 1
    let list = [] 
    for eng in g:Search
        call add(list, string(i) . ". " . eng.name)
        "echom string(list)
        let i = i + 1 
    endfor
    return list
endfunction

"============================================================================}}}
" PromptEngine()                                                             {{{
" prompt the user to choose one of the 
"===============================================================================
function! s:PromptEngine(list)
    "prompt the user for their search engine of choice
    let engineName = inputlist(a:list) 
    "return if invalid range
    let engineName = engineName -1
    let engine_choices_length = len(a:list) 
    if engineName < engine_choices_length  && engineName >= 0 
    else
        return
    endif 
    return engineName
endfunction

"============================================================================}}}
" PromptEngineOptions(engineName)                                            {{{
" prompt the user for different options for thier search engine
" if there is only one option for the search then defualt to it. 
"===============================================================================
function! s:PromptEngineOptions(engineName)
    if len(keys(g:Search[a:engineName].types)) > 1 
        let type_choices = ''
        for type in keys(g:Search[a:engineName].types)
            let type_choices = type_choices . '&' . type . "\n"
            "echom type_choices
        endfor
        " confirm returns 1 and greater so decrement once for list indexing
        let type_choice = confirm("Choose Your Search Type: ", type_choices, 1) - 1
    else 
        let type_choice = 0
    endif 

    let type_keys = keys(g:Search[a:engineName].types)
    "echom type_keys
    let type_key = type_keys[type_choice]
    "echom type_key

    let engineString = g:Search[a:engineName].types[type_key]
    "echom engineString
    return engineString
endfunction

"============================================================================}}}
"GetSearchTerms()                                                            {{{
"===============================================================================
function! s:GetSearchTerms(line1, line2)

    "echom a:line1 . "= line 1 your turd"
    "echom a:line2 . "= line 2 your turd"
    "

    let lineNum = line('$')
    "echo lineNum . "= number of lines in the file"


    if (lineNum - 1) > (a:line2 - a:line1)
        let SearchTerms = s:get_visual_selection()
        call visualmode(" ") "clear last visual mode var
    else
        call inputsave()
        let SearchTerms = input('What Do You Want To Search: ')
        call inputrestore()
    endif

    "echo SearchTerms
    return SearchTerms
endfunction

"============================================================================}}}
"Search()                                                                    {{{
"===============================================================================
function! s:Search(engineString,query)
    "TODO should input be bundled into a function?
    "ask the user what they would like to search 

    let q = a:query
    let q = s:EncodeSerch(q)
    "build the search string and call the external program 
    let q = substitute(q, ' ', "+", "g")
    "echo '[' q . ']= the search term'
    if has("mac")
        exe '!open ' . a:engineString . q
    elseif  has("win16") || has("win32") || has("win64")
        exe 'silent! ! start /min ' . a:engineString . q
    elseif has("unix")
        exe '!xdg-open ' . a:engineString . q . "&" 
        "note that a "&" has to follow the search query for some reason
    endif
endfunction

"============================================================================}}}
"EncodeSearch()                                                              {{{
"===============================================================================
function! s:EncodeSerch(q)
    "echo a:q
    let list = split(a:q,'\zs')
    "echo list 
    let hexList=[] 
    for char in list
        let char = substitute(char, '.', '\=printf("%02X",char2nr(submatch(0)))', '')
        let char =  '\%' . char
        call add(hexList, char)
        "echo char 
    endfor
    return join(hexList,"")
endfunction

"============================================================================}}}
"GetVisaulSelection()                                                        {{{
"NOTE: have some kind of check to see if in visual mode when frisk is called
"===============================================================================
function! s:GetVisaulSelection()
    let old_z = @z
    normal! gv"zy
    let selection = @z
    let @z = old_z
    return selection
endfunction

"============================================================================}}}
"get_visual_selection()                                                        {{{
"Credit: Peter Rodding http://peterodding.com/code/ 
"===============================================================================
function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    return join(lines, "\n")
endfunction

"============================================================================}}}
"ExecuteOnVisual()                                                           {{{
"NOTE: have some kind of check to see if in visual mode when frisk is called
"===============================================================================
function! s:ExecuteOnVisual(function_name)
    let old_z = @z
    normal! gv"zy
    let ExecuteOnVisualFunc= function(a:function_name)
    call ExecuteOnVisualFunc(@z)
    let @z = old_z
endfunction

"============================================================================}}}
"Echom()                                                                     {{{
"NOTE: have some kind of check to see if in visual mode when frisk is called
"TODO REMOVE
"===============================================================================
function! s:Echom(message)
    echom a:message
endfunction

"============================================================================}}}
"Doit()                                                                      {{{
"TODO REMOVE
"===============================================================================
function! s:Doit()
    call Execute_On_Visual("Echom")
endfunction

"============================================================================}}}
"gs command()                                                                {{{
"===============================================================================
" add checking for http:// and .com,.org ect 
" else just searches google?
"browser commands gs to goto a site check to see if http exists 
"TODO make this ish better 
" compatiblity with visual selection?
" check for http? or keep current abilities? 
if  has("win16") || has("win32") || has("win64")
    nnoremap gs yiW:silent ! start /min <C-R>"<CR>
elseif has('mac')
    nnoremap gs yiW:!open '<C-R>"'<CR>
elseif has('unix')
    nnoremap gs yiW:!xdg-open '<C-R>"'&<CR> 
endif
"============================================================================}}}
"Frisk() {{{
"===============================================================================
function! Frisk(...) range
    let EngineList = s:BuildEngineList() 
    let Engine = s:PromptEngine(EngineList)
    let EngineOptions = s:PromptEngineOptions(Engine)
"    echom a:firstline . "= the first line"
"    echom a:lastline . " = the last line"
    let query = s:GetSearchTerms(a:firstline, a:lastline)
    call s:Search(EngineOptions,query)
endfunction
"============================================================================}}}
"Commands {{{
"===============================================================================
command! FriskOld call Search()
command! -nargs=* -range=% Frisk <line1>,<line2>call Frisk(<f-args>)

"============================================================================}}}
