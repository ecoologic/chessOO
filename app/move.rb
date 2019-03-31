# Executes one valid move or attack within the rules of the game
# Move->Board:
# Move->Tile:
# Move->Pieces:
# Move->Position:
class Move
  # TODO: take positions, not tiles
  def initialize(board, start_tile, destination_tile)
    @board = board
    @start_tile, @destination_tile = start_tile, destination_tile
    raise RuntimeError, "Can't move an empty tile" unless start_tile.occupied?
  end

  attr_reader :start_tile, :destination_tile, :moving_piece

  def standing?
    start_tile == destination_tile
  end

  def delta_position
    Position::Delta.new(start_tile.position, destination_tile.position).position
  end

  def free_corridor?
    positions = Position::Delta.new(start_tile.position, destination_tile.position).all_between
    positions.select { |p| board.tile_at(p.to_s).occupied? }.empty?
  end

  private

  attr_reader :board
end


# TODO: extract these
# Move->MOVING_RULES:
# MOVING_RULES->Moves:
# Moves->TileMove:
# Move->TileMove:
# or...
# Hand->MOVING_RULES:
# MOVING_RULES->Moves:
# Moves->Move:

