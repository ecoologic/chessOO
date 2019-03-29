# Board -> [Tile, Pieces]
class Board
  def self.initial_disposition
    _, p, n, b, k = Pieces::Null, Pieces::Pawn, Pieces::Knight, Pieces::Bishop, Pieces::King
    [ # A B  C  D  E  F  G  H  - Black
      [p, n, b, k, p, b, n, p].each_with_index.map { |pc, x| tile_for([x, 7], pc) },
      [p, p, p, p, p, p, p, p].each_with_index.map { |pc, x| tile_for([x, 6], pc) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |pc, x| tile_for([x, 5], pc) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |pc, x| tile_for([x, 4], pc) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |pc, x| tile_for([x, 3], pc) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |pc, x| tile_for([x, 2], pc) },
      [p, p, p, p, p, p, p, p].each_with_index.map { |pc, x| tile_for([x, 1], pc) },
      [p, n, b, k, p, b, n, p].each_with_index.map { |pc, x| tile_for([x, 0], pc) },
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
