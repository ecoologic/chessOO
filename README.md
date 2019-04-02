# ChessOO - An Object-Oriented model of the Chess rules in Ruby

Written for readability.

Currently is doing all the basic moves, but no fancy ones like casteling.

I don't plan on finishing it, I'm just interested in some of the challenges
related to modelling the rules of the game.
This is a pretty unlikely domain to model at work,
and I would never refactor code to this point unless there's a proven business reason.

Yet, it's a good expression of my current (2019) modelling skills using
Object Oriented languages.

There is no frontend, the specs are the only consumers, and it's been developed TDD.
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

## Design

I am using a sequence diagram instead of a class diagram
because I like [sequencediagram.org](https://sequencediagram.org/)
(thank you guys).

Below is the list of dependencies of every model, paste them in the website above.

```
title ChessOO

participant Game
participant Hand
participant Moves
participant Move
participant Board
participant Tile
participant Pieces
participant Position

Game->Hand:
Game->Move:
Game->Board:
Game->Pieces:

Hand->Moves:
Hand->Move:
Hand->Tile:
Hand->Pieces:

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

* Don't create new tiles, define position values and use `board.tile_at`
* Print the board with `puts board` (and other objects)
* `binding.pry` is available

### Code walkthrough

1. Start in [`game_spec`](spec/game_spec.rb:69)
    > kills the king with the bishop
2. [`game`](app/game.rb) checks the game is not over
3. Uses the [`hand`](app/hand.rb) to make the move
4. The [`move`](app/move.rb) links the board to the pieces on the board
5. [`Board`](app/board.rb) is self-explanatory
6. In [`moves`](app/moves.rb) is where the logic for the pieces is
7. [`Position`](app/position.rb) has the math to navigate the board


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

* Change signature `Board::Tile.new(coordinates, piece)`
* Review private methods
* Make `Common` private

#### Maybes

* Rename `start -> beginning` or `initial, final`, or...
* Chainable `move.call`
* Engage [here](https://codereview.stackexchange.com/questions/116994/object-oriented-chess-game-in-ruby)

## Closing

Licence: See MIT-LICENCE file, no surprises there.

Contributions: Sure, why not, follow _any_ template.

_Have a good day!_
