module Moves
  class Pawn
    def initialize(move)
      @move = move
    end

    def call
      (!move.destination_cell.occupied? && valid_move_destination?) ||
        (move.destination_cell.occupied? && right_attack?)
      # TODO: left attack
    end

    private

    attr_reader :move

    def valid_move_destination?
      move.start_cell.x == move.destination_cell.x &&
        move.destination_cell.x - move.start_cell.x <= 2
      # TODO: two only for start position
    end

    def right_attack?
      ((move.destination_cell.x - move.start_cell.x == 1) &&
        (move.destination_cell.y - move.start_cell.y == 1))
    end
  end
end

class Move
  MOVE_RULES = { "Pieces::Pawn" => Moves::Pawn } # TODO: not strings

  attr_reader :start_cell, :destination_cell, :moving_piece

  def initialize(start_cell, destination_cell)
    @start_cell, @destination_cell = start_cell, destination_cell
    @moving_piece = start_cell.piece
  end

  def to_s
    "[#{type}] #{start_cell} -> #{destination_cell}"
  end

  def call
    return unless can_move?

    start_cell.piece = Pieces::Null.new
    destination_cell.piece = moving_piece
  end

  private

  def can_move?
    MOVE_RULES[moving_piece.class.to_s].new(self).call
  end
end

class Cell # TODO: Tile?
  def initialize(x, y, piece = Pieces::Null.new)
    @x, @y, @piece = x, y, piece
  end

  def to_s
    "#{x},#{y}"
  end

  attr_reader :x, :y
  attr_accessor :piece

  def ==(other_cell)
    other_cell.x == x && other_cell.y == y
  end

  def occupied?
    piece.present?
  end
end

module Pieces
  class Abstract
    def initialize
      @id = rand # TODO: color
    end

    attr_reader :id

    def to_s
      inspect
    end

    def inspect
      "#<#{self.class}:#{id}>"
    end

    def ==(other_piece)
      other_piece.id == id
    end

    def present?
      true
    end
  end

  class Pawn < Abstract; end
  class King < Abstract; end

  class Null < Abstract # TODO: singleton
    def inspect
      "#<Pieces::Null>"
    end

    def ==(other_piece)
      !other_piece.present?
    end

    def present?
      false
    end
  end
end
