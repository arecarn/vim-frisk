Frisk
=====

Overview
--------
Frisk is a web search launcher compatible with Windows, OS X, and Linux. With
Frisk within Vim you can choose a search engine, and enter your search terms
without having to leave Vim. Upon accepting a search your default browser will
open with the results.

Supported search engines:
* Google (image, web, English translate)
* Bing (image, video, web)
* IMDb
* Stack Overflow
* Wolfram Alpha 
* Wikipeida

Demo
----

![Multiple Search Engines Demo](http://i.imgur.com/yzPI2lY.gif)

----

![Visual Selection Demo](http://i.imgur.com/wzZuyFQ.gif)

----

![Default Search Demo](http://i.imgur.com/BX2Z8Ns.gif)

Installation
-------------
If you don't have an preferred, method I recommend one of the following plugin
managers.
* [Neobundle](https://github.com/Shougo/neobundle.vim) 
* [Vundle](https://github.com/gmarik/vundle)
* [pathogen](https://github.com/tpope/vim-pathogen)
* [VAM](https://github.com/MarcWeber/vim-addon-manager)

Customization
-------------
Example: Adding Yahoo search engine
call frisk#AddEngine('yahoo', 'http://search.yahoo.com/search?p=')

Example: Making Bing the default Search Engine
frisk#DefaultEngine('bing')

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
