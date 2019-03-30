# A Ruby Chess~ish Game

I will never finish this, I'm just interested in some of the challenges
related to modelling the rules of the game.

While this is a pretty unlikely domain to model at work,
it's a good expression of my current (2019) modelling skills.

There is no frontend, the specs are the only consumers.

```
puts Board.new
     .A .B .C .D .E .F .G .H
| .8 Pa Kn Bi Pa Ki Bi Kn Pa 8. |
| .7 Pa Pa Pa Pa Pa Pa Pa Pa 7. |
| .6 __ __ __ __ __ __ __ __ 6. |
| .5 __ __ __ __ __ __ __ __ 5. |
| .4 __ __ __ __ __ __ __ __ 4. |
| .3 __ __ __ __ __ __ __ __ 3. |
| .2 Pa Pa Pa Pa Pa Pa Pa Pa 2. |
| .1 Pa Kn Bi Pa Ki Bi Kn Pa 1. |
   .A .B .C .D .E .F .G .H
```


## Notes

* I've been careful with dependency direction
* Naming, modularity and readability is to my satisfaction
* It's almost TDD
* I usually don't leave TODOs in the master branch when working in a team


## Design

I am using a sequence diagram instead of a class diagram
because I like [sequencediagram.org](https://sequencediagram.org/)
(thank you guys).

Below is the list of dependencies of every model,
use the website above for a nice graphic representation.

```
title Chesso

participant Game
participant MOVING_RULES
participant BoardMove
participant Moves
participant Move
participant Board
participant Tile
participant Pieces
participant Position

Game->BoardMove:
Game->Pieces:

MOVING_RULES->Moves:
MOVING_RULES->Pieces:

BoardMove->Board:
BoardMove->Move:

Moves->Move:
Moves->Tile:

Move->Tile:
Move->Pieces:
Move->Position:

Board->Tile:
Board->Pieces:

Tile->Pieces:
Tile->Position:
```


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

**NOTE:** Use `puts board` to ease the debug.

### Chess TODOs

* COLORS!!
* Bishop/Tower corridor check
* Castelling
* Pawns enpassant
* Pawn enpassant kill
* Pawn promotion
* Pawn opening of 2
* King available moves
* Draw rules

### Tech TODOs

* Rcov?
* `Moves::Queen` etc, make `Common` private

#### Maybes

* Change signature `Tile.new(position, piece)`
* Rename `start -> beginning` or `initial, final`, or...
* Invert dependency direction `Title -> Board`
* Rename `Game -> Turn`


## Closing

Licence: See MIT-LICENCE file, no surprises there.

Contributions: Sure, why not.

Author: Erik Ecoologic

Feel free to contact me for design questions or lessons.
