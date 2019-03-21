class Chess
  def initialize
    start_cell, destination_cell = Cell.new(:a, 1), Cell.new(:a, 2)
    Move.new(start_cell, destination_cell).call
  end
end

class Move
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
    destination_cell.piece != Pieces::Null.new
  end

  def do_move
    start_cell.piece = Pieces::Null.new
    destination_cell.piece = moving_piece
  end
end

class Cell
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

    def nil?
      false
    end
  end

  class Pawn < Abstract
  end

  # TODO: singleton
  class Null < Abstract
    def inspect
      "#<Pieces::Null>"
    end

    def ==(other_piece)
      other_piece.nil?
    end

    def nil?
      true
    end
  end
end
