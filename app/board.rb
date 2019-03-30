# Board -> [Tile, Pieces]
class Board
  def self.initial_disposition
    _, p = Pieces::Null, Pieces::Pawn
    t, n, b, q, k = Pieces::Tower, Pieces::Knight, Pieces::Bishop, Pieces::Queen, Pieces::King
    [ # A B  C  D  E  F  G  H  - Black
      [t, n, b, q, k, b, n, t].each_with_index.map { |pc, x| tile_for([x, 7], pc) },
      [p, p, p, p, p, p, p, p].each_with_index.map { |pc, x| tile_for([x, 6], pc) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |pc, x| tile_for([x, 5], pc) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |pc, x| tile_for([x, 4], pc) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |pc, x| tile_for([x, 3], pc) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |pc, x| tile_for([x, 2], pc) },
      [p, p, p, p, p, p, p, p].each_with_index.map { |pc, x| tile_for([x, 1], pc) },
      [t, n, b, q, k, b, n, t].each_with_index.map { |pc, x| tile_for([x, 0], pc) },
    ].reverse #                - White
  end

  # TODO? move to Tile.new ?
  def self.tile_for(coordinates, piece_class)
    position_value = Position.from_coordinates(coordinates).to_s
    piece = piece_class.new(position_value)

    Tile.new(position_value, piece)
  end

  def initialize(matrix = self.class.initial_disposition)
    @matrix = matrix
  end

  #      .A .B .C .D .E .F .G .H
  # | .8 Pa Kn Bi Pa Ki Bi Kn Pa 8. |
  # | .7 Pa Pa Pa Pa Pa Pa Pa Pa 7. |
  # | .6 __ __ __ __ __ __ __ __ 6. |
  # | .5 __ __ __ __ __ __ __ __ 5. |
  # | .4 __ __ __ __ __ __ __ __ 4. |
  # | .3 __ __ __ __ __ __ __ __ 3. |
  # | .2 Pa Pa Pa Pa Pa Pa Pa Pa 2. |
  # | .1 Pa Kn Bi Pa Ki Bi Kn Pa 1. |
  #      .A .B .C .D .E .F .G .H
  def to_s
    result = matrix.each_with_index.map do |row, y|
      center = row.map { |t| t.piece.to_sym }.join(" ")
      "| .#{y + 1} #{center} #{y + 1}. |"
    end.reverse.join("\n")

    [
      "\n     .A .B .C .D .E .F .G .H",
      result,
      "   .A .B .C .D .E .F .G .H"
    ].compact.join("\n")
  end

  def inspect
    "#<#{matrix}>"
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
