# Wraps the info 'A1' to provides helper methods
# like coordinates [x, y], distances etc
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

  def inspect
    "#<Position:#{to_s}>"
  end

  def to_s
    "#{letter}#{number}"
  end

  def ==(other_position)
    to_s == other_position.to_s
  end

  # 'B3' => [1, 2]
  def coordinates
    [x, y]
  end

  # TODO: Position::Delta ??
  def all_between(destination_position)
    if delta(destination_position).x.zero? || delta(destination_position).y.zero?
      all_between_along_axes(destination_position)
    else
      all_between_diagonal(destination_position)
    end
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

  # TODO: all_along_diagonal
  def all_between_diagonal(destination_position)
    x_range = Range.new(*[destination_position.x, x].sort)
    y_range = Range.new(*[destination_position.y, y].sort)
    zipped = x_range.zip(y_range)

    result = zipped.map { |x, y| self.class.from_coordinates([x, y]) }
    result[1..result.length - 2] # Exclude start and destination
  end

  def all_between_along_axes(destination_position)
    if letter == destination_position.letter
      # Loop numbers
      y_range = Range.new(*[destination_position.y, y].sort)
      result = y_range.map { |path_y| self.class.new("#{letter}#{path_y + 1}") }
      result[1..result.length - 2] # Exclude start and destination
    else
      # Loop letters
      x_range = Range.new(*[destination_position.x, x].sort)
      # TODO:
      [self.class.new('E1')]
    end
  end
end
