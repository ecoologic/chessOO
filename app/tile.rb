# Tile -> [Pieces, Position]
# NOTE: mutable object
class Tile
  def initialize(position_value, piece = Pieces::Null.new)
    @position = Position.new(position_value)
    @position_value = position_value # TODO: Only used for tests, make private
    @piece = piece
  end

  attr_reader :position, :position_value
  attr_accessor :piece

  def ==(other_tile)
    position == other_tile.position
  end

  def occupied?
    piece.present?
  end
end
