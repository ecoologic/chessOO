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
    "#<#{to_s}>"
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

  def all_between(destination_position)
    x_range = Range.new(*[destination_position.x, x].sort)
    y_range = Range.new(*[destination_position.y, y].sort)
    zipped = x_range.zip(y_range)

    result = zipped.map { |x, y| self.class.from_coordinates([x, y]) }
    result[1..result.length - 2] # Exclude start and destination
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
