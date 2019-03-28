# A Ruby Chess~ish Game

I will never finish this, I'm just interested in some of the challenges related to modelling the rules of the game.

There is no frontend, the specs are the only consumers.


## Notes

* I've been careful with dependency direction
* Naming, modularity and readability is to my satisfaction
* It's almost TDD
* I usually don't leave TODOs in the master branch when working in a team
* It's a good expression of my current (2019) mastery of the Ruby language


## Installation

```
bin/bundle
bin/rspec
```

That's it, there are only specs.


## Development

Keep guard up, write some spec and make it green.

```
bin/guard
```


### TODOs

* (?) Invert dependency direction Title -> Board
* Inject a board instance instead of relying on Board


## Design

I am using a sequence diagram instead of a class diagram
because I like [sequencediagram.org](https://sequencediagram.org/).

```
title Chesso

participant Game
participant MOVING_RULES
participant Moves
participant Move
participant Board
participant Tile
participant Pieces
participant Position

Game->Move:
Game->Board:

MOVING_RULES->Moves:
MOVING_RULES->Pieces:

Moves->Move:
Moves->Tile:

Move->Board:
Move->Tile:
Move->Pieces:
Move->Position:

Board->Tile:
Board->Pieces:

Tile->Pieces:
Tile->Position:
```


## Conslusions

Licence: See MIT-LICENCE file, no surprises there.

Contributions: Sure, why not.

Author: Erik Ecoologic

