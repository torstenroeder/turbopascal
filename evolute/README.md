# EVOLUTE

## What is Evolute?

A simple [predator-prey simulation](https://en.wikipedia.org/wiki/Lotka%E2%80%93Volterra_equations) in two variants.

## Rules

The simulation takes place on a grid. The squares are populated by either grass, rabbits or wolves (or also humans). Each step in time, one square is determined randomly. Depending on the population on that square and on the surrounding squares, specific rules are applied.

## Variants

### EVOLUTE

This simulation features four states: EBENE, GRAS, HASE, and WOLF (plains, grass, rabbit, wolf).

* EBENE becomes GRAS. (= grass grows anywhere)
* GRAS becomes HASE if there is a HASE nearby. (= rabbits procreate on grass)
* HASE becomes WOLF if there is a WOLF nearby. (= wolves eat rabbits)
* WOLF becomes EBENE. (= wolves just die)
	
### EVOLUTE2

This simulation features five states: EBENE, GRAS, HASE, WOLF, and MENSCH (plains, grass, rabbit, wolf, human).

* EBENE becomes GRAS. (= grass grows anywhere)
* GRAS becomes HASE if there is a HASE nearby. (= rabbits just pop up on grass)
* HASE:
  * if there is a WOLF nearby, it becomes WOLF; (= wolves eat rabbits)
  * otherwise, if there is a HUMAN nearby, it becomes HUMAN; (= humans like rabbits too)
  * otherwise, if there is a HASE nearby, it becomes GRAS. (= rabbit overpopulation)
* WOLF becomes MENSCH if there is a MENSCH nearby, otherwise it becomes EBENE. (= wolves are shot or they just die)
* MENSCH becomes EBENE if there is a MENSCH nearby. (= humans kill each other)

## How to run the simulation

Executable files are available here: [evolute.zip](http://turbo.elitepiraten.de/evolute.zip)

You will need an emulator like [DOSBox](https://www.dosbox.com) to start the game.

## Files

* EVOLUTE.PAS - Turbo Pascal sourcecode
* EVOLUTE2.PAS - Turbo Pascal sourcecode
* LICENSE.TXT - license information
* README.md - this document
