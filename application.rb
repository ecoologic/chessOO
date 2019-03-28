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


# TODO: 1) Split file; 2) Update diagram; 3) Tile -> Board?; 4) Board.new


MOVING_RULES = {
  Pieces::Null => Moves::Null,
  Pieces::Pawn => Moves::Pawn,
  Pieces::Bishop => Moves::Bishop
}
