# Tile -> [Pieces, Position]
# NOTE: mutable object
class Tile
  def initialize(position_value, piece = Pieces::Null.new)
    @position = Position.new(position_value)
    @position_value = position_value # TODO: remove in tests
    @piece = piece
  end

  attr_reader :position, :position_value
  attr_accessor :piece

  def inspect
    "#<#{position_value}:#{piece.to_sym}>"
  end

  def ==(other_tile)
    position == other_tile.position
  end

  def occupied?
    piece.present?
  end
end
