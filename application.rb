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
  Pieces::Tower => Moves::Tower,
  Pieces::Knight => Moves::Knight,
  Pieces::Bishop => Moves::Bishop,
  Pieces::Queen => Moves::Queen,
  Pieces::King => Moves::King,
  Pieces::Bishop => Moves::Bishop,
  Pieces::Knight => Moves::Knight,
  Pieces::Tower => Moves::Tower
}
