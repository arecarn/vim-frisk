"=============================================================================
"Header                                                                    {{{
"=============================================================================
""A cross platform compatible (Windows/Linux/OSX) plugin that facilitates
"entering a search terms and opening web browsers 
"Last Change: 08 Jul 2013
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

"==========================================================================}}}
" Search Engines                                                            {{{
" the is where all the search engine objects are defined
"=============================================================================
"Search is list to store
let s:searchlist=[]
let g:frisk_default_engine = 'Google'
"Bing{{{2
let g:frisk_bing_enable = 1
if g:frisk_bing_enable == 1
    let s:bing = {
                \'name' : 'bing', 
                \'types':{
                \'video' : 'http://www.bing.com/video/search?q=',
                \'images' : 'http://www.bing.com/images/search?q=',
                \'web': 'http://www.bing.com/search?q='}}
    call add(s:searchlist, s:bing)
endif
"}}}2
"IMDb {{{2
let g:frisk_imdb_enable = 1
if g:frisk_imdb_enable == 1
    let s:imdb={
                \'name' : 'imdb',
                \'types':{
                \'information' : 'http://www.imdb.com/find?q='}}
    call add(s:searchlist, s:imdb)
endif
"}}}2
"Google {{{2
let g:frisk_google_enable  =  1
if g:frisk_google_enable  ==  1
    let s:google = {
                \'name':'google', 
                \'types':{
                \'images' : 'http://images.google.com/images?q=',
                \'translate' : 'http://translate.google.com/\#auto/en/',
                \'web' : 'https://www.google.com/search?q=' }}
    call add(s:searchlist, s:google)
endif
"}}}2
"Stack Overflow {{{2
let g:frisk_stackoverflow_enable = 1
if g:frisk_stackoverflow_enable == 1
    let s:stackoverflow={
                \'name' : 'stack overflow',
                \'types':{
                \'information' : 'http://stackoverflow.com/search?q='}}
    call add(s:searchlist, s:stackoverflow)
endif
"}}}2
"Wikipedia {{{2
let g:frisk_wikipedia_enable  =  1
if g:frisk_wikipedia_enable  ==  1
    let s:wikipedia = {
                \'name' : 'wikipedia',
                \'types': {
                \'information' : 'http://en.wikipedia.org/w/index.php?search='}} 
    call add(s:searchlist, s:wikipedia)
endif
"}}}2
"Wolfram Alpha {{{2
let g:frisk_wolframalpha_enable  =  1
if g:frisk_wolframalpha_enable  ==  1
    let s:wolframalpha = {
                \'name' : 'wolfram alpha',
                \'types':{
                \'information' : 'http://www.wolframalpha.com/input/?i='}}
    call add(s:searchlist, s:wolframalpha)
    "echom string(search)
endif 
" }}}2
"==========================================================================}}}
" s:Setdefualtengine                                                        {{{ 
" set the default search engine based on the value of g:frisk_default_engine
"=============================================================================
function! s:SetDefualtEngine()
    if g:frisk_default_engine ==? 'bing images'
        let s:default_engine = s:bing.types.images

    elseif g:frisk_default_engine ==? 'bing' 
        let s:default_engine = s:bing.types.web

    elseif g:frisk_default_engine ==? 'bing video' 
        let s:default_engine = s:bing.types.video

    elseif g:frisk_default_engine ==? 'imdb' 
        let s:default_engine = s:imdb.types.information

    elseif g:frisk_default_engine ==? 'google' 
        let s:default_engine = s:google.types.web

    elseif g:frisk_default_engine ==? 'google images' 
        let s:default_engine = s:google.types.images

    elseif g:frisk_default_engine ==? 'google translate' 
        let s:default_engine = s:google.types.translate

    elseif g:frisk_default_engine ==? 'stack overflow' 
        let s:default_engine = s:stackoverflow.types.information

    elseif g:frisk_default_engine ==? 'wikipedia' 
        let s:default_engine = s:wikipedia.types.information

    elseif  g:frisk_default_engine ==? 'wolfram alpha'
        let s:default_engine = s:wolframalpha.types.information
    endif 
endfunction

"==========================================================================}}}
" s:BuildEngineList()                                                         {{{
" combine all the search engines into one list
"=============================================================================
function! s:BuildEngineList()
    let i = 1
    let list = [] 
    for eng in s:searchlist
        call add(list, string(i) . ". " . eng.name)
        "echom string(list)
        let i = i + 1 
    endfor
    return list
endfunction

"==========================================================================}}}
" s:PromptEngine(list)                                                           {{{
" prompt the user to choose one of the 
"=============================================================================
function! s:PromptEngine(list)
    redraw
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
    "returns a number in the search list
endfunction

"==========================================================================}}}
" s:PromptEngineOptions(engineName)                                          {{{
" prompt the user for different options for thier search engine
" if there is only one option for the search then defualt to it. 
"=============================================================================
function! s:PromptEngineOptions(engineName)
    redraw
    if len(keys(s:searchlist[a:engineName].types)) > 1 
        let type_choices = ''
        for type in keys(s:searchlist[a:engineName].types)
            let type_choices = type_choices . '&' . type . "\n"
            "echom type_choices
        endfor
        " confirm returns 1 and greater so decrement once for list indexing
        let type_choice = confirm("Choose Your Search Type: ", type_choices, 1) - 1
    else 
        let type_choice = 0
    endif 

    let type_keys = keys(s:searchlist[a:engineName].types)
    "echom type_keys
    let type_key = type_keys[type_choice]
    "echom type_key
    let engineString = s:searchlist[a:engineName].types[type_key]
    return engineString
endfunction

"==========================================================================}}}
" s:GetSearchTerms(line1, line2)                                                          {{{
" Determine if a visual selection was given or if the user needs to be
" prompted for input
"=============================================================================
function! s:GetSearchTerms(line1, line2)
    redraw
    let lineNum = line('$')
    "echo lineNum . "= number of lines in the file"
    if (lineNum - 1) > (a:line2 - a:line1) "TODO if line = 1 in file
        let SearchTerms = s:get_visual_selection()
    else
        call inputsave()
        let SearchTerms = input('What Do You Want To Search: ')
        call inputrestore()
    endif
    "echo SearchTerms
    return SearchTerms
endfunction

"==========================================================================}}}
" s:Search(engineString, query)                                                                  {{{
" execute the search and open the browser
"=============================================================================
function! s:Search(engineString,query)
    "TODO should input be bundled into a function?
    "ask the user what they would like to search 

    let eng = a:engineString
    let q = a:query
    let q = s:EncodeSerch(q)
    "build the search string and call the external program 
    let q = substitute(q, ' ', "+", "g")
    "echo '[' q . ']= the search term'

    if  has("win16") || has("win32") || has("win64")
        exe 'silent! ! start /min ' . eng . q
    elseif has("mac") || has ("macunix") || has("gui_mac") || system('uname') == "Darwin\n" || has("unix")

        "check for Zsh
        redir => s:hasZsh | set shell? | redir END
        "if Zsh is being used escape the engineString
        if matchstr(s:hasZsh, "zsh")  == "zsh" 
            let eng = substitute(eng, '\(.\)' , '\\\1' , 'g')
        endif 

        if has("mac") || has ("macunix") || has("gui_mac") || system('uname') == "Darwin\n"
            exe '!open ' . eng . q
        elseif has("unix")
            exe '!xdg-open ' . eng . q . "&" 
            "note that a "&" has to follow the search query for some reason
        endif

    endif
endfunction

"==========================================================================}}}
" s:EncodeSearch(q)                                                            {{{
" encode the search so non reserved charactes can be used in searches.
" http://webdesign.about.com/library/bl_url_encoding_table.htm
"=============================================================================
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

"==========================================================================}}}
" s:get_visual_selection()                                                    {{{
" Credit: Peter Rodding http://peterodding.com/code/ 
" returns the visual selection 
"=============================================================================
function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    return join(lines, "\n")
endfunction
"==========================================================================}}}
" Frisk(lineone, linetwo, search_string)                                                                   {{{
" The top level function 
"=============================================================================
function! Frisk(lineone, linetwo, search_string)
    let EngineList = s:BuildEngineList() 
    if a:search_string == ''
        let Engine = s:PromptEngine(EngineList)
        let EngineOptions = s:PromptEngineOptions(Engine)
        let query = s:GetSearchTerms(a:lineone, a:linetwo)
        call s:Search(EngineOptions,query)
    else
        call s:SetDefualtEngine()
        call s:Search(s:default_engine, a:search_string)
    endif 
endfunction
"==========================================================================}}}
" Command                                                                  {{{
" if a command :Frisk already mapped then the command won't be remapped 
"=============================================================================
if !hasmapto(':Frisk')
    command! -nargs=* -range=% Frisk call Frisk(<line1>,<line2>,'<args>')
endif

"==========================================================================}}}
"Note functions that take a range of the whole file go the top of the file (or
"slelection) during execution 
