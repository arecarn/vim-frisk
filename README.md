Frisk
=====

Overview
--------
Frisk is a web search launcher compatible with Windows, OS X, and Linux. With
Frisk within Vim you can choose a search engine, and enter your search terms
without having to leave Vim. Upon accepting a search your default browser will
open with the results.

For a little more detail why this plugin was written see my post
[here](http://ryanpcarney.com/updatesnews/2013/6/11/frisk-the-web-search-vim-plugin).

**Supported Search Engines:**
* Bing (image, video, web)
* IMDb
* Stack Overflow
* Google (image, web, English-translate)
* Wolfram Alpha 
* Wikipedia

Usage
-----
    :Frisk<CR>

    :Frisk "search terms"<CR>  <-- uses the default search engine 

    :'<,'>Frisk<CR> <-- use visual selections instead of prompting for input

Demo
----

![Multiple Search Engines Demo](http://i.minus.com/ibnAscxZzh8agV.gif)

![Visual Selection Demo](http://i.minus.com/ibyU9aYE4tcFs6.gif)

![Default Search Demo](http://i.minus.com/ibk6UbFKFTZAtB.gif)

CONFIGURATION
-------------
> g:frisk_default_engine

Default = "google"

Sets the default search engine for when Frisk is called with search terms

Possible values:
- "bing images"
- "bing" 
- "bing video" 
- "imdb" 
- "google" 
- "google images" 
- "google translate" 
- "stack overflow" 
- "wikipedia" 
- "wolfram alpha"

Installation
-------------
Use your favorite addon manager.
* [Neobundle](https://github.com/Shougo/neobundle.vim) <-- I use this one
* [Vundle](https://github.com/gmarik/vundle)
* [pathogen](https://github.com/tpope/vim-pathogen)
* [VAM](https://github.com/MarcWeber/vim-addon-manager)

Search Engine Structure
-----------------------
Here's an example of how Bing Search engine information is stored in Frisk

```VimL
let g:Bing = {
            \'name' : 'Bing', 
            \'types':{
            \'video' : 'http://www.bing.com/video/search?q=',
            \'images' : 'http://www.bing.com/images/search?q=',
            \'web': 'http://www.bing.com/search?q='}}
call add(g:Search, Bing)
```

You might see how another search engine could easily be integrated into Frisk.
If you would like another search engine added contact me and I'll see what I
can do.


Known Issues
------------
- Can't make visual selection on a buffer with only 1 line.

Make Frisk Better
-----------------

I'm pretty new to Vim Script so any tips are appreciated. Think you can make
Frisk better? Fork it on GitHub and send a pull request. If you find bugs, want
new functionality, or would like another search engine added contact me by
making an issue on GitHub and I'll see what I can do. 


Credits
-------
- https://github.com/wcaleb/se-aliases/blob/master/se-aliases.sh
  W. Caleb McDaniel aka 'wcaleb' provided some of the search engine URLs

- http://www.if-not-true-then-false.com/2009/google-search-from-linux-and-unix-command-line/
  'JR' provided dome of the search engine URLs

- http://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript
  Peter Rodding aka 'xolox' provided function to capture visual selection

- http://patorjk.com/
  ASCII font in help file generated courtesy of Patrick Gillespie 

- https://github.com/g3orge/vim-voogle
  George Papanikolaou aka 'g3orge' similar project that helped me when I get the idea

