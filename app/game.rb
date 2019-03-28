# TODO? Turn?
class Game
  def initialize(board = Board.new)
    @board = board
  end

  def move(start_position_value, destination_position_value)
    start_tile = board.tile_at(start_position_value)
    destination_tile = board.tile_at(destination_position_value)

    Move.new(start_tile, destination_tile).call
  end

  private

  attr_reader :board
end
