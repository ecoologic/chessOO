# Executes one valid move or attack within the rules of the game
# Move -> [Board, Tile, Pieces, Position]
class Move
  def initialize(start_tile, destination_tile)
    @start_tile, @destination_tile = start_tile, destination_tile
    @moving_piece = start_tile.piece
    raise RuntimeError, "Can't move an empty tile" unless start_tile.occupied?
  end

  attr_reader :start_tile, :destination_tile, :moving_piece

  # NOTE: Mutates the states of tiles at runtime, not idempotent method
  def call
    return unless can_move?

    start_tile.piece = Pieces::Null.new
    destination_tile.piece = moving_piece
  end

  def in_board?
    Board.include?(destination_tile)
  end

  def delta_coordinates
    start_tile.position.delta(destination_tile.position)
  end

  private

  def can_move?
    MOVING_RULES[moving_piece.class].new(self).call
  end
end
