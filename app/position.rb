# TODO: descr
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
