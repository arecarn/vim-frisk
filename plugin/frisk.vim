"A cross platform compatible (Windows/Linux/OSX) plugin that facilitates
"entering a search terms and opening web browsers 
"Last Change: 11 Jun 2013
"Maintainer: Ryan Carney arecarn@gmail.com
"License: This file is placed in the public domain.
"
"Change Log
"10 Jun 2013 added URL encoding 
"
command! Frisk call Search()

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

"===============================================================================
"Search() - Prompts the user for the type of internet search they would like to
"           perform and then prompts them for types of searches associated
"           with that search engine if there are more than one.
"===============================================================================
function! Search()
    let i = 1
    let list = [] 
    for eng in g:Search
        call add(list, string(i) . ". " . eng.name)
        "echom string(list)
        let i = i + 1 
    endfor

    "prompt the user for their search engine of choice
    let engine_choice = inputlist(list) 
    "return if invalid range
    let engine_choice = engine_choice -1
    let engine_choices_length = len(list) 
    if engine_choice < engine_choices_length  && engine_choice >= 0 
    else
        return
    endif 

    "prompt the user for different options for thier search engine
    " if there is only one option for the search then defualt to it. 
    if len(keys(g:Search[engine_choice].types)) > 1 
        let type_choices = ''
        for type in keys(g:Search[engine_choice].types)
            let type_choices = type_choices . '&' . type . "\n"
            "echom type_choices
        endfor
        " confirm returns 1 and greater so decrement once for list indexing
        let type_choice = confirm("Choose Your Search Type: ", type_choices, 1) - 1
    else 
        let type_choice = 0
    endif 


    let type_keys = keys(g:Search[engine_choice].types)
    "echom type_keys
    let type_key = type_keys[type_choice]
    "echom type_key

    let search_engine = g:Search[engine_choice].types[type_key]
    "echom search_engine

    "TODO should input be bundled into a function?
    "ask the user what they would like to search 
    call inputsave()
    let query = input('What Do You Want To Search: ')
    call inputrestore()

    let query = EncodeSerch(query)
    "build the the search string and call the external program 
    let q = substitute(query, ' ', "+", "g")
    if has("mac")
        exe '!open ' . search_engine . q
    elseif  has("win16") || has("win32") || has("win64")
        exe 'silent! ! start /min ' . search_engine . q
    elseif has("unix")
        exe '!xdg-open ' . search_engine . q . "&" 
        "note that a "&" has to follow the search query for some reason
    endif
endfunction

function! EncodeSerch(q)
    echo a:q
    let list = split(a:q,'\zs')
    echo list 
   let hexList=[] 
    for char in list
        let char = substitute(char, '.',  '\=printf("%02X",char2nr(submatch(0)))', '')
        let char =  '%%' . char
        call add(hexList, char)
        echo char 
    endfor
    return join(hexList,"")
endfunction

" add checking for http:// and .com,.org ect 
" else just searches google?
"browser commands gs to goto a site check to see if http exists 
if  has("win16") || has("win32") || has("win64")
    nnoremap gs yiW:silent ! start /min <C-R>"<CR>
elseif has('mac')
    nnoremap gs yiW:!open '<C-R>"'<CR>
elseif has('unix')
    nnoremap gs yiW:!xdg-open '<C-R>"'&<CR> 
endif

