# The hand moves the piece on another tile if it's valid
# Hand->Moves:
# Hand->Move:
# Hand->Tile:
# Hand->Pieces:
class Hand
  def initialize(move)
    @move = move
    @moving_piece = move.start_tile.piece # "Cached" before move
  end

  # NOTE: Mutates the states of tiles at runtime, not idempotent method
  def call
    return unless move.in_board? # TODO? in Hand

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
