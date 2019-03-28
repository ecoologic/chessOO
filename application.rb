# https://sequencediagram.org/
# title Pawns vs Kings
#
# participant Moves/Pawn
# participant Game
# participant Move
# participant Board
# participant Tile
# participant Pieces/Pawn
#
# Moves/Pawn->Move:
# Moves/Pawn->Board:
# Moves/Pawn->Tile:
#
# Move->Tile:
# Move->Pieces/Pawn:
#
# Game->Move:
# Game->Board:
#
# Board->Tile:
# Board->Pieces/Pawn:

# TODO: 2) Update diagram; 3) Tile -> Board?; 4) Board.new

require_relative 'app/board'
require_relative 'app/game'
require_relative 'app/move'
require_relative 'app/moves'
require_relative 'app/pieces'
require_relative 'app/position'
require_relative 'app/tile'

MOVING_RULES = {
  Pieces::Null => Moves::Null,
  Pieces::Pawn => Moves::Pawn,
  Pieces::Bishop => Moves::Bishop
}
