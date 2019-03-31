# Executes one valid move or attack within the rules of the game
# Move->Board:
# Move->Tile:
# Move->Pieces:
# Move->Position:
class Move
  def initialize(board, start_tile, destination_tile)
    @board = board
    @start_tile, @destination_tile = start_tile, destination_tile
    @moving_piece = start_tile.piece
    raise RuntimeError, "Can't move an empty tile" unless start_tile.occupied?
  end

  attr_reader :start_tile, :destination_tile, :moving_piece

  # NOTE: Mutates the states of tiles at runtime, not idempotent method
  def call
    return unless valid?

    start_tile.piece = Pieces::Null.new
    destination_tile.piece = moving_piece
  end

  def standing?
    start_tile == destination_tile
  end

  def delta_coordinates
    Position::Delta.new(start_tile.position, destination_tile.position).position
  end

  def free_corridor?
    positions = Position::Delta.new(start_tile.position, destination_tile.position).all_between
    positions.select { |p| board.tile_at(p.to_s).occupied? }.empty?
  end

  private

  attr_reader :board

  def valid?
    MOVING_RULES[moving_piece.class].new(self).valid?
  end
end
