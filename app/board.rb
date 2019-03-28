# Board -> [Tile, Pieces]
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

  # TODO? move in Tile.new ?
  def self.tile_for(coordinates, piece_class)
    Tile.new(Position.from_coordinates(coordinates).to_s, piece_class.new(coordinates))
  end

  # TODO: instance method relative to board size
  def self.include?(tile)
    # TODO: tile.position.included?(board.max_coordinates)
    ('A'..'G').to_a.include?(tile.position.letter) &&
      (1..8).to_a.include?(tile.position.number)
  end

  def initialize(matrix = self.class.initial_disposition)
    @matrix = matrix
  end

  # TODO? move in Tile?
  def tile_at(position_value)
    x, y = Position.new(position_value).coordinates
    row = matrix[y]

    row[x]
  end

  private

  # NOTE: Access is matrix[y][x] (first access the row)
  attr_reader :matrix
end
