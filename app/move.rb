# Executes one valid move or attack within the rules of the game
# Move->Board:
# Move->Tile:
# Move->Pieces:
# Move->Position:
class Move
  def initialize(board, start_position_value, destination_position_value)
    @board = board
    @start_position = Position.new(start_position_value)
    @destination_position = Position.new(destination_position_value)
    raise RuntimeError, "Can't move an empty tile" unless start_tile.occupied?
  end

  def start_tile
    board.tile_at(start_position.to_s)
  end

  def destination_tile
    board.tile_at(destination_position.to_s)
  end

  def delta_position
    Position::Delta.new(start_position, destination_position).position
  end

  def standing?
    start_position == destination_position
  end

  def free_corridor?
    positions = Position::Delta.new(start_position, destination_position).all_between
    positions.select { |p| board.tile_at(p.to_s).occupied? }.empty?
  end

  def in_board?
    board.include?(destination_position.to_s)
  end

  private

  attr_reader :board, :start_position, :destination_position
end
