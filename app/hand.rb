# The hand that physically moves the pawn on another tile
# Hand->MOVING_RULES:
# MOVING_RULES->Moves:
# Moves->Move:
class Hand
  def initialize(move)
    @move = move
    @moving_piece = move.start_tile.piece # "Cached"
  end

  # NOTE: Mutates the states of tiles at runtime, not idempotent method
  # # TODO? rename move
  def call
    return unless valid?

    move.start_tile.piece = Pieces::Null.new
    move.destination_tile.piece = moving_piece
  end

  private

  attr_reader :move, :moving_piece

  def valid?
    {
      Pieces::Null => Moves::Null,
      Pieces::Pawn => Moves::Pawn,
      Pieces::Rook => Moves::Rook,
      Pieces::Knight => Moves::Knight,
      Pieces::Bishop => Moves::Bishop,
      Pieces::Queen => Moves::Queen,
      Pieces::King => Moves::King,
      Pieces::Bishop => Moves::Bishop,
      Pieces::Knight => Moves::Knight,
      Pieces::Rook => Moves::Rook
    }[moving_piece.class].new(move).valid?
  end
end
