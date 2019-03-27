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

# TODO: 1) Split file; 2) Update diagram; 3) Tile -> Board?; 4) Board.new
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
      if !move.in_board?
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
      valid_move?
    end

    def first_occupied_tile
      move.destination_tile # FIXME: requires board instance var
    end

    def delta_x
      move.delta_position.x
    end

    def delta_y
      move.delta_position.y
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

  class Bishop < Moves::Abstract
    def valid_move?
      delta_x.abs == delta_y.abs &&
        first_occupied_tile == move.destination_tile
    end
  end
end

# Move -> [Moves, Tile]
class Move
  def initialize(start_tile, destination_tile)
    @start_tile, @destination_tile = start_tile, destination_tile
    @moving_piece = start_tile.piece
    raise RuntimeError, "Can't move an empty tile" unless start_tile.occupied?
  end

  attr_reader :start_tile, :destination_tile, :moving_piece

  def inspect
    "<#{start_tile} -> #{destination_tile}>"
  end

  # NOTE: Mutates the states of tiles at runtime, not idempotent method
  def call
    return unless can_move?

    start_tile.piece = Pieces::Null.new
    destination_tile.piece = moving_piece
  end

  def in_board?
    Board.include?(destination_tile)
  end

  def delta_position
    start_tile.position.delta(destination_tile.position)
  end

  private

  def can_move?
    MOVING_RULES[moving_piece.class].new(self).call
  end
end

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

# Moves
##############################################################################
# Board and Tile

class Position
  def self.from_coordinates(coordinate_couple)
    x, y = coordinate_couple
    letter_x = ('A'.bytes.first + x).chr
    number_y = y + 1

    new("#{letter_x}#{number_y}")
  end

  def initialize(value)
    @x = value.chars.first.upcase.bytes.first - 'A'.bytes.first
    @y = value.chars.last.to_i - 1 # Classic -1: index starting at 0
  end

  attr_reader :x, :y

  def to_s
    "#{letter}#{number}"
  end

  def ==(other_position)
    to_s == other_position.to_s
  end

  def coordinates
    [x, y]
  end

  def delta(destination_position)
    delta_x = destination_position.x - x
    delta_y = destination_position.y - y

    self.class.from_coordinates([delta_x, delta_y])
  end

  def letter
    ('A'.bytes.first + x).chr
  end

  def number
    y + 1
  end

  private

  attr_reader :value
end

# Board -> [Tile, Pieces]
# Borders starting from 0 to 7
# TODO? invert direction Tile <- Board ? has_many like?
class Board
  def self.initial_disposition
    _, p, b, k = Pieces::Null, Pieces::Pawn, Pieces::Bishop, Pieces::King
    [ # A B  C  D  E  F  G  H  - Black
      [p, p, b, k, p, b, p, p].each_with_index.map { |p, x| tile_for([x, 7], p) },
      [p, p, p, p, p, p, p, p].each_with_index.map { |p, x| tile_for([x, 6], p) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |p, x| tile_for([x, 5], p) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |p, x| tile_for([x, 4], p) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |p, x| tile_for([x, 3], p) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |p, x| tile_for([x, 2], p) },
      [p, p, p, p, p, p, p, p].each_with_index.map { |p, x| tile_for([x, 1], p) },
      [p, p, b, k, p, b, p, p].each_with_index.map { |p, x| tile_for([x, 0], p) },
    ].reverse #                - White
  end

  def self.tile_for(coordinates, piece_class)
    Tile.new(Position.from_coordinates(coordinates).to_s, piece_class.new(coordinates))
  end

  # TODO: instance method relative to board size
  def self.include?(tile)
    ('A'..'G').to_a.include?(tile.position.letter) &&
      (1..8).to_a.include?(tile.position.number)
  end

  def initialize(matrix = self.class.initial_disposition)
    @matrix = matrix
  end

  # TODO? invert direction Board <-> Tile ?
  def tile_at(position_value)
    x, y = Position.new(position_value).coordinates
    row = matrix[y]

    row[x]
  end

  private

  # NOTE: Access is matrix[y][x] (first access the row)
  attr_reader :matrix
end

# Tile -> [Piece]
# NOTE: mutable object
class Tile
  def initialize(position_value, piece = Pieces::Null.new)
    @position = Position.new(position_value)
    @position_value = position_value # TODO: remove in tests
    @piece = piece
  end

  attr_reader :position, :position_value
  attr_accessor :piece

  def inspect
    "#<#{self.class}:#{position_value}>"
  end

  def ==(other_tile)
    position == other_tile.position
  end

  def occupied?
    piece.present?
  end
end

# Board and Tile
##############################################################################
# Pieces

# Pieces -> [Piece]
module Pieces
  class Abstract
    # TODO: remove optional
    def initialize(id = rand)
      @id = "#{self.class}##{id}"
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
  class Bishop < Abstract; end

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
  Pieces::Pawn => Moves::Pawn,
  Pieces::Bishop => Moves::Bishop
}
