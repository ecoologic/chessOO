# Board->Tile:
# Board->Position:
# Board->Pieces:
class Board
  def self.initial_disposition
    __, pa = Pieces::Null, Pieces::Pawn
    ro, kn, bi = Pieces::Rook, Pieces::Knight, Pieces::Bishop
    qu, ki = Pieces::Queen, Pieces::King

    [ #              A   B   C   D   E   F   G   H  - Black
      new_row([ro, kn, bi, qu, ki, bi, kn, ro], y: 7), # 8
      new_row([pa, pa, pa, pa, pa, pa, pa, pa], y: 6), # 7
      new_row([__, __, __, __, __, __, __, __], y: 5), # 6
      new_row([__, __, __, __, __, __, __, __], y: 4), # 5
      new_row([__, __, __, __, __, __, __, __], y: 3), # 4
      new_row([__, __, __, __, __, __, __, __], y: 2), # 3
      new_row([pa, pa, pa, pa, pa, pa, pa, pa], y: 1), # 2
      new_row([ro, kn, bi, qu, ki, bi, kn, ro], y: 0)  # 1
    ].reverse #      A   B   C   D   E   F   G   H  - White (after reverse)
  end

  def self.new_row(row, y:)
    row.each_with_index.map do |piece_class, x|
      position_value = Position.from_coordinates([x, y]).to_s
      piece = piece_class.new(position_value)

      Tile.new(position_value, piece)
    end
  end

  def initialize(matrix = self.class.initial_disposition)
    @matrix = matrix
  end

  def include?(position_value)
    position = Position.new(position_value)

    position.x <= last_position.x &&
      position.y <= last_position.y
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
