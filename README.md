# Chess0 - An Object-Oriented model of the Chess rules in Ruby

Written for readability.

Currently is doing all the basic moves, but no fancy ones like casteling.

I will never finish this, I'm just interested in some of the challenges
related to modelling the rules of the game.
While this is a pretty unlikely domain to model at work,
it's a good expression of my current (2019) modelling skills using
Object Oriented languages.

There is no frontend, the specs are the only consumers.
Take a peek starting at `spec/game_spec.rb:40` and follow the code along.

Feel free to contact me for design questions or lessons.

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
* Git history is not too bad

## Design

I am using a sequence diagram instead of a class diagram
because I like [sequencediagram.org](https://sequencediagram.org/)
(thank you guys).

Below is the list of dependencies of every model,
[here is a nice graphic representation](https://sequencediagram.org/index.html#initialData=C4S2BsFMAIGEAtIGckHkBQ6AOBDATqAMYi4B2w0A4jgLaTb5Ek7nQCyqAagJIBylAfQBKAVQAyAUQDKDAiGJkKAIQD2+ACZsVAN3q45ClhS26kspovY69jec1aqN5u5YAqIKM8OsACiEiEyF72FD4qSGAgKqSY1HQAtAB8jnjqAFzocZBJfgHIGegcPPzC4tJJJvmFXHyCopJSOf6BSAWF1kgV1hmVnYnuUD0dOeGR0QWVSSnp7bpJA5BDc4m5LUvZK6Og45jT8x6L6HsrzVVHaqkjEdukGQtNea3o95vXUbfoQA).

```
title ChessO

participant Game
participant MOVING_RULES
participant BoardMove
participant Moves
participant Move
participant Board
participant Tile
participant Pieces
participant Position

Game->Board:
Game->Pieces:

MOVING_RULES->Moves:
MOVING_RULES->Pieces:

Moves->Move:
Moves->Tile:
Moves->Position:

Move->Board:
Move->Tile:
Move->Pieces:
Move->Position:

Board->Tile:
Board->Pieces:

Board->Position:
Tile->Pieces:
Tile->Position:

# TODO
Move->MOVING_RULES:
```


## Installation

```
bin/bundle
bin/rspec --format documentation
```

That's it, there are only specs.


## Development

Keep guard up, write a spec and make it green.

```
bin/guard
```

**NOTE:** Use `puts board` to ease the debug.

### Chess TODOs

* COLORS!!
* Castelling
* Pawns enpassant
* Pawn enpassant kill
* Pawn promotion
* Pawn opening of 2
* King under attack
* Draw rules

### Tech TODOs

* Fix and rename `MOVING_RULES`
* Update diagram
* Rcov?
* Review private methods
* Make `Common` private

#### Maybes

* Change signature `Tile.new(position, piece)`
* Rename `start -> beginning` or `initial, final`, or...
* Invert dependency direction `Title -> Board`
* Rename `Game -> Turn`
* Move returning `destination_position`
* Engage [here](https://codereview.stackexchange.com/questions/116994/object-oriented-chess-game-in-ruby)


## Closing

Licence: See MIT-LICENCE file, no surprises there.

Contributions: Sure, why not, follow _any_ template.

Have a good day!
