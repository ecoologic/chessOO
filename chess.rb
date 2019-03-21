class Move
  RULES = { # TODO: not strings
    "Pieces::Null" => ->(_, _, _) {},
    "Pieces::Pawn" => ->(_start_cell, destination_cell, _piece) {
      !destination_cell.piece.present?
    }
  }
  def initialize(start_cell, destination_cell)
    @start_cell, @destination_cell = start_cell, destination_cell
    @moving_piece = start_cell.piece
  end

  def to_s
    "[#{type}] #{start_cell} -> #{destination_cell}"
  end

  def call
    do_move if can_move?
    destination_cell.piece == moving_piece
  end

  private

  attr_reader :start_cell, :destination_cell, :moving_piece

  def can_move?
    RULES[moving_piece.class.to_s].call(start_cell, destination_cell, moving_piece)
  end

  def do_move
    start_cell.piece = Pieces::Null.new
    destination_cell.piece = moving_piece
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
      @id = rand
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

  class Null < Abstract # TODO: singleton
    def inspect
      "#<Pieces::Null>"
    end

    def ==(other_piece)
      other_piece.present?
    end

    def present?
      false
    end
  end
end
