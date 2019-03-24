# https://sequencediagram.org/
# title Pawns vs Kings
#
# participant Moves/Pawn
# participant Game
# participant Move
# participant Board
# participant Tile
# participant Pieces/Pawn
#
# Moves/Pawn->Move:
# Moves/Pawn->Board:
# Moves/Pawn->Tile:
#
# Move->Tile:
# Move->Pieces/Pawn:
#
# Game->Move:
# Game->Board:
#
# Board->Tile:
# Board->Pieces/Pawn:

# Moves -> [Move, Board, Tile]
module Moves
  class Null
    def initialize(_move); end
    def call; false; end
  end

  class Abstract
    def initialize(move)
      @move = move
    end

    def call
      if !Board.include?(move.destination_tile)
        false
      elsif move.destination_tile.occupied?
        valid_attack?
      else
        valid_move?
      end
    end

    private

    attr_reader :move

    def valid_move?
      raise NotImplementedError
    end

    def valid_attack?
      raise NotImplementedError
    end

    def delta_coordinates
      Board.delta_coordinates(move.start_tile, move.destination_tile)
    end

    def delta_x
      delta_coordinates.first
    end

    def delta_y
      delta_coordinates.last
    end
  end

  # NOTE: position.abs -> workaround while we don't have black/white player
  class Pawn < Moves::Abstract
    def valid_move?
      delta_x.zero? && delta_y.abs == 1
    end

    def valid_attack?
      delta_x.abs == 1 && delta_y.abs == 1
    end
  end
end

# Move -> [Moves, Tile]
class Move
  def initialize(start_tile, destination_tile)
    @start_tile, @destination_tile = start_tile, destination_tile
    @moving_piece = start_tile.piece
    raise ArgumentError, "Can't move an empty tile" unless start_tile.occupied?
  end

  attr_reader :start_tile, :destination_tile, :moving_piece

  def inspect
    "<#{start_tile} -> #{destination_tile}>"
  end

  def call
    return unless can_move?

    start_tile.piece = Pieces::Null.new
    destination_tile.piece = moving_piece
  end

  private

  def can_move?
    MOVING_RULES[moving_piece.class].new(self).call
  end
end

class Game
  def initialize(board)
    @board = board
  end

  def move(start_position, destination_position)
    start_tile = board.tile_at(start_position)
    destination_tile = board.tile_at(destination_position)

    Move.new(start_tile, destination_tile).call
  end

  private

  attr_reader :board
end

# Moves
##############################################################################
# Board and Tile

# Board -> [Tile, Pieces]
# Borders starting from 0 to 7
class Board
  def self.initial_disposition
    _, p, k = Pieces::Null, Pieces::Pawn, Pieces::King
    [ # A B  C  D  E  F  G  H
      [p, p, p, k, p, p, p, p].each_with_index.map { |p, x| tile_for([x, 0], p) },
      [p, p, p, p, p, p, p, p].each_with_index.map { |p, x| tile_for([x, 1], p) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |p, x| tile_for([x, 2], p) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |p, x| tile_for([x, 3], p) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |p, x| tile_for([x, 4], p) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |p, x| tile_for([x, 5], p) },
      [p, p, p, p, p, p, p, p].each_with_index.map { |p, x| tile_for([x, 6], p) },
      [p, p, p, k, p, p, p, p].each_with_index.map { |p, x| tile_for([x, 7], p) },
    ]
  end

  def self.tile_for(coordinates, piece_class)
    Tile.new(position_for(coordinates), piece_class.new)
  end

  # E.g.: [4, 5] -> 'E6'
  def self.position_for(coordinates)
    x, y = coordinates
    letter_x = ('A'.bytes.first + x).chr
    number_y = y + 1

    "#{letter_x}#{number_y}"
  end

  # E.g.: 'E5' -> [4, 4]
  def self.coordinates_for(position)
    letter_x, letter_y = position.chars
    x = letter_x.upcase.bytes.first - 'A'.bytes.first
    y = letter_y.to_i - 1 # Classic -1: index starting at 0

    [x, y] # TODO: raise unless include
  end

  def self.delta_coordinates(start_tile, destination_tile)
    start_x, start_y = coordinates_for(start_tile.position)
    destination_x, destination_y = coordinates_for(destination_tile.position)
    delta_x = destination_x - start_x
    delta_y = destination_y - start_y

    [delta_x, delta_y]
  end

  # TODO: instance method
  def self.include?(tile)
    ('A'..'G').to_a.include?(tile.letter) &&
      (1..8).to_a.include?(tile.number)
  end

  def initialize(matrix = self.class.initial_disposition)
    @matrix = matrix
  end

  def tile_at(position)
    x, y = self.class.coordinates_for(position)
    row = matrix[y]

    row[x]
  end

  private

  # NOTE: Access is matrix[y][x] (first access the row)
  attr_reader :matrix
end

# Tile -> [Piece]
class Tile
  def initialize(position, piece = Pieces::Null.new)
    @position, @piece = position, piece
  end

  attr_reader :position
  attr_accessor :piece

  def inspect
    "#<#{self.class}:#{position}>"
  end

  def ==(other_tile)
    other_tile.position == position
  end

  def occupied?
    piece.present?
  end

  def coordinates_delta(other_tile)
    x, y = Board.coordinates_for(position) # FIXME: dep direction
    other_x, other_y = Board.coordinates_for(other_tile.position)

    [(other_x - x), (other_y - y)]
  end

  # TODO: tmp

  def letter
    position.chars.first
  end

  def number
    position.chars.last.to_i
  end
end

# Board and Tile
##############################################################################
# Pieces

# Pieces -> [Piece]
module Pieces
  class Abstract
    def initialize
      @id = rand # TODO: optional naming
    end

    attr_reader :id

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

  class Null < Abstract
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

MOVING_RULES = {
  Pieces::Null => Moves::Null,
  Pieces::Pawn => Moves::Pawn
}
