Frisk
=====
Frisk is a web search launcher. With Frisk within Vim you can choose a search
engine, and enter your search terms without having to leave vim. Upon accepting
a search your default browser will open with the results. 

Usage
-----
:Frisk

Demo
----
A screen capture demoing Frisk can be viewed [HERE](http://screenr.com/Sn2H)

Adding Your Own Search Engine
-----------------------------
here's an example of how Bings Search engine infromation is stored in a plugin

```
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
can do



Make Frisk Better
-----------------
This is my first Vim plugin so if you have any tips or ideas to make frisk
better feel free to contact me or open an issue.  
