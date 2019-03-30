# Game -> [BoardMove, Pieces]
class Game
  def initialize(board = Board.new)
    @board = board
  end

  # Game.new.move('E2', 'E3')
  def move(start_position_value, destination_position_value)
    return unless on?
    return unless board.include?(destination_position_value)

    start_tile = board.tile_at(start_position_value)
    destination_tile = board.tile_at(destination_position_value)
    move = Move.new(board, start_tile, destination_tile)

    move.call
  end

  def on?
    board.pieces_by_class(Pieces::King).count == 2
  end

  private

  attr_reader :board
end
