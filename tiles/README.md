# TILES

## What is Tiles?

A combination board game for one player. The task is to arrange 72 tiles on a rectangular 12x8 board. Each tile has a color and a symbol. A tile must be placed next to another tile, and it must match either color or symbol of all adjacent tiles.

* There are 6 colors and 6 symbols, so there are 36 different tiles. Each tile exists twice in the game. The game starts with six tiles on the board.
* The tiles are drawn in random order, and you will see only one tile at a time.
* You can undo one turn at any point of the game, but not more than one.

The secondary task is to score as many points as possible. You get points for placing a tile, depending on the number of adjacent tiles:

* 1 tile: 1 point
* 2 tiles: 2 points
* 3 tiles: 4 points
* 4 tiles: 8 points

The game ends when all 66 tiles have been placed on the board or when the player decides to end, e.g. when there is no space for the next tile.

## Background information

I think the game was once presented in a computer magazine, and I just cloned it.

## How to run the game

An executable file is available here:

[tiles.zip](http://turbo.elitepiraten.de/tiles.zip)

You will need an emulator like [DOSBox](https://www.dosbox.com) to start the game.

## Files

* README.md - this document
* LIESMICH.TXT - German manual
* README.TXT - English manual
* LICENSE.TXT - license information
* THRON.PNG - image for download link
* THRON3GR.PAS - sourcecode for German keyboard layout
* THRON3US.PAS - sourcecode for US keyboard layout
