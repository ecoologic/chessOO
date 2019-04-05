# Board->Pieces:
# Board->Position:
#
# Stores where every piece is
class Board
  # Each cell of the board, binds the piece to its position
  # NOTE: mutable object
  class Tile
    def initialize(coordinates, piece_class = Pieces::Null)
      @position = Position.from_coordinates(coordinates)
      @piece = piece_class.new(position)
    end

    attr_reader :position
    attr_accessor :piece

    def ==(other_tile)
      position == other_tile.position
    end

    def occupied?
      piece.present?
    end
  end

  ############################################################################

  def self.initial_disposition
    __, pa = Pieces::Null, Pieces::Pawn
    ro, kn, bi = Pieces::Rook, Pieces::Knight, Pieces::Bishop
    qu, ki = Pieces::Queen, Pieces::King

    [ #            .A  .B  .C  .D  .E  .F  .G  .H - Black
      new_row([ro, kn, bi, qu, ki, bi, kn, ro], y: 7), # 8
      new_row([pa, pa, pa, pa, pa, pa, pa, pa], y: 6), # 7
      new_row([__, __, __, __, __, __, __, __], y: 5), # 6
      new_row([__, __, __, __, __, __, __, __], y: 4), # 5
      new_row([__, __, __, __, __, __, __, __], y: 3), # 4
      new_row([__, __, __, __, __, __, __, __], y: 2), # 3
      new_row([pa, pa, pa, pa, pa, pa, pa, pa], y: 1), # 2
      new_row([ro, kn, bi, qu, ki, bi, kn, ro], y: 0)  # 1
    ].reverse #    .A  .B  .C  .D  .E  .F  .G  .H - White
  end

  def self.new_row(row, y:)
    row.each_with_index.map do |piece_class, x|
      Tile.new([x, y], piece_class)
    end
  end

  def initialize(matrix = self.class.initial_disposition)
    @matrix = matrix
  end

  def include?(position_value)
    Position.new(position_value) <= last_position
  end

  def tile_at(position_value)
    x, y = Position.new(position_value).coordinates
    row = matrix[y]

    row[x]
  end

  def pieces_by_class(piece_class)
    matrix
      .flatten
      .select { |tile| tile.piece.class == piece_class }
  end

  private

  # NOTE: Access is matrix[y][x] (first access the row)
  attr_reader :matrix

  def last_position
    matrix.last.last.position
  end
end
