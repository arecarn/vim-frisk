" Script settings                                                            {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let save_cpo = &cpo   " allow line continuation
set cpo&vim
" Allows the user to disable the plugin

if exists("g:loaded_frisk")
    finish
endif
let g:loaded_frisk = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}}}}}
" Search Engines                                                             {{{
" the is where all the search engine objects are defined
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:searchEngine = ''
let s:engine = {}
let s:engine.bing            = 'http://www.bing.com/search?q='
let s:engine.bingVideo       = 'http://www.bing.com/video/search?q='
let s:engine.bingImage       = 'http://www.bing.com/images/search?q='
let s:engine.imdb            = 'http://www.imdb.com/find?q='
let s:engine.google          = 'https://www.google.com/search?q='
let s:engine.googleImage     = 'http://images.google.com/images?q='
let s:engine.googleTranslate = 'http://translate.google.com/\#auto/en/'
let s:engine.stackOverflow   = 'http://stackoverflow.com/search?q='
let s:engine.wikipedia       = 'http://en.wikipedia.org/w/index.php?search='
let s:engine.wolframAlpha    = 'http://www.wolframalpha.com/input/?i='



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" s:Frisk()                                                                  {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:Frisk(input) range
    call frisk#debug#PrintHeader('Frisk')
    call frisk#debug#PrintMsg('The input is =['.a:input.']')
    let input = a:input

    let s:defualtEngine = s:engine.google

    let arg = s:GetArg(input)
    let input = s:RemoveArg(input)
    let searchString = s:GetSearchString(input)

    if searchString =~# '^\s*$'
        let searchString = s:GetVisualSearchString(a:firstline, a:lastline)
    endif 


    if arg !~# '^\s*$'
        if has_key(s:engine, arg) 
            let s:searchEngine = get(s:engine, arg)
            call frisk#debug#PrintMsg('The search Engine =['.s:searchEngine.']')
        else 
            throw 'bad key dawg'
        endif
    else 
        let s:searchEngine = s:defualtEngine
        call frisk#debug#PrintMsg('Using defualt search Engine =['.s:searchEngine.']')
    endif

    call s:Search(s:searchEngine, searchString)
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" s:GetArg()                                                                 {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:GetArg(input)
    "test if there is an arg
    let arg = matchstr( a:input, '\C\v^\s*-\zs\a+\ze(\s+|$)')
    call frisk#debug#PrintMsg('The search engine name is =['.arg.']')
    return arg
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" s:RemoveArg()                                                              {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:RemoveArg(input)
    "remove arg
    return substitute( a:input, '\C\v^\s*\zs-\a+\ze(\s+|$)', '', 'g')
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" s:GetSearchString()                                                        {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:GetSearchString(input)
    "extract the search string
    let searchString = matchstr( a:input, '\v\C^(\s*-\a+\s+)?\s*\zs.*$')
    call frisk#debug#PrintMsg('The search string is =['.searchString.']')
    return searchString
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" s:GetVisualSearchString()                                                  {{{
" Determine if a visual selection was given or if the user needs to be
" prompted for input
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:GetVisualSearchString(line1, line2)
    let lineNum = line('$')
    call frisk#debug#PrintMsg(lineNum . "= number of lines in the file")
    if (lineNum - 1) > (a:line2 - a:line1) "TODO if line = 1 in file
        let SearchTerms = s:get_visual_selection()
    else
        let SearchTerms =''
    endif
    call frisk#debug#PrintMsg('['.SearchTerms.'] = search terms from slection')
    return SearchTerms
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"s:get_visual_selection()                                                    {{{
"Credit: Peter Rodding http://peterodding.com/code/ returns the visual
"selection
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [lnum1, col1] = getpos("'<")[1:2] 
    let [lnum2, col2] = getpos("'>")[1:2] 
    let lines = getline(lnum1, lnum2) 
    let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)] 
    let lines[0] = lines[0][col1 - 1:] 
    return join(lines, "\n") 
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" s:Search()                                                                 {{{
" execute the search and open the browser
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:Search(engineString,query)
    call frisk#debug#PrintHeader('s:Search')

    let eng = a:engineString
    let q = a:query
    let q = s:EncodeSerch(q)
    "build the search string and call the external program 
    let q = substitute(q, ' ', "+", "g")
    call frisk#debug#PrintMsg('['.q.']= the search term')

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"Commands                                                                    {{{
"if a command :FriskList or :Frisk already mapped then the command won't be
"remapped
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -nargs=* -range=% -complete=custom,s:EngCompletion Frisk 
            \<line1>,<line2> call s:Frisk('<args>')

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" s:EngCompletion()                                                          {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:EngCompletion(ArgLead, CmdLine, CursorPos)
    call s:PrintDebugHeader("EngCompletion Debug")

    let completionOptions = '-'.join(keys(s:engine), "\n-")
    call s:PrintDebugMsg('The completion options =['
                \ .string(completionOptions).']')
    return completionOptions
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" s:EncodeSearch()                                                           {{{
" encode the search so non reserved charactes can be used in searches.
" http://webdesign.about.com/library/bl_url_encoding_table.htm
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:EncodeSerch(q)
    call frisk#debug#PrintHeader('EncodeSerch()')
    call frisk#debug#PrintMsg('['.a:q.']=the string to be searched')
    let list = split(a:q,'\zs')
    " call frisk#debug#PrintMsg('['.string(list).']=the list of character in the seach')
    let hexList=[] 
    for char in list
    " call frisk#debug#PrintMsg('['.char.']=char before hex encoding')
        let char = substitute(char, '.', '\=printf("%02X",char2nr(submatch(0)))', '')
        let char =  '\%' . char
        call add(hexList, char)
    " call frisk#debug#PrintMsg('['.char.']=char after hex encoding')
    endfor
    return join(hexList,"")
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"Restore settings                                                            {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let &cpo = save_cpo

" vim: foldmethod=marker
