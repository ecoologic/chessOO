# Wraps the info 'A1' to provides helper methods
# like coordinates [x, y], distances etc
class Position
  class Delta
    def initialize(position_a, position_b)
      @position_a, @position_b = position_a, position_b
    end

    # TODO: all_along_diagonal
    def all_between_diagonal
      x_range = Range.new(*[position_a.x, position_b.x].sort)
      y_range = Range.new(*[position_a.y, position_b.y].sort)
      zipped = x_range.zip(y_range)

      result = zipped.map { |x, y| Position.from_coordinates([x, y]) }
      result[1..result.length - 2] # Exclude start and destination
    end

    # TODO: +1 below...
    def all_between_along_axes
      if position_a.letter == position_b.letter
        # Loop numbers
        y_range = Range.new(*[position_a.y, position_b.y].sort)
        result = y_range.map { |path_y| Position.new("#{position_a.letter}#{path_y + 1}") }
        result[1..result.length - 2] # Exclude start and destination
      else
        # Loop letters
        x_range = Range.new(*[position_a.x, position_b.x].sort)
        # TODO:
        [Position.new('E1')]
      end
    end

    def all_between
      if delta.x.zero? || delta.y.zero?
        all_between_along_axes
      else
        all_between_diagonal
      end
    end

    def delta
      delta_x = position_b.x - position_a.x
      delta_y = position_b.y - position_a.y

      Position.from_coordinates([delta_x, delta_y])
    end

    private

    attr_reader :position_a, :position_b
  end

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

  def letter
    ('A'.bytes.first + x).chr
  end

  def number
    y + 1
  end

  # TODO: delete
  def all_between_diagonal(destination_position)
    Delta.new(self, destination_position).all_between_diagonal
  end

  def all_between_along_axes(destination_position)
    Delta.new(self, destination_position).all_between_along_axes
  end

  def all_between(destination_position)
    Delta.new(self, destination_position).all_between
  end

  def delta(destination_position)
    Delta.new(self, destination_position).delta
  end

  private

  attr_reader :value
end
