i've had this idea for a game that does not require any art skills of any kind, pure programming and interesting story telling and game design. this has resulted in the file 'IDEA.md'. this is a very early phase file, just all my ideas and some references of games i really enjoyed and that inspired this. i am a huge fallout and wasteland fan. i am also currently watching the 'silo' tv series which is great. all these references plus the fact i hate drawing any kind of art from 3d models to pixelart. i am a huge linux user so the terminal just feels like home. anyway, my engine of choice has always been love2d for everything, so this time as well. so this is what we have for now:

- engine: love2d
- main idea file: IDEA.md
- font: 'ibm_plex_mono' directory

the only library i figured we might need is a shader library to add a bit of visuals. the de-facto for the love2d ecosystem is moonshine. i added the latest release of the library in the 'moonshine' directory as well as added 'moonshine.md' which is the library readme if you need. this should be THE ONLY LIBRARY WE MAKE USE OF.

there is one last reference i found while browsing the internet: it's in the 'lv_100' directory. THIS SHOULD ONLY BE USED AS REFERENCE NO CODE SHOULD BE IMPORTED FROM THIS DIRECTORY. this is a super nice reference implementation of the terminal aesthetic i found on github using love2d. it has a nice library implementation and many examples and a readme you can study, really cool!!

so this is all that is currently present in this repository. i want to try and see how far you can go in one prompt! try and build as much as you can, should be super super polished, try and invent a story, mechanics, make it super interesting. divide it in all the files you need.

- you can use all the lua files you need
- we need a conf.lua file
- window should be resizable
- you should handle the scaling of the window effortlessly

think of everything, nothing should just go overlooked. you are tasked with creating a full demo that is super interesting and can sell the idea: ~10+ minutes of gameplay at least. i think you have all the info you need!

i added one last thing: some sound pack i found on the internet that should be related to our theme. i know you can't listen to the sounds, but try and figure out what the sound is based on the length of the file and the filename! they are here: 'term_ui_sounds'.

one last thing: remember you have access to the context7 mcp server for any documentation you may need, don't hesistate to use it!
