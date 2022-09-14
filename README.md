# Nike Engine 
Play The Original game here [Newgrounds](https://www.newgrounds.com/portal/view/770371) [Itch.io](https://ninja-muffin24.itch.io/funkin)

### Every Modification or Recreation HAS to be open source.

## Credits
# Nike Engine Credits
* JuniorNova - Main Programmer
* BushTrain460615 - Main Programmer
# Base Game Credits
* [ninjamuffin99](https://twitter.com/ninja_muffin99) - Programmer
* [PhantomArcade3K](https://twitter.com/phantomarcade3k) and [Evilsk8r](https://twitter.com/evilsk8r) - Art
* [Kawaisprite](https://twitter.com/kawaisprite) - Musician
-------------------------------------------------------------
# IF YOU WANT TO COMPILE THE GAME YOURSELF, CONTINUE READING!!! 

### Installing the Required Programs

First, you need to install Haxe and HaxeFlixel. I'm too lazy to write and keep updated with that setup (which is pretty simple). 
1. [Install Haxe 4.2.5](https://haxe.org/download/version/4.2.5/)
2. [Install HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/) after downloading Haxe
3. [Install git-scm](https://git-scm.com/downloads) after downloading HaxeFlixel

Other installations you'd need are the additional libraries, a fully updated list will be in `Project.xml` in the project root. Currently, these are all of the things you need to install:
```
haxelib install flixel
haxelib install flixel-addons
haxelib install flixel-ui
haxelib install hscript
haxelib git polymod https://github.com/BushTrain460615/polymod
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib git hxCodec https://github.com/polybiusproxy/hxCodec
haxelib git crashdumper http://github.com/larsiusprime/crashdumper
haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons  <--Optional to fix transitions bug in songs with zoomed-out cameras
```

You should have everything ready for compiling the game! Follow the guide below to continue!

### Compiling game
NOTE: If you see any messages relating to deprecated packages, ignore them. They're just warnings that don't affect compiling

If building on windows install these tools:
* MSVC v142 - VS 2019 C++ x64/x86 build tools
* Windows SDK (10.0.17763.0)

### HTML5 build is updated everytime a new push is made.
https://juniornovoa1.github.io/Nike-Engine/

### Building the game in release mode
```
lime build mac
lime build windows
lime build linux
```
### Building the game in debug mode
```
lime build mac -debug
lime build windows -debug
lime build linux -debug
```
You can run the game from the file under export/release/The platform you built on/bin
