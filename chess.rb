# Moves -> [Move, Board, Tile]
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
      return false unless Board.include?(move.destination_tile)

      (!move.destination_tile.occupied? && valid_move_destination?) ||
        (move.destination_tile.occupied? && valid_attack?)
    end

    private

    attr_reader :move

    def valid_move_destination?
      move.start_tile.x == move.destination_tile.x &&
        move.destination_tile.x - move.start_tile.x <= 1
    end

    def valid_attack?
      (move.destination_tile.x - move.start_tile.x).abs == 1 &&
        (move.destination_tile.y - move.start_tile.y).abs == 1
    end
  end
end

# Move -> [Moves, Tile, Pieces]
class Move
  RULES = {
    "Pieces::Null" => Moves::Null,
    "Pieces::Pawn" => Moves::Pawn
  } # TODO: not strings

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
    RULES[moving_piece.class.to_s].new(self).call
  end
end

# Moves
##############################################################################
# Board and Tile

# Board -> [Move, Tile, Pieces]
# Borders starting from 0 to 7
class Board
  def self.include?(tile)
    (0..7).to_a.include?(tile.x) &&
      (0..7).to_a.include?(tile.y)
  end

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
    x, y = coordinates
    Tile.new(x, y, piece_class.new)
  end

  # TODO: Tile.new(position_for(coordinates), piece_class.new)
  # E.g.: [4, 5] -> 'E6'
  # def self.position_for(coordinates)

  # E.g.: 'E5' -> [4, 4]
  def self.coordinates_for(position)
    letter_x, letter_y = position.chars
    x = letter_x.upcase.bytes.first - 'A'.bytes.first
    y = letter_y.to_i - 1 # Classic -1: index starting at 0

    [x, y]
  end

  def initialize(matrix = self.class.initial_disposition)
    @matrix = matrix
  end

  def move(start_position, destination_position)
    move = Move.new(tile_at(start_position),
                    tile_at(destination_position))
    move.call
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
  def initialize(x, y, piece = Pieces::Null.new)
    @x, @y, @piece = x, y, piece
  end

  attr_reader :x, :y
  attr_accessor :piece

  def inspect
    "#<#{self.class}:#{x},#{y}>"
  end

  def ==(other_tile)
    other_tile.x == x && other_tile.y == y
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
