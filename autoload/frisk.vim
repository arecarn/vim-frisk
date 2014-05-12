" Script settings                                                            {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let save_cpo = &cpo   " allow line continuation
set cpo&vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Search Engines                                                             {{{
" the is where all the search engine objects are defined
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:defualtEngine = ''
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
" s:Main()                                                                   {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! frisk#Main(input) range
    call frisk#debug#PrintHeader('Main()')
    let Engine = s:HandleArg(a:input)
    let query = s:GetQuery(a:input, a:firstline, a:lastline)
    let url = s:BuildURL(Engine, query)
    call frisk#Open(url)
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" s:HandleArg()                                                              {{{
" If arguments are passed in set the search engine accordingly 
" If not use the default search engine
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:HandleArg(input)
    call frisk#debug#PrintMsg('The input is =['.a:input.']')
    " if default engine isn't set to anything let it be google
    if s:defualtEngine == ''
        let s:defualtEngine = s:engine.google
    endif
    " extract the arguments if they exist
    let arg = s:GetValidArg(a:input)
    " determine search engine based on arguments from user
    let Engine = s:DetermineEng(arg) 
    call frisk#debug#PrintMsg('Eng =['.Engine.']')
    return Engine 
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" s:DetermineEngine()                                                        {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:DetermineEng(arg) 
    if a:arg =~# '^\s*$'   " no arguments found
        let Engine = s:defualtEngine
    else                " arguments found
        if has_key(s:engine, a:arg) 
            let Engine = get(s:engine, a:arg)
        else 
            throw 'Frisk Error:'. "No ". a:arg . " Found"  
        endif
    endif
    return Engine
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" s:GetValidArg()                                                            {{{
" test if there is an arg in the correct form.
" return the arg if it's valid otherwise an empty string is returned
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:GetValidArg(input)
    let arg = matchstr( a:input, '\C\v^\s*-\zs\a+\ze(\s+|$)')
    call frisk#debug#PrintMsg('The search engine name is =['.arg.']')
    return arg
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" s:GetQuery()                                                        {{{
" Remove the query from the users input
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:GetQuery(input, frstline, lstline)
    "remove the arguments and return the query
    let input = s:RemoveArg(a:input)
    "extract the query
    let query = matchstr( input, '\v\C^(\s*-\a+\s+)?\s*\zs.*$')
    call frisk#debug#PrintMsg('The query is =['.query.']')
    if query =~ '^\s*$' " if there is no match get visual selection
        let query = s:GetVisualQuery(a:frstline, a:lstline)
        call frisk#debug#PrintMsg('Visual query =['.query.']')
    endif 
    return query
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" s:RemoveArg()                                                              {{{
" Remove the arguments from the users input using search an replace
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:RemoveArg(input)
    return substitute( a:input, '\C\v^\s*\zs-\a+\ze(\s+|$)', '', 'g')
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" s:GetVisualQuery()                                                  {{{
" Determine if a visual selection was given or if the user needs to be
" prompted for input
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:GetVisualQuery(line1, line2)
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
" s:BuildURL()                                                               {{{
" execute the search and open the browser
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:BuildURL(eng, query)
        call frisk#debug#PrintHeader('BuildURL')
    let eng = a:eng
    let query = a:query
    let urlRegex = '\v(ht|f)tp:\/\/.*(\s\+|$)'
    if query =~ urlRegex 
        call frisk#debug#PrintMsg('Opening as URL')
        let eng = ''
    else
        call frisk#debug#PrintMsg('['.query.']= the search term before encoding')
        let query= s:EncodeSerch(query)
        call frisk#debug#PrintMsg('['.query.']= the search term')
    endif 
    " check for zsh and escape every character
    if matchstr(&shell, "zsh")  == "zsh" 
        let eng = substitute(eng , '\(.\)' , '\\\1' , 'g')
    endif 
    let url = eng.query
        call frisk#debug#PrintMsg('['.url.']= url')
    return url 
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" frisk#Open()                                                                 {{{
" execute the search and open the browser
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! frisk#Open(url)
    call frisk#debug#PrintHeader('frisk#Open')
    call frisk#debug#PrintMsg('['.a:url.']= the url to open')
    if has("win32") || has("win64") "Windows
        execute 'silent !cmd /c start /min ' . a:url
        call frisk#debug#PrintMsg('opening with windows')
    elseif has("unix") 
        let os=substitute(system('uname'), '\n', '', '')
        if os == 'Darwin' " Mac
            call frisk#debug#PrintMsg('opening with mac')
            execute 'silent !open ' . a:url
        elseif os == 'Linux' " Linux
            call frisk#debug#PrintMsg('opening with linux')
            execute 'silent !xdg-open ' . a:url . "&" 
        elseif has('win32unix') " Cygwin
            call frisk#debug#PrintMsg('opening with cygwin')
            execute 'silent !cmd /c start ' . a:url
        else 
            throw 'unknown system, please create a issue'
        endif
    else
        throw 'unknown system, please create a issue'
    endif
    redraw!
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
" frisk#SwitchCompletion()                                                   {{{
" Access the keys for the engine list, and add a '-' in front of them then
" return the list of completion items in a newline operated list.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! frisk#SwitchCompletion(ArgLead, CmdLine, CursorPos)
    call frisk#debug#PrintHeader("SwitchCompletion Debug")
    let completionOptions = '-'.join(keys(s:engine), "\n-")
    call frisk#debug#PrintMsg('The completion options =['
                \ .string(completionOptions).']')
    return completionOptions
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" frisk#AddEngine()                                                          {{{
" add a custom search engine to the list of engines
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! frisk#AddEngine(name, url)
    let s:engine[a:name] = a:url
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" frisk#DefaultEngine()                                                      {{{
" set the default search engine by name e.g. 'google' or 'stackOverFlow'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! frisk#DefaultEngine(name)
    let s:defualtEngine = s:engine[a:name]
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" vim:foldmethod=marker
