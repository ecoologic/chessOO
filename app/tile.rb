# Each cell of the board, binds the piece to its position
# Tile->Pieces:
# Tile->Position:
# NOTE: mutable object
class Tile
  def initialize(position_value, piece = Pieces::Null.new)
    @position = Position.new(position_value)
    @piece = piece
  end

  attr_reader :position
  attr_accessor :piece

  def ==(other_tile)
    position == other_tile.position
  end

  def occupied?
    piece.present?
  end
end
