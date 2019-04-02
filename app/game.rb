# Game->Hand:
# Game->Move:
# Game->Board:
# Game->Pieces:
class Game
  def initialize(board = Board.new)
    @board = board
  end

  # Game.new.move('E2', 'E3') # Moves the white pawn
  def move(start_position_value, destination_position_value)
    return unless on?

    hand = Hand.new(Move.new(board,
                             start_position_value,
                             destination_position_value))

    hand.call
  end

  def on?
    board.pieces_by_class(Pieces::King).count == 2
  end

  private

  attr_reader :board
end
