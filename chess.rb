# Moves -> [Move, Board, Cell]
module Moves
  class Null
    def initialize(_move); end
    def call; false; end
  end

  class Pawn
    def initialize(move)
      @move = move
    end

    def call
      return false unless Board.include?(move.destination_cell)

      (!move.destination_cell.occupied? && valid_move_destination?) ||
        (move.destination_cell.occupied? && right_attack?)
      # TODO: left attack
    end

    private

    attr_reader :move

    def valid_move_destination?
      move.start_cell.x == move.destination_cell.x &&
        move.destination_cell.x - move.start_cell.x <= 1
    end

    def right_attack?
      (move.destination_cell.x - move.start_cell.x).abs == 1 &&
        (move.destination_cell.y - move.start_cell.y).abs == 1
    end
  end
end

# Move -> [Moves, Cell, Piece]
class Move
  RULES = {
    "Pieces::Null" => Moves::Null,
    "Pieces::Pawn" => Moves::Pawn
  } # TODO: not strings

  def initialize(start_cell, destination_cell)
    @start_cell, @destination_cell = start_cell, destination_cell
    @moving_piece = start_cell.piece
    raise ArgumentError, "Can't move an empty cell" unless start_cell.occupied?
  end

  attr_reader :start_cell, :destination_cell, :moving_piece

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
    RULES[moving_piece.class.to_s].new(self).call
  end
end

# Moves
##############################################################################
# Board and Cell

# Board -> [Move, Cell, Pieces, position]
# # TODO? Board connects cell and piece?
# Borders starting from 0 to 7
class Board
  def self.include?(cell)
    (0..7).to_a.include?(cell.x) &&
      (0..7).to_a.include?(cell.y)
  end

  def self.initial_disposition
    _, p, k = Pieces::Null, Pieces::Pawn, Pieces::King
    [ # A B  C  D  E  F  G  H
      [p, p, p, k, p, p, p, p].each_with_index.map { |p, i| Cell.new(i, 0, p.new) },
      [p, p, p, p, p, p, p, p].each_with_index.map { |p, i| Cell.new(i, 1, p.new) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |p, i| Cell.new(i, 2, p.new) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |p, i| Cell.new(i, 3, p.new) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |p, i| Cell.new(i, 4, p.new) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |p, i| Cell.new(i, 5, p.new) },
      [p, p, p, p, p, p, p, p].each_with_index.map { |p, i| Cell.new(i, 6, p.new) },
      [p, p, p, k, p, p, p, p].each_with_index.map { |p, i| Cell.new(i, 7, p.new) },
    ] # TODO: .reverse # and invert the y value in cell creation, use nil for matrix[0]
  end

  def initialize(matrix = self.class.initial_disposition)
    @matrix = matrix
  end

  def move(start_position, destination_position)
    move = Move.new(cell_at(start_position),
                    cell_at(destination_position))
    move.call
  end

  # E.g.: 'E5'
  def cell_at(position)
    letter_x, letter_y = position.chars
    x = letter_x.upcase.bytes.first - 'A'.bytes.first
    y = letter_y.to_i - 1 # Classic -1: index starting at 0
    row = matrix[y]
    row[x]
  end

  private

  # NOTE: Access is matrix[y][x] (first access the row)
  attr_reader :matrix
end

# Cell -> [Piece]
class Cell # TODO: Tile?
  def initialize(x, y, piece = Pieces::Null.new)
    @x, @y, @piece = x, y, piece
  end

  attr_reader :x, :y
  attr_accessor :piece

  def to_s
    "#{x},#{y}"
  end

  def ==(other_cell)
    other_cell.x == x && other_cell.y == y
  end

  def occupied?
    piece.present?
  end
end

# Board and Cell
##############################################################################
# Pieces

# Pieces -> [Piece]
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
