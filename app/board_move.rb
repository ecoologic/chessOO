# BoardMove -> [Board, Move]
# TODO: remove?
class BoardMove
  def initialize(board, move)
    @board, @move = board, move
  end
  #
  # def valid?
  #   board.include?(move.destination_tile)
  # end

  private

  attr_reader :board, :move
end
