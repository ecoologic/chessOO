# Move->Board:
# Move->Tile:
# Move->Pieces:
# Move->Position:
#
# Composes the board, the moving piece and its destination
# to provide the properties a move
class Move
  def initialize(board, start_position_value, destination_position_value)
    @board = board
    @start_position = Position.new(start_position_value)
    @destination_position = Position.new(destination_position_value)
    raise RuntimeError, "Can't move an empty tile" unless start_tile.occupied?
  end

  def start_tile
    board.tile_at(start_position)
  end

  def destination_tile
    board.tile_at(destination_position)
  end

  def delta
    Position::Delta.new(start_position, destination_position)
  end

  def standing?
    start_position == destination_position
  end

  def free_corridor?
    delta.all_between.select { |p| board.tile_at(p).occupied? }.empty?
  end

  def in_board?
    board.include?(destination_position)
  end

  private

  attr_reader :board, :start_position, :destination_position
end
